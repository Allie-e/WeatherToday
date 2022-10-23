//
//  WeatherAPI.swift
//  WeatherToday
//
//  Created by Allie on 2022/10/23.
//

import Foundation
import Alamofire
import RxSwift

final class WeatherAPI {
    func fetch(with url: URL?) -> Observable<Data> {
        guard let url = url else {
            return .error(NetworkError.invalidURL)
        }
        
        return Observable.create { emitter in
            let request = AF.request(url)
                .validate(statusCode: 200..<300)
                .responseData { dataResponse in
                    switch dataResponse.result {
                    case .success(let data):
                        emitter.onNext(data)
                    case .failure(_):
                        emitter.onError(NetworkError.requestError)
                    }
                    emitter.onCompleted()
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
