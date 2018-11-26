//
//  WanderManager.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation

protocol WanderManagerProtocol {
    var activeWander: WanderProtocol? { get }
    
    func startWandering() -> WanderProtocol
    func stopWandering()
}

class WanderManager: WanderManagerProtocol {
    private let locationManager: LocationManagerProtocol
    
    var activeWander: WanderProtocol?
    
    init(locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
    }
    
    func startWandering() -> WanderProtocol {
        locationManager.startUpdatingLocation()
        activeWander = Wander(locationManager: locationManager)
        return activeWander!
    }
    
    func stopWandering() {
        locationManager.stopUpdatingLocation()
        activeWander = nil
    }
}
