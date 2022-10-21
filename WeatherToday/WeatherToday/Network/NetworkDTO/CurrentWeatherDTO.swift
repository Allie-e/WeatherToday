//
//  CurrentWeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/21.
//

import Foundation

// MARK: - Current
struct Current: Codable {
    let coord: Coord
    let weather: [WeatherDTO]
    let main: Main
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}
