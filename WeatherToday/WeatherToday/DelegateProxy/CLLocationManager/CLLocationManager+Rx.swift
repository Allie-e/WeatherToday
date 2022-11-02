//
//  CLLocationManager+Rx.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/02.
//

import CoreLocation
import RxSwift
import RxCocoa

extension Reactive where Base: CLLocationManager {
    private var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocations: Observable<[CLLocation]> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base).didUpdateLocaionSubject.asObservable()
    }
    
    var didFailWithError: Observable<Error> {
        return RxCLLocationManagerDelegateProxy.proxy(for: base).didFailWithErrorSubject.asObservable()
    }
}
