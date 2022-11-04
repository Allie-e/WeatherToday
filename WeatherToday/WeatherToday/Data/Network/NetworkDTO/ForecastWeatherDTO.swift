//
//  ForecastWeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation

struct ForecastWeatherDTO: Codable {
    let lat: Double
    let lon: Double
    let hourly: [HourlyWeatherDTO]
    let daily: [DailyWeatherDTO]
}
