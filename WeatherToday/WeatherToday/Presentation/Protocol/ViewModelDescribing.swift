//
//  ViewModelDescribing.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/27.
//

import Foundation

protocol ViewModelDescribing {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
