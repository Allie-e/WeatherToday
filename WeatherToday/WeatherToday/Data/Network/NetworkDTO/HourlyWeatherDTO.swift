//
//  HourlyWeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation

struct HourlyWeatherDTO: Codable {
    let dt: Int
    let temp: Double
    let weather: [WeatherDTO]
}
