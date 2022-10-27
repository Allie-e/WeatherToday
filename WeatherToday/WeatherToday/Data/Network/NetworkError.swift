//
//  NetworkError.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/23.
//

import Foundation

enum NetworkError: Error {
    case requestError
    case invalidURL
    
    var description: String {
        switch self {
        case .requestError:
            return "ERROR: request error"
        case .invalidURL:
            return "ERROR: invalid URL"
        }
    }
}
