//
//  CurrentWeatherViewModel.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/25.
//

import Foundation
import RxSwift
import CoreLocation

final class WeatherViewModel: ViewModelDescribing {
    struct Input {
        let loadLocation: Observable<[CLLocation]>
        let viewDidLoad: Observable<Void>
        let updateNewLocation: Observable<Coordinate>
    }
    
    struct Output {
        let loadCurrentWeather: Observable<CurrentWeather?>
        let loadForecastWeather: Observable<ForecastWeather?>
        let updateNewCurrentWeather: Observable<CurrentWeather?>
        let updateNewForecastWeather: Observable<ForecastWeather?>
    }
    
    let coord: Coordinate
    private let currentWeatherUseCase = CurrentWeatherUseCase()
    private let forecastWeatherUseCase = ForecastWeatherUseCase()
    private let disposeBag: DisposeBag = .init()
    
    init(coord: Coordinate) {
        self.coord = coord
    }
    
    func transform(_ input: Input) -> Output {
        let currentWeather = input.viewDidLoad
            .withUnretained(self)
            .flatMap({ owner, _ -> Observable<CurrentWeather?> in
                return owner.fetchCurrentWeather(with: owner.coord.latitude, owner.coord.longitude)
            })
        
        let forecastWeather = input.viewDidLoad
            .withUnretained(self)
            .flatMap({ owner, _ -> Observable<ForecastWeather?> in
                return owner.fetchForecastWeather(with: owner.coord.latitude, owner.coord.longitude)
            })
        
        let newCurrentWeather = input.updateNewLocation
            .withUnretained(self)
            .flatMap({ owner, location -> Observable<CurrentWeather?> in
                return owner.fetchCurrentWeather(with: location.latitude, location.longitude)
            })
        
        let newForecastWeather = input.updateNewLocation
            .withUnretained(self)
            .flatMap({ owner, location -> Observable<ForecastWeather?> in
                return owner.fetchForecastWeather(with: location.latitude, location.longitude)
            })
        
        return Output(loadCurrentWeather: currentWeather, loadForecastWeather: forecastWeather, updateNewCurrentWeather: newCurrentWeather, updateNewForecastWeather: newForecastWeather)
    }
    
    private func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return currentWeatherUseCase.fetchCurrentWeather(with: latitude, longitude)
    }
    
    private func fetchForecastWeather(with latitude: Double, _ longitude: Double) -> Observable<ForecastWeather?> {
        return forecastWeatherUseCase.fetchForecastWeather(with: latitude, longitude)
    }
}
