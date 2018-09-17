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
    @IBOutlet weak var timerLabel: UILabel!
    
    let networkClient = NetworkClient()
    
    var request: WalkRequest?
    
    //create a Location Manager to be able to get the current location of the user, and set the Delegate on the class to be able to control this.
    var locationManager: CLLocationManager?
    
    //create a current location globally to be able to access is at any time
    var currentLocation: CLLocation?
    
    //boolean flag to call walkerLocation func 1x
    var walkerLocationLoaded = false
    
    // variable to keep track on the timer:
    var time = 0
    //set timer:
    var myTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //instantiate locationManager:
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        //and set the Delegate to self so we can manage it
        locationManager?.delegate = self
        
        //update the user's location:
        enableLocation()
        
        //mapview setup to show user location
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = .follow
        
        // start the timer
        startTimer()
        timerLabel.layer.cornerRadius = 10
        timerLabel.layer.masksToBounds = true
    }

    func startTimer() {
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        time += 1
        timerLabel.text = "\(timeFormatted(time))"
    }
    
    func endTimer() {
        myTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //ask permission to "walker" to get the location:
    func enableLocation() {
        // user activated automatic authorization info mode
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            locationManager?.requestAlwaysAuthorization()
            locationManager?.requestWhenInUseAuthorization()
        } else {
            //start updating the location:
            locationManager?.startUpdatingLocation()
            locationManager?.startUpdatingHeading()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (CLLocationManager.locationServicesEnabled()) {
            //start updating the location:
            locationManager?.startUpdatingLocation()
            locationManager?.startUpdatingHeading()
        }
    }
    
    //setting up where to get the location from:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let oldLocation = currentLocation
        
        if let location = locations.first {
            currentLocation = location
//            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
            
            if !walkerLocationLoaded {
                walkerLocationLoaded = true
                walkerLocation()
            }
        }
        
        //drawing path or route covered
        if let newLocation = locations.first,
            let oldLocation = oldLocation {
            let oldCoordinates = oldLocation.coordinate
            let newCoordinates = newLocation.coordinate
            var area = [oldCoordinates, newCoordinates]
            let polyline = MKPolyline(coordinates: &area, count: area.count)
            mapView.add(polyline)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.red
            pr.lineWidth = 5
            return pr
        }
        return MKOverlayRenderer()
    }
    
    func walkerLocation() {
        //with the user's current location, we can get the center of the Map View
        if let location = currentLocation {
            let center = location.coordinate
            
            //and we can set the region:
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            // the last view to this region using the built-in set region function:
            self.mapView.setRegion(region, animated: true)
            
            //update the walker's address using geo coder
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                if let placemarks = placemarks,
                    (error) == nil {
                    let placemark = placemarks[0]
                    let address = "\(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
                    print(address)
                    self.addressLabel.text = address
                }
            }
        }
    }
    
    func updateRequest() {
        if var request = request {
            request.finishWalkDate = Date()
            networkClient.updateOneRequest(request: request, completionBlock: {_,_ in
                self.performSegue(withIdentifier: "UnwindFromMapVC", sender: nil)
            })
        }
    }
    
    @IBAction func finishWalkBtnTapped(_ sender: Any) {
        endTimer()
        mapView.showsUserLocation = false
        locationManager?.stopUpdatingLocation()
        updateRequest()
    }
    
}
