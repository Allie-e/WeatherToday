//
//  WeatherToday++Bundle.swift
//  WeatherToday
//
//  Created by Allie on 2023/01/08.
//

import Foundation

extension Bundle {
    var apiKey: String {
           guard let file = self.path(forResource: "WeatherInfo", ofType: "plist") else { return "" }
           guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
           guard let key = resource["API_KEY"] as? String else {
               fatalError("API_KEY error")
           }
           return key
       }
}
