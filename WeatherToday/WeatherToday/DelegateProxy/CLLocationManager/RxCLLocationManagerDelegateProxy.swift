//
//  RxCLLocationManagerDelegateProxy.swift
//  WeatherToday
//
//  Created by Allie on 2022/11/02.
//

import CoreLocation
import RxSwift
import RxCocoa

final class RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    
    let didUpdateLocaionSubject = PublishSubject<[CLLocation]>()
    let didFailWithErrorSubject = PublishSubject<Error>()
    
    init(locationManager: CLLocationManager) {
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }
    
    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager(manager, didUpdateLocations: locations)
        didUpdateLocaionSubject.onNext(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _forwardToDelegate?.locationManager(manager, didFailWithError: error)
        didFailWithErrorSubject.onNext(error)
    }
    
    deinit {
        self.didUpdateLocaionSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
    }
}
