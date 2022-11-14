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
        
        init(loadCurrentWeather: Observable<CurrentWeather?>, loadHourlyWeather: Observable<[HourlyWeather]?>) {
            self.loadCurrentWeather = loadCurrentWeather
            self.loadHourlyWeather = loadHourlyWeather
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
        
        return Output(loadCurrentWeather: currentWeather, loadHourlyWeather: hourlyWeather)
    }
    
    private func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return currentWeatherUseCase.fetchCurrentWeather(with: latitude, longitude)
    }
    
    private func fetchHourlyWeather(with latitude: Double, _ longitude: Double) -> Observable<[HourlyWeather]?> {
        return forecastWeatherUseCase.fetchHourlyWeather(with: latitude, longitude)
    }
}
