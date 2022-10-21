//
//  EndPoint.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/21.
//

import Foundation

enum EndPoint {
    private static let currentWeatherPath = "https://api.openweathermap.org/data/2.5/weather"
    private static let apiKey = "538f37ab841f4af5455c795ee0ad8e49"
    
    case currentWeather(Double, Double)
    
    var url: URL? {
        switch self {
        case .currentWeather(let lat, let lon):
            var components = URLComponents(string: EndPoint.currentWeatherPath)
            let latQuery = URLQueryItem(name: "lat", value: lat.description)
            let lonQuery = URLQueryItem(name: "lon", value: lon.description)
            let appidQuery = URLQueryItem(name: "appid", value: EndPoint.apiKey)
            components?.queryItems = [latQuery, lonQuery, appidQuery]
            
            return components?.url
        }
    }
}