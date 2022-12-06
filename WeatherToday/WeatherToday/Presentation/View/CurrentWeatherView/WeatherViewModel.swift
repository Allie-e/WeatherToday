//
//  CurrentWeatherViewModel.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/25.
//

import Foundation
import RxSwift
import CoreLocation

final class WeatherViewModel: ViewModelDescribing {
    final class Input {
        let loadLocation: Observable<[CLLocation]>
        
        init(loadLocation: Observable<[CLLocation]>) {
            self.loadLocation = loadLocation
        }
    }
    
    final class Output {
        let loadCurrentWeather: Observable<CurrentWeather?>
        let loadForecastWeather: Observable<ForecastWeather?>
        
        init(loadCurrentWeather: Observable<CurrentWeather?>, loadForecastWeather: Observable<ForecastWeather?>) {
            self.loadCurrentWeather = loadCurrentWeather
            self.loadForecastWeather = loadForecastWeather
        }
    }
    
    private let currentWeatherUseCase = CurrentWeatherUseCase()
    private let forecastWeatherUseCase = ForecastWeatherUseCase()
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
        
        let forecastWeather = input.loadLocation
            .withUnretained(self)
            .flatMap({ owner, location -> Observable<ForecastWeather?> in
                guard let location = location.first else {
                    return Observable.empty()
                }
                
                return owner.fetchForecastWeather(with: location.coordinate.latitude, location.coordinate.longitude)
            })
        
        return Output(loadCurrentWeather: currentWeather, loadForecastWeather: forecastWeather)
    }
    
    private func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return currentWeatherUseCase.fetchCurrentWeather(with: latitude, longitude)
    }
    
    private func fetchForecastWeather(with latitude: Double, _ longitude: Double) -> Observable<ForecastWeather?> {
        return forecastWeatherUseCase.fetchForecastWeather(with: latitude, longitude)
    }
}
