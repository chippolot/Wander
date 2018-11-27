//
//  WanderManagerSpec.swift
//  WanderTests
//
//  Created by Ben on 11/26/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Spry_Nimble

@testable import Wander

class WanderManagerSpec: QuickSpec {
    override func spec() {
        describe("WanderManager") {
            
            var subject: WanderManager!
            var locationManager: FakeLocationManager!
            
            beforeEach {
                locationManager = FakeLocationManager()
                subject = WanderManager(locationManager: locationManager)
            }
            
            context("not tracking") {
                it("has no active wander") {
                    expect(subject.activeWander).to(beNil())
                }
            }
            
            context("starts tracking") {
                var activeWander: WanderProtocol!
                
                beforeEach {
                    activeWander = subject.startWandering()
                }
                
                it("returns new wander") {
                    expect(activeWander).toNot(beNil())
                }
                
                it("reports active wander") {
                    expect(subject.activeWander).toNot(beNil())
                }
                
                it("begins tracking location") {
                    expect(locationManager).to(haveReceived(.startUpdatingLocation))
                }
            }
            
            context("stops tracking") {
                beforeEach {
                    subject.stopWandering()
                }
                
                it("clears active wander") {
                    expect(subject.activeWander).to(beNil())
                }
                
                it("begins tracking location") {
                    expect(locationManager).to(haveReceived(.stopUpdatingLocation))
                }
            }
        }
    }
}
