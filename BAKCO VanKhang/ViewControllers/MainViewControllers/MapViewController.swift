//
//  MapViewController.swift
//  BAKCO VanKhang
//
//  Created by lou on 8/24/18.
//  Copyright © 2018 Lou. All rights reserved.
//

import Foundation
import GoogleMaps

class MapViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCoreLocationPermission()
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: MyLocation.lat, longitude: MyLocation.long, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: MyLocation.lat, longitude: MyLocation.long)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}
