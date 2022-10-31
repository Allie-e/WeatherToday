//
//  CoordinateDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/23.
//

import Foundation

struct CoordinateDTO: Codable {
    let latitude: Double
    let longitude: Double
    
    func toDomain() -> Coordinate {
        return Coordinate(
            latitude: latitude,
            longitude: longitude)
    }
}
