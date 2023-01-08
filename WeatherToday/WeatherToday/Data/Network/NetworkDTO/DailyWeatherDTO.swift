//
//  DailyWeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation

struct DailyWeatherDTO: Decodable {
    let dt: Int
    let temp: DailyTemperatureDTO
    let weather: [WeatherDTO]
    
    func toDomain() -> DailyWeather {
        let weather = weather.map { $0.toDomain() }
        
        return DailyWeather(
            dt: dt,
            temperature: temp.toDomain(),
            weather: weather)
    }
}
