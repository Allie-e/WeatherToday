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
    
    func fetchForecastWeather(with latitude: Double, _ longitude) -> Observable<ForecastWeather?> {
        return forecastWeatherRepository.fetchForecastWeather(with: latitude, longitude)
    }
}
