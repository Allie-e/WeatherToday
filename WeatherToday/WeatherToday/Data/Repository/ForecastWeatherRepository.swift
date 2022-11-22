//
//  forecastWeatherRepository.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/04.
//

import Foundation
import RxSwift

final class ForecastWeatherRepository {
    func fetchForecastWeather(with latitude: Double, _ longitude: Double) -> Observable<ForecastWeather?> {
        let forecastWeather = WeatherAPI.shared.fetch(with: EndPoint.forecastWeather(latitude, longitude).url)
            .map { data -> ForecastWeather? in
                let decodedData = try? JSONDecoder().decode(ForecastWeatherDTO.self, from: data)
                
                return decodedData?.toDomain()
            }
        
        return forecastWeather
    }
}
