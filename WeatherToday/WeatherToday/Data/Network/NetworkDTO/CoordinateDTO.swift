//
//  CoordinateDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/23.
//

import Foundation

struct CoordinateDTO: Codable {
    let lat: Double
    let lon: Double
    
    func toDomain() -> Coordinate {
        return Coordinate(
            latitude: lat,
            longitude: lon)
    }
}
