//
//  ServicesContainer.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

struct ServicesContainer {
    static func create() -> Container {
        return Container() { container in
            container.register(LocationManagerProtocol.self) { r in
                return LocationManager()
                }.inObjectScope(.container)
            
            container.register(LocationHistoryProtocol.self) { r in
                let locationManager = r.resolve(LocationManagerProtocol.self)!
                return LocationHistory(locationManager: locationManager)
                }.inObjectScope(.container)
            
            container.storyboardInitCompleted(MainScreenViewController.self) { r, c in
                c.locationManager = r.resolve(LocationManagerProtocol.self)!
                c.locationHistory = r.resolve(LocationHistoryProtocol.self)!
            }
        }
    }
}
