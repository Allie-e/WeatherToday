//
//  CurrentWeatherViewModel.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/25.
//

import Foundation
import RxSwift


final class CurrentWeatherViewModel: ViewModelDescribing {
    final class Input {
        let viewWillAppear: Observable<Void>
        
        init(viewWillAppear: Observable<Void>) {
            self.viewWillAppear = viewWillAppear
        }
    }
    
    final class Output {
        let loadCurrentWeather: Observable<CurrentWeather?>
        
        init(loadCurrentWeather: Observable<CurrentWeather?>) {
            self.loadCurrentWeather = loadCurrentWeather
        }
    }
    
    private let currentWeatherUseCase = CurrentWeatherUseCase()
    private let disposeBag: DisposeBag = .init()
    
    func transform(_ input: Input) -> Output {
        let currentWeather = input.viewWillAppear
            .withUnretained(self)
            .flatMap({ owner, _ in
                owner.fetchCurrentWeather(with: 37.56667, 126.97806)
            })
        
        return Output(loadCurrentWeather: currentWeather)
    }
    
    func fetchCurrentWeather(with latitude: Double, _ longitude: Double) -> Observable<CurrentWeather?> {
        return currentWeatherUseCase.fetchCurrentWeather(with: latitude, longitude)
    }
}
