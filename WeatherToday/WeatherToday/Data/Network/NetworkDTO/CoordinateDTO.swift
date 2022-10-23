//
//  CoordinateDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/23.
//

import Foundation

struct CoordinateDTO: Codable {
    let lon: Double
    let lat: Double
    
    func toDomain() -> Coordinate {
        return Coordinate(
            lon: lon,
            lat: lat)
    }
}
