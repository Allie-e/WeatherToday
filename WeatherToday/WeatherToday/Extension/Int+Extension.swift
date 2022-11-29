//
//  Int+Extension.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/09.
//

import Foundation

extension Int {
    func toDate() -> Date {
        let timeInterval = TimeInterval(self)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        return date
    }
}
