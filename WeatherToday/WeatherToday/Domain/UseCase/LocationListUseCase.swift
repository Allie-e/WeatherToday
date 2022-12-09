//
//  LocationListUseCase.swift
//  WeatherToday
//
//  Created by Allie on 2022/12/09.
//

import Foundation
import RxSwift

final class LocationListUseCase {
    private let currentWeatherRepository = CurrentWeatherRepository()
    
    func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return currentWeatherRepository.fetchCurrentWeather(with: latitude, longitude)
    }
}
