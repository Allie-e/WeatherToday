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
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    func toDomain() -> Current {
        let weather = weather.map { $0.toDomain() }

        return Current(
            coord: coord.toDomain(),
            weather: weather,
            main: main.toDomain(),
            timezone: timezone,
            id: id,
            name: name,
            cod: cod)
    }
}

// MARK: - CoordDTO
struct CoordDTO: Codable {
    let lon: Double
    let lat: Double
    
    func toDomain() -> Coord {
        return Coord(
            lon: lon,
            lat: lat)
    }
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
    
    func toDomain() -> Main {
        return Main(
            temp: temp,
            feelsLike: feelsLike,
            tempMin: tempMin,
            tempMax: tempMax)
    }
}
