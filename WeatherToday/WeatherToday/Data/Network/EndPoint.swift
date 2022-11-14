//
//  EndPoint.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/21.
//

import Foundation

enum EndPoint {
    private static let currentWeatherPath = "https://api.openweathermap.org/data/2.5/weather"
    private static let forecastWeatherPath =  "https://api.openweathermap.org/data/2.5/onecall"
    private static let apiKey = "538f37ab841f4af5455c795ee0ad8e49"
    
    case currentWeather(Double, Double)
    case forecastWeather(Double, Double)
    
    var url: URL? {
        switch self {
        case .currentWeather(let lat, let lon):
            var components = URLComponents(string: EndPoint.currentWeatherPath)
            let latQuery = URLQueryItem(name: "lat", value: lat.description)
            let lonQuery = URLQueryItem(name: "lon", value: lon.description)
            let appidQuery = URLQueryItem(name: "appid", value: EndPoint.apiKey)
            let unitsQuery = URLQueryItem(name: "units", value: "metric")
            components?.queryItems = [latQuery, lonQuery, appidQuery, unitsQuery]
            
            return components?.url
            
        case .forecastWeather(let lat, let lon):
            var components = URLComponents(string: EndPoint.forecastWeatherPath)
            let latQuery = URLQueryItem(name: "lat", value: lat.description)
            let lonQuery = URLQueryItem(name: "lon", value: lon.description)
            let appidQuery = URLQueryItem(name: "appid", value: EndPoint.apiKey)
            let unitsQuery = URLQueryItem(name: "units", value: "metric")
            components?.queryItems = [latQuery, lonQuery, appidQuery, unitsQuery]
            
            return components?.url
        }
    }
}
