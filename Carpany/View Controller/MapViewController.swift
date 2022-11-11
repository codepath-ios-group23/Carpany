//
//  MapViewController.swift
//  Carpany
//
//  Created by Trang Do on 10/28/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, SearchMapViewControllerDelegate, MapFilterViewControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var selectedPin: MKPlacemark? = nil
    var userAnnotation = MKPointAnnotation()
    var annotations: [MKAnnotation] = []
    
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
            userAnnotation.coordinate = locationCoordinate
            userAnnotation.title = "Current Location"
            
            mapView.addAnnotation(userAnnotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchMap" {
            let SearchMapVC = segue.destination as! SearchMapViewController
            SearchMapVC.delegate = self
        } else if segue.identifier == "toFilterScreen" {
            let MapFilterVC = segue.destination as! MapFilterViewController
            MapFilterVC.delegate = self
        }
    }
    
    
    @IBAction func onFilterButton(_ sender: Any) {
        mapView.removeAnnotations(annotations)
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
    
    func applyFilter(controller: MapFilterViewController,results: [MKMapItem]) {
        for mapItem in results {
            var placemark: [MKPlacemark] = []
            placemark.append(mapItem.placemark)
            
            var annotation = MKPointAnnotation()
            annotation.coordinate = placemark[0].coordinate
            annotation.title = placemark[0].name
            if let city = placemark[0].locality, let state = placemark[0].administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            mapView.addAnnotation(annotation)
            self.annotations.append(annotation)
        }
    }
}

