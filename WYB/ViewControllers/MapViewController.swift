//
//  MapViewController.swift
//  WYB
//
//  Created by Priscilla Okawa on 10/9/18.
//  Copyright © 2018 Priscilla Okawa. All rights reserved.
//

import UIKit
import MapKit // import the MapKit framework

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishWalkBtn: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var walkerLocation: UIButton!
    
    //create a Location Manager to be able to get the current location of the user, and set the Delegate on the class to be able to control this.
    var locationManager: CLLocationManager?
    
    //create a current location globally to be able to access is at any time
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //instantiate locationManager:
        locationManager = CLLocationManager()
        //and set the Delegate to self so we can manage it
        locationManager?.delegate = self
        //update the user's location:
        enableLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func walkerLocation(_ : Any) {
        //with the user's current location, we can get the center of the Map View
        let center = currentLocation?.coordinate
        //and we can set the region:
        let region = MKCoordinateRegion(center: center!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //set the last view to this region using the built-in set region function:
        self.mapView.setRegion(region, animated: true)
        
        //add an annotation with NK point built-in to se where exactly is the user at:
        let annotation = MKPointAnnotation()
        //set the annotation coordinate to the walker's coordinate
        annotation.coordinate = (currentLocation?.coordinate)!
        //set the title to Walker Location
        annotation.title = "Walker's location"
        //add this annotation to the MapView
        self.mapView.addAnnotation(annotation)
        
        //update the walker's address using geo coder
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation!) { (placemarks, error) in
            if (error) == nil {
                let placemark = placemarks![0] as? CLPlacemark
                let address = "\(placemark?.thoroughfare ?? ""), \(placemark?.locality ?? ""), \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.country ?? "")"
                print("\(address)")
                
                self.addressLabel.text = address
            }
        }
        
    }

    // ask permission to "walker" to get the location:
    func enableLocation() {
        locationManager?.requestWhenInUseAuthorization()

        // check if permission as given, using a built-in function:
        if(CLLocationManager.locationServicesEnabled()) {
            //start updating the location:
            locationManager?.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
        }
    }

}
