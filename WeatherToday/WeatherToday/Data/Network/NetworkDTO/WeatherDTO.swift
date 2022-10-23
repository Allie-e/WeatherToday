//
//  WeatherDTO.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/21.
//

import Foundation

struct WeatherDTO: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    func toDomain() -> Weather {
        return Weather(
            id: id,
            main: main,
            weatherDescription: weatherDescription,
            icon: icon)
    }
}
