//
//  Wander.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation
import RxSwift

//TODO: Move to a more permanent home
typealias DurationSeconds = TimeInterval
typealias DistanceMeters = Double
typealias Percentage = Double

protocol WanderStatsProtocol {
    
    var duration: DurationSeconds { get }
    var distance: DistanceMeters { get }
    var elevationGain: DistanceMeters { get }
    var uniqueness: Percentage { get }
}

protocol WanderProtocol {
    var path: [Location] { get }
    var pathObservable: Observable<[Location]> { get }
    
    var stats: WanderStatsProtocol { get }
}

struct WanderStats: WanderStatsProtocol {
    let startTime: Date = Date()
    var duration: DurationSeconds { return startTime.timeIntervalSinceNow }
    let distance: DistanceMeters = 0
    let elevationGain: DistanceMeters = 0
    let uniqueness: Percentage = 0.0
}

class Wander: WanderProtocol {
    var path: [Location] { return pathSubject.value }
    var pathObservable: Observable<[Location]> { return pathSubject.asObservable() }
    let stats: WanderStatsProtocol = WanderStats()
    
    private let locationManager: LocationManagerProtocol
    private let pathSubject = Variable<[Location]>([])
    private let disposeBag = DisposeBag()
    
    init(locationManager: LocationManagerProtocol) {
        self.locationManager = locationManager
        
        if let userLocation = locationManager.userLocation {
            self.update(withLocation: userLocation)
        }
        
        locationManager.userLocationObservable.subscribe(onNext: { [weak self] location in
            guard let `self` = self, let location = location else { return }
            self.update(withLocation: location)
        }).disposed(by: disposeBag)
    }
    
    //TODO: Test this
    //TODO: Update stats
    func update(withLocation location: Location) {
        let newPath = self.pathSubject.value + [location]
        self.pathSubject.value = newPath
    }
}
