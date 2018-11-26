//
//  UserLocationProvider.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import RxSwift

protocol UserLocationProviderProtocol {
    var userLocationObservable: Observable<Location?> { get }
}

class UserLocationProvider: UserLocationProviderProtocol, CLLocationManagerDelegate {
    let locationAPI: LocationAPIProtocol
    let userLocation: Variable<Location?>
    
    var userLocationObservable: Observable<Location?> {
        return self.userLocation.asObservable()
    }
    
    init(locationAPI: LocationAPIProtocol) {
        self.locationAPI = locationAPI
        self.userLocationSubject = Variable<Location>(nil)
    }
}
