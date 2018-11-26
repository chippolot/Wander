//
//  LocationAPI.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationAPIProtocol {
    func requestPermissions()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

class LocationAPI: LocationAPIProtocol {
    private let locationManager = CLLocationManager()
    
    init() {
        self.locationManager.activityType = .fitness
        self.locationManager.distanceFilter = 10
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
