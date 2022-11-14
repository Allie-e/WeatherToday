//
//  forecastWeatherRepository.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation
import RxSwift

final class ForecastWeatherRepository {
    func fetchHourlyWeather(with latitude: Double, _ longitude: Double) -> Observable<[HourlyWeather]?> {
        let hourlyWeather = WeatherAPI.shared.fetch(with: EndPoint.forecastWeather(latitude, longitude).url)
            .map { data -> [HourlyWeather]? in
                let decodedData = try? JSONDecoder().decode(ForecastWeatherDTO.self, from: data)
                
                return decodedData?.toDomain().hourly
            }
        
        return hourlyWeather
    }
}
