//
//  NetworkError.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/23.
//

import Foundation

enum NetworkError: Error {
    case requestError
    case serverError
    
    var description: String {
        switch self {
        case .requestError:
            return "ERROR: request error"
        case .serverError:
            return "ERROR: server error"
        }
    }
}
