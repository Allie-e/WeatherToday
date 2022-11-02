//
//  CurrentWeatherViewModel.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/25.
//

import Foundation
import RxSwift
import CoreLocation


final class CurrentWeatherViewModel: ViewModelDescribing {
    final class Input {
        let loadLocation: Observable<[CLLocation]>
        
        init(loadLocation: Observable<[CLLocation]>) {
            self.loadLocation = loadLocation
        }
    }
    
    final class Output {
        let loadCurrentWeather: Observable<CurrentWeather?>
        
        init(loadCurrentWeather: Observable<CurrentWeather?>) {
            self.loadCurrentWeather = loadCurrentWeather
        }
    }
    
    private let currentWeatherUseCase = CurrentWeatherUseCase()
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
        
        return Output(loadCurrentWeather: currentWeather)
    }
    
    private func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return currentWeatherUseCase.fetchCurrentWeather(with: latitude, longitude)
    }
}
