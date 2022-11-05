//
//  ForecastWeather.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation

struct ForecastWeather {
    let latitude: Double
    let longitude: Double
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}
