//
//  LocationManager.swift
//  WeatherToday
//
//  Created by Allie on 2023/01/05.
//

import Foundation
import CoreLocation

class LocationManager {
    static let shared = LocationManager()
    private let locationManager: CLLocationManager
    
    init() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func getCurrentLocation() -> Coordinate {
        Coordinate(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
    }
}
