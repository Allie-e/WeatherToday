//
//  CurrentWeatherViewModel.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/25.
//

import Foundation
import RxSwift


final class CurrentWeatherViewModel: ViewModelDescribing {
    final class Input {
        let loadLocation: Observable<Coordinate>
        
        init(loadLocation: Observable<Coordinate>) {
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
            .flatMap({ owner, location in
                owner.fetchCurrentWeather(with: location.latitude, location.longitude)
            })
        
        return Output(loadCurrentWeather: currentWeather)
    }
    
    func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return currentWeatherUseCase.fetchCurrentWeather(with: latitude, longitude)
    }
}
