//
//  HourlyWeather.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation

struct HourlyWeather: Hashable {    
    let dt: Int
    let temperature: Double
    let weather: [Weather]
}
