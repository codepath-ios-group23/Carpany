//
//  MapViewController.swift
//  Carpany
//
//  Created by Trang Do on 10/28/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, SearchMapViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var selectedPin: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        //request authorization
        locationManager.requestWhenInUseAuthorization()
        //Check if user always allow for accessing location
        if (locationManager.authorizationStatus.rawValue == 3) {
            locationManager.startUpdatingLocation()
        }
        locationManager.requestAlwaysAuthorization()
        
        //pass the mapView from MapViewController to SearchMapViewController
//        SearchMapViewController.mapView = mapView
//        SearchMapViewController.handleMapSearchDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        // or
        locationManager.requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied: // Setting option: Never
          print("LocationManager didChangeAuthorization denied")
            locationManager.stopUpdatingLocation()
        case .notDetermined: // Setting option: Ask Next Time
          print("LocationManager didChangeAuthorization notDetermined")
        case .authorizedWhenInUse: // Setting option: While Using the App
          print("LocationManager didChangeAuthorization authorizedWhenInUse")
          locationManager.startUpdatingLocation()
        case .authorizedAlways: // Setting option: Always
          print("LocationManager didChangeAuthorization authorizedAlways")
          locationManager.startUpdatingLocation()
        case .restricted: // Restricted by parental control
          print("LocationManager didChangeAuthorization restricted")
        default:
          print("LocationManager didChangeAuthorization")
        }
      }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let mUserLocation = locations.last {
            let userLatitude = mUserLocation.coordinate.latitude
            let userLongitude = mUserLocation.coordinate.longitude
            
            let locationCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees.init(userLatitude),CLLocationDegrees.init(userLongitude))
            let mRegion = MKCoordinateRegion(center: locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            
            mapView.setRegion(mRegion, animated: true)
        
            mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: [.carRental, .evCharger, .gasStation, .parking])
            
            //Get user's current location and drop a pin
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            annotation.title = "Current Location"
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchMap" {
            let SearchMapVC = segue.destination as! SearchMapViewController
            SearchMapVC.delegate = self
        }
    }
    
    func dropPinZoomIn(controller: SearchMapViewController, placemark: MKPlacemark) {
        selectedPin = placemark
        //clear existing pins
//        mapView.removeAnnotation(annotation)
        let searchAnnotation = MKPointAnnotation()
        searchAnnotation.coordinate = placemark.coordinate
        searchAnnotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            searchAnnotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(searchAnnotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func unwindToMapView(sender: UIStoryboardSegue) {
        
    }
}

