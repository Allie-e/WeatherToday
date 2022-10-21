//
//  CurrentWeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/21.
//

import Foundation

// MARK: - CurrentDTO
struct CurrentDTO: Codable {
    let coord: CoordDTO
    let weather: [WeatherDTO]
    let main: MainDTO
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - CoordDTO
struct CoordDTO: Codable {
    let lon, lat: Double
}

// MARK: - MainDTO
struct MainDTO: Codable {
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
