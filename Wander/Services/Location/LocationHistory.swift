//
//  LocationHistory.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import RxSwift

protocol LocationHistoryProtocol {
    var locationHistoryObservable: Observable<[Location]> { get }
}

class LocationHistory: LocationHistoryProtocol {
    private let locationManager: LocationManagerProtocol
    private let locationHistory = Variable<[Location]>([])
    private let disposeBag = DisposeBag()
    
    var locationHistoryObservable: Observable<[Location]> {
        return locationHistory.asObservable()
    }
    
    init(locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
        
        self.locationManager.userLocationObservable.subscribe(onNext: { [weak self] location in
            guard let `self` = self, let location = location else { return }
            self.locationHistory.value += [location]
        }).disposed(by: disposeBag)
    }
}
