//
//  LocationRepository.swift
//  WeatherToday
//
//  Created by Allie on 2022/12/27.
//

import Foundation
import RxSwift

final class LocationRepository {
    func fetchWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        let currentWeather = WeatherAPI.shared.fetch(with: EndPoint.currentWeather(latitude, longitude).url)
            .map { data -> CurrentWeather? in
                let decodedData = try? JSONDecoder().decode(CurrentWeatherDTO.self, from: data)
                
                return decodedData?.toDomain()
            }
        
        return currentWeather
    }
}
