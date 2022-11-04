//
//  DailyWeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation

struct DailyWeatherDTO: Codable {
    let dt: Int
    let temp: DailyTemperatureDTO
    let weather: [WeatherDTO]
}
