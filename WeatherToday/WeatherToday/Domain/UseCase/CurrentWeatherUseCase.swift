//
//  CurrentWeatherUseCase.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/25.
//

import Foundation
import RxSwift

final class CurrentWeatherUseCase {
    private let currentWeatherRepository = CurrentWeatherRepository()
    
    func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return currentWeatherRepository.fetchCurrentWeather(with: latitude, longitude)
    }
}
