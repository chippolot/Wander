//
//  FakeLocationManager.swift
//  WanderTests
//
//  Created by Ben on 11/26/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import RxSwift

@testable import Wander

class FakeLocationManager: LocationManagerProtocol, Spryable {
    enum ClassFunction: String, StringRepresentable {
        case empty
    }
    
    enum Function: String, StringRepresentable {
        case requestPermissions = "requestPermissions()"
        case startUpdatingLocation = "startUpdatingLocation()"
        case stopUpdatingLocation = "stopUpdatingLocation()"
        case userLocation = "userLocation"
        case userLocationObservable = "userLocationObservable"
    }
    
    func requestPermissions() {
        return spryify()
    }
    
    func startUpdatingLocation() {
        return spryify()
    }
    
    func stopUpdatingLocation() {
        return spryify()
    }
    
    var userLocation: Location? {
        return stubbedValue()
    }
    
    var userLocationObservable: Observable<Location?> {
        return stubbedValue()
    }
}
