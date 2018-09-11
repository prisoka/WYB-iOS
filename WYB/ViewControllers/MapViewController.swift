//
//  MapViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 10/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit
import MapKit //import the "MapKit" framework
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishWalkBtn: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var walkerLocation: UIButton!
    
    //create a Location Manager to be able to get the current location of the user, and set the Delegate on the class to be able to control this.
    var locationManager: CLLocationManager!
    
    //create a current location globally to be able to access is at any time
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //instantiate locationManager:
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        //and set the Delegate to self so we can manage it
        locationManager?.delegate = self
        //update the user's location:
//        enableLocation()
        
        // user activated automatic authorization info mode
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        //drawing path or route covered
        if let oldLocationNew = oldLocation as CLLocation?{
            let oldCoordinates = oldLocationNew.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.add(polyline)
        }
    }
    
    func mapView(_ mapView: MKMapView!, rendererFor overlay: MKOverlay!) -> MKOverlayRenderer! {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.red
            pr.lineWidth = 5
            return pr
        }
        return nil
    }
    
    //function to add annotation to map view
    func addAnnotationsOnMap(locationToPoint : CLLocation){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        let geoCoder = CLGeocoder ()
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks, placemarks.count > 0 {
                let placemark = placemarks[0]
                self.mapView.addAnnotation(annotation)
            }
        })
    }

    // ask permission to "walker" to get the location:
//    func enableLocation() {
//        let status = CLLocationManager.authorizationStatus()
//        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
//            // present an alert indicating location authorization required
//            // and offer to take the user to Settings for the app via
//            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
//            locationManager?.requestWhenInUseAuthorization()
//        }
//
//        // check if permission as given, using a built-in function:
//        if(CLLocationManager.locationServicesEnabled()) {
//            //start updating the location:
//            locationManager?.startUpdatingLocation()
//        }
//    }
//
    //setting up where to get the location from:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
        }
    }

    @IBAction func walkerLocation(_ : Any) {
        //with the user's current location, we can get the center of the Map View
        let center = currentLocation?.coordinate

        //and we can set the region:
//        let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        let regionRadius: CLLocationDistance = 1000
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(center!, regionRadius, regionRadius)

        //set the last view to this region using the built-in set region function:
//        self.mapView.setRegion(coordinateRegion, animated: true)

        //add an annotation with MK point built-in to se where exactly is the user at:
        let annotation = MKPointAnnotation()
        //set the annotation coordinate to the walker's coordinate
        annotation.coordinate = (currentLocation?.coordinate)!
        //set the title to Walker Location
        annotation.title = "Walker's location"
        //add this annotation to the MapView
        self.mapView.addAnnotation(annotation)

        //update the walker's address using geo coder
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation!) { (placemarks, error) -> Void in
            if (error) == nil {
                let placemark = placemarks![0] as? CLPlacemark
                let address = "\(placemark?.thoroughfare ?? ""), \(placemark?.locality ?? ""), \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.country ?? "")"
                self.addressLabel.text = address
            }
        }
    }
}
