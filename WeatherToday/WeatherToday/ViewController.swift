//
//  ViewController.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/19.
//

import UIKit
import CoreLocation
import RxSwift

class ViewController: UIViewController {
    var locationManager: CLLocationManager!
    var currentLocation: Coordinate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation?.latitude = location.coordinate.latitude
            currentLocation?.longitude = location.coordinate.latitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("GPS 권한 요청 거부됨")
            locationManager.requestWhenInUseAuthorization()
        default:
            print("GPS: Default")
        }
    }
}
