//
//  CurrentWeather.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/21.
//

import Foundation

// MARK: - Current
struct Current {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// MARK: - Coord
struct Coord {
    let lon: Double
    let lat: Double
}

// MARK: - Main
struct Main {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
}
