//
//  MapViewController.swift
//  Advanced UI
//
//  Created by Student on 30/10/2018.
//  Copyright © 2018 agh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var city: City?
    let regionRadius: CLLocationDistance = 5000
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var header: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.title = city?.cityName
        let initialLocation  = CLLocation(
            latitude: (city?.location.latitude)!,
            longitude: (city?.location.longitude)!
        )
        centerMapOnLocation(location: initialLocation, marker: (city?.location)!)
    }
    
    func centerMapOnLocation(location: CLLocation, marker: Location) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius, longitudinalMeters: regionRadius
        )
        let locationMarker = MKPointAnnotation()
        locationMarker.coordinate = CLLocationCoordinate2D(
            latitude: marker.latitude,
            longitude: marker.longitude
        )
        locationMarker.title = city?.cityName
        map.setRegion(coordinateRegion, animated: true)
        map.addAnnotation(locationMarker)
    }

}
