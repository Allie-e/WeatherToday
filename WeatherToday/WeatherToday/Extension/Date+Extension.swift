//
//  Date+Extension.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/09.
//

import Foundation

extension Date {
    func toHourString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h시"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        
        return formatter.string(from: self)
    }
    
    func toDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: self)
    }
}
