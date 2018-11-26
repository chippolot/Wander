//
//  MainScreenViewController.swift
//  Wander
//
//  Created by Ben on 11/25/18.
//  Copyright © 2018 Ben. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

//TODO: Setup core data
//TODO: Show wander info on screen
class MainScreenViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: LocationManagerProtocol!
    var locationHistory: LocationHistoryProtocol!
    
    private var currentPath: MKPolyline?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestPermissions()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationHistory.locationHistoryObservable.subscribe(onNext: { [weak self] locations in
            guard let `self` = self else { return }
            
            if let currentPath = self.currentPath {
                self.mapView.removeOverlay(currentPath)
            }
            
            let coordinates = locations.map{ $0.coordinate }
            self.currentPath = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.addOverlay(self.currentPath!)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}

extension MainScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let coordinate = userLocation.location!.coordinate
        mapView.centerCoordinate = coordinate
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.red
            pr.lineWidth = 5
            return pr
        }
        return MKOverlayRenderer()
    }
}
