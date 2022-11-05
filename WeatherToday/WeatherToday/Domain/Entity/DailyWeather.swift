//
//  DailyWeather.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation

struct DailyWeather {
    let dt: Int
    let temperature: DailyTemperature
    let weather: [Weather]
}
