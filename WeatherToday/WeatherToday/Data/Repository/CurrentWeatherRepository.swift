//
//  CurrentWeatherRepository.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/23.
//

import Foundation
import RxSwift

final class CurrentWeatherRepository {
    func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        let currentWeather = WeatherAPI.shared.fetch(with: EndPoint.currentWeather(latitude, longitude).url)
            .map { data -> CurrentWeather? in
                let decodedData = try? JSONDecoder().decode(CurrentWeatherDTO.self, from: data)
                
                return decodedData?.toDomain()
        }
        
        return currentWeather
    }
}
