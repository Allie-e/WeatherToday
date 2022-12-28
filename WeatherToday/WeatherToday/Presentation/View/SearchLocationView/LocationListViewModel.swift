//
//  LocationListViewModel.swift
//  WeatherToday
//
//  Created by Allie on 2022/12/09.
//

import Foundation
import RxSwift
import CoreLocation

final class LocationListViewModel: ViewModelDescribing {
    struct Input {
        let loadLocation: Observable<[CLLocation]>
        let addNewLocation: Observable<Coordinate>
    }
    
    struct Output {
        let loadCurrentWeather: Observable<[CurrentWeather]>
        let addNewWeather: Observable<[CurrentWeather]>
    }
    
    private(set) var currentWeathers = [CurrentWeather]()
    private let locationListUseCase = LocationListUseCase()
    private let disposeBag: DisposeBag = .init()
    
    func transform(_ input: Input) -> Output {
        let currentWeather = input.loadLocation
            .withUnretained(self)
            .flatMap({ owner, location -> Observable<CurrentWeather?> in
                guard let location = location.first else {
                    return Observable.empty()
                }
                
                return owner.fetchCurrentWeather(with: location.coordinate.latitude, location.coordinate.longitude)
            })
            .map { weather -> [CurrentWeather] in
                self.saveCurrentWeathers(weathers: weather)
                return self.currentWeathers
            }
            
        
        let newWeather = input.addNewLocation
            .withUnretained(self)
            .flatMap({ owner, location -> Observable<CurrentWeather?> in
                return owner.fetchCurrentWeather(with: location.latitude, location.longitude)
            })
            .map { weathers -> [CurrentWeather] in
                self.saveCurrentWeathers(weathers: weathers)
                return self.currentWeathers
            }
        
        return Output(loadCurrentWeather: currentWeather, addNewWeather: newWeather)
    }
    
    private func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return locationListUseCase.fetchLocationWeather(with: latitude, longitude)
    }
    
    private func saveCurrentWeathers(weathers: CurrentWeather?) {
        guard let weathers = weathers else { return }
        currentWeathers.append(weathers)
    }
}
