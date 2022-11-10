//
//  Weather.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/21.
//

import Foundation

struct Weather: Hashable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
}
