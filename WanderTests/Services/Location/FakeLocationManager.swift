//
//  FakeLocationManager.swift
//  WanderTests
//
//  Created by Ben on 11/26/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import RxSwift
import Spry

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
        return spryify(fallbackValue: Void())
    }
    
    func startUpdatingLocation() {
        return spryify(fallbackValue: Void())
    }
    
    func stopUpdatingLocation() {
        return spryify(fallbackValue: Void())
    }
    
    var userLocation: Location? {
        return stubbedValue(fallbackValue: nil)
    }
    
    var userLocationObservable: Observable<Location?> {
        return stubbedValue(fallbackValue: Observable.never())
    }
}
