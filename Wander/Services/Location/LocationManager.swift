//
//  LocationAPI.swift
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
    
    var userLocationObservable: Observable<Location?> { get }
}

class LocationManager: NSObject, LocationManagerProtocol {
    private let locationManager = CLLocationManager()
    private let userLocation: Variable<Location?> = Variable<Location?>(nil)
    
    public var userLocationObservable: Observable<Location?> {
        return self.userLocation.asObservable()
    }
    
    override init() {
        self.locationManager.activityType = .fitness
        self.locationManager.distanceFilter = 10
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        super.init()
    }
    
    func requestPermissions() {
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    func startUpdatingLocation() {
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdatingLocation() {
        DispatchQueue.main.async {
            self.locationManager.stopUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach{ location in
            self.userLocation.value = location
        }
    }
}
