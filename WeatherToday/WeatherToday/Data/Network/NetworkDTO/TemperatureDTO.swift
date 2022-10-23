//
//  MainDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/23.
//

import Foundation

struct TemperatureDTO: Codable {
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
    
    func toDomain() -> Temperature {
        return Temperature(
            current: temp,
            feelsLike: feelsLike,
            min: tempMin,
            max: tempMax)
    }
}
