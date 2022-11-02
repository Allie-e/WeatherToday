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
    let currentWeatherView = CurrentWeatherView()
    let viewModel = CurrentWeatherViewModel()
    let loadLocationObservable: PublishSubject<Coordinate> = .init()
    let disposeBag: DisposeBag = .init()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupCurrentWeatherViewLayout()
        setupLocationManager()
        bind()
    }
    
    private func bind() {
        let location = locationManager.rx.didUpdateLocations
        let input = CurrentWeatherViewModel.Input(loadLocation: location)
        let output = viewModel.transform(input)
        
        output.loadCurrentWeather
            .subscribe(onNext: { weather in
                guard let weather = weather else { return }
                self.currentWeatherView.setupLabelText(with: weather)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setupCurrentWeatherViewLayout() {
        view.addSubview(currentWeatherView)
        currentWeatherView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
        
    private func setupViewController() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        let colors = [
            UIColor(red: 93/255, green: 140/255, blue: 210/255, alpha: 1.0).cgColor,
            UIColor(red: 138/255, green: 217/255, blue: 237/255, alpha: 1.0).cgColor,
            UIColor(red: 186/255, green: 238/255, blue: 251/255, alpha: 1.0).cgColor
        ]
        
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.addSublayer(gradientLayer)
    }
}
