//
//  MainScreenViewController.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import UIKit
import MapKit

//TODO: Should initialize both LocationManager AND MKMapView here?
//TODO: Setup core data
//TODO: Show wander info on screen
class MainScreenViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: LocationManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestPermissions()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MainScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let coordinate = userLocation.location!.coordinate
        mapView.centerCoordinate = coordinate
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: true)
    }
}
