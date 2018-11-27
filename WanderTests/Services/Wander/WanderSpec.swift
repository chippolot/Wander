//
//  WanderSpec.swift
//  WanderTests
//
//  Created by Ben on 11/26/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Spry_Nimble
import RxSwift
import CoreLocation

@testable import Wander

class WanderSpec: QuickSpec {
    override func spec() {
        describe("Wander") {
            var subject: Wander!
            var locationManager: FakeLocationManager!
            var userLocationSubject: Variable<Location?>!
            
            beforeEach {
                userLocationSubject = Variable<Location?>(nil)
                locationManager = FakeLocationManager()
                locationManager.stub(.userLocationObservable).andReturn(userLocationSubject.asObservable())
                subject = Wander(locationManager: locationManager)
            }
            
            context("no location updates") {
                it("has empty path") {
                    expect(subject.path.count).to(be(0))
                }
                
                it("has uninitialized stats") {
                    expect(subject.stats.distance).to(equal(0))
                    expect(subject.stats.elevationGain).to(equal(0))
                }
            }
            
            context("single location update") {
                var location: Location!
                
                beforeEach {
                    location = self.locationWith(latitude: 0, longitude: 0, altitude: 0)
                    userLocationSubject.value = location
                }
                
                it("adds location to path") {
                    expect(subject.path.count).to(be(1))
                    expect(subject.path.first).to(be(location))
                }
            }
            
            context("multiple location updates") {
                it("records distance") {
                    let locations = [
                        self.locationWith(latitude: 0, longitude: 0, altitude: 0),
                        self.locationWith(latitude: 1, longitude: 0, altitude: 0),
                        self.locationWith(latitude: 1, longitude: 0.5, altitude: 0)
                    ]
                    
                    userLocationSubject.value = locations[0]
                    userLocationSubject.value = locations[1]
                    userLocationSubject.value = locations[2]
                    
                    let distance = locations[1].distance(from: locations[0]) + locations[2].distance(from: locations[1])
                    expect(subject.stats.distance).to(equal(distance))
                }
                
                it("records total elevation gain") {
                    userLocationSubject.value = self.locationWith(latitude: 0, longitude: 0, altitude: 0)
                    userLocationSubject.value = self.locationWith(latitude: 0, longitude: 0, altitude: 1)
                    
                    expect(subject.stats.elevationGain).to(equal(1))
                    
                    userLocationSubject.value = self.locationWith(latitude: 0, longitude: 0, altitude: 0)
                    userLocationSubject.value = self.locationWith(latitude: 0, longitude: 0, altitude: 1)
                    
                    expect(subject.stats.elevationGain).to(equal(2))
                }
            }
        }
    }
    
    private func locationWith(latitude: Double, longitude: Double, altitude: Double) -> Location {
        return Location(
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            altitude: altitude,
            horizontalAccuracy: 0,
            verticalAccuracy: 0,
            timestamp: Date(timeIntervalSince1970: 0))
    }
}
