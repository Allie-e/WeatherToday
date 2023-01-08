//
//  ForecastWeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation

struct ForecastWeatherDTO: Decodable {
    let lat: Double
    let lon: Double
    let hourly: [HourlyWeatherDTO]
    let daily: [DailyWeatherDTO]
    
    func toDomain() -> ForecastWeather {
        let hourly = hourly.map { $0.toDomain() }
        let daily = daily.map { $0.toDomain() }
        
        return ForecastWeather(
            latitude: lat,
            longitude: lon,
            hourly: hourly,
            daily: daily)
    }
}
