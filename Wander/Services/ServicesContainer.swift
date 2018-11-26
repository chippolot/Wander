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
            container.register(LocationAPIProtocol.self) { r in
                return LocationAPI()
            }.inObjectScope(.container)
        
            container.register(UserLocationProviderProtocol.self) { r in
                let locationAPI = r.resolve(LocationAPIProtocol.self)!
                return UserLocationProvider(locationAPI: locationAPI)
                }.inObjectScope(.container)
            
            container.storyboardInitCompleted(MainScreenViewController.self) { r, c in
            }
        }
    }
}
