//
//  ForecastWeatherUseCase.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation
import RxSwift

final class ForecastWeatherUseCase {
    private let forecastWeatherRepository = ForecastWeatherRepository()
    
    func fetchForecastWeather(with latitude: Double, _ longitude: Double) -> Observable<ForecastWeather?> {
        return forecastWeatherRepository.fetchForecastWeather(with: latitude, longitude)
    }
}
