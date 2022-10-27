//
//  CurrentWeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/21.
//

import Foundation

struct CurrentWeatherDTO: Codable {
    let coord: CoordinateDTO
    let weather: [WeatherDTO]
    let main: TemperatureDTO
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    func toDomain() -> CurrentWeather {
        let weather = weather.map { $0.toDomain() }

        return CurrentWeather(
            coord: coord.toDomain(),
            weather: weather,
            temperature: main.toDomain(),
            timezone: timezone,
            id: id,
            name: name,
            cod: cod)
    }
}
