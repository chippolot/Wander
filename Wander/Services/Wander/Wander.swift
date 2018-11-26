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

protocol WanderProtocol {
    var path: [Location] { get }
    var pathObservable: Observable<[Location]> { get }
    
    var stats: WanderStats { get }
    var statsObservable: Observable<WanderStats> { get }
}

struct WanderStats: Equatable, Codable, CustomStringConvertible {
    var startTime: Date = Date()
    var duration: DurationSeconds { return Date().timeIntervalSince(startTime) }
    
    var distance: DistanceMeters = 0
    var elevationGain: DistanceMeters = 0
    
    var description: String {
        return String(format: "{ duration:%.2fs, distance:%.2fm), elevationGain:%.2fm }", duration, distance, elevationGain)
    }
}

class Wander: WanderProtocol {
    
    var path: [Location] { return pathSubject.value }
    var pathObservable: Observable<[Location]> { return pathSubject.asObservable() }
    
    var stats: WanderStats { return statsSubject.value }
    var statsObservable: Observable<WanderStats> { return statsSubject.asObservable()  }
    
    private let locationManager: LocationManagerProtocol
    private let statsSubject: Variable<WanderStats> = Variable<WanderStats>(WanderStats())
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
    func update(withLocation location: Location) {
        let oldPath = path
        var currentStats = stats
        
        if let lastLocation = oldPath.last {
            currentStats.distance += location.distance(from: lastLocation)
            currentStats.elevationGain += max(0, location.altitude - lastLocation.altitude)
            statsSubject.value = currentStats
        }
        
        let newPath = oldPath + [location]
        pathSubject.value = newPath
    }
}
