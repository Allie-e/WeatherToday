//
//  Double+Extension.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/25.
//

import Foundation

extension Double {
    func toRoundedString() -> String {
        let rounded = self.rounded()
        
        return String(Int(rounded))
    }
}
