//
//  LocationListUseCase.swift
//  WeatherToday
//
//  Created by Allie on 2022/12/09.
//

import Foundation
import RxSwift

final class LocationListUseCase {
    private let locationRepository = LocationRepository()
    
    func fetchLocationWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return locationRepository.fetchWeather(with: latitude, longitude)
    }
}
