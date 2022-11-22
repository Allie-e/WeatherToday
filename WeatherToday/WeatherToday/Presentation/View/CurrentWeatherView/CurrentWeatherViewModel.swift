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
        let loadHourlyWeather: Observable<[HourlyWeather]?>
        let loadDailyWeather: Observable<[DailyWeather]?>
        let loadForecast: Observable<ForecastWeather?>
        
        init(loadCurrentWeather: Observable<CurrentWeather?>, loadHourlyWeather: Observable<[HourlyWeather]?>, loadDailyWeather: Observable<[DailyWeather]?>, loadForecast: Observable<ForecastWeather?>) {
            self.loadCurrentWeather = loadCurrentWeather
            self.loadHourlyWeather = loadHourlyWeather
            self.loadDailyWeather = loadDailyWeather
            self.loadForecast = loadForecast
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
        
        let hourlyWeather = input.loadLocation
            .withUnretained(self)
            .flatMap({ owner, location -> Observable<[HourlyWeather]?> in
                guard let location = location.first else {
                    return Observable.empty()
                }
                
                return owner.fetchHourlyWeather(with: location.coordinate.latitude, location.coordinate.longitude)
            })
        
        let dailyWeather = input.loadLocation
            .withUnretained(self)
            .flatMap({ owner, location -> Observable<[DailyWeather]?> in
                guard let location = location.first else {
                    return Observable.empty()
                }
                
                return owner.fetchDailyWeather(with: location.coordinate.latitude, location.coordinate.longitude)
            })
        
        let forecastWeather = input.loadLocation
            .withUnretained(self)
            .flatMap({ owner, location -> Observable<ForecastWeather?> in
                guard let location = location.first else {
                    return Observable.empty()
                }
                
                return owner.fetchForecastWeather(with: location.coordinate.latitude, location.coordinate.longitude)
            })
        
        return Output(loadCurrentWeather: currentWeather, loadHourlyWeather: hourlyWeather, loadDailyWeather: dailyWeather, loadForecast: forecastWeather)
    }
    
    private func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return currentWeatherUseCase.fetchCurrentWeather(with: latitude, longitude)
    }
    
    private func fetchHourlyWeather(with latitude: Double, _ longitude: Double) -> Observable<[HourlyWeather]?> {
        return forecastWeatherUseCase.fetchHourlyWeather(with: latitude, longitude)
    }
    
    private func fetchDailyWeather(with latitude: Double, _ longitude: Double) -> Observable<[DailyWeather]?> {
        return forecastWeatherUseCase.fetchDailyWeather(with: latitude, longitude)
    }
    
    private func fetchForecastWeather(with latitude: Double, _ longitude: Double) -> Observable<ForecastWeather?> {
        return forecastWeatherUseCase.fetchForecastWeather(with: latitude, longitude)
    }
}
