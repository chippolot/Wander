//
//  LocationManager.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

protocol LocationManagerProtocol {
    func requestPermissions()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
    var userLocation: Location? { get }
    var userLocationObservable: Observable<Location?> { get }
}

class LocationManager: NSObject, LocationManagerProtocol {
    private let locationManager = CLLocationManager()
    private let userLocationSubject: Variable<Location?> = Variable<Location?>(nil)
    
    var userLocation: Location? {
        return userLocationSubject.value
    }
    var userLocationObservable: Observable<Location?> {
        return userLocationSubject.asObservable()
    }
    
    override init() {
        super.init()
        
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func requestPermissions() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func startUpdatingLocation() {
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdatingLocation() {
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.stopUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach{ location in
            userLocationSubject.value = location
        }
    }
}
