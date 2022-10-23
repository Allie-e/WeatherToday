//
//  CurrentWeather.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/21.
//

import Foundation

struct CurrentWeather {
    let coord: Coordinate
    let weather: [Weather]
    let temperature: Temperature
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
