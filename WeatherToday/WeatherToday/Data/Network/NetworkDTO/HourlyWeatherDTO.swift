//
//  HourlyWeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation

struct HourlyWeatherDTO: Decodable {
    let dt: Int
    let temp: Double
    let weather: [WeatherDTO]
    
    func toDomain() -> HourlyWeather {
        let weather = weather.map { $0.toDomain() }
        
        return HourlyWeather(
            dt: dt,
            temperature: temp,
            weather: weather)
    }
}
