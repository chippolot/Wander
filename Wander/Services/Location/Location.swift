//
//  Location.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import Foundation

struct Coordinate2D {
    let latitude: Double
    let longitude: Double
}

struct Location {
    let coordinate: Coordinate2D
    let altitude: Double
    let timestamp: Date
}
