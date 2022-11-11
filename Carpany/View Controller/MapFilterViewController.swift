//
//  MapFilterViewController.swift
//  Carpany
//
//  Created by Trang Do on 11/10/22.
//

import UIKit
import MapKit

protocol MapFilterViewControllerDelegate: class {
    func applyFilter(controller: MapFilterViewController,results: [MKMapItem])
}

class MapFilterViewController: UIViewController {

    var gasStationFiltered: Bool = false
    var carRentalFiltered: Bool = false
    var parkingFiltered: Bool = false
    var evChargerFiltered: Bool = false
    
    var results: [MKMapItem] = []
    weak var delegate: MapFilterViewControllerDelegate?
    
    @IBOutlet weak var gasStationButton: UIButton!
    @IBOutlet weak var evChargerButton: UIButton!
    @IBOutlet weak var parkingButton: UIButton!
    @IBOutlet weak var carRentalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setGasStation(_ gasStationChosen: Bool) {
        gasStationFiltered = gasStationChosen
        if (gasStationFiltered) {
            gasStationButton.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
        } else {
            gasStationButton.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
        }
    }
    
    func setCarRental(_ carRentalChosen: Bool) {
        carRentalFiltered = carRentalChosen
        if (carRentalFiltered) {
            carRentalButton.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
        } else {
            carRentalButton.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
        }
    }
    
    func setParking(_ parkingChosen: Bool) {
        parkingFiltered = parkingChosen
        if (parkingFiltered) {
            parkingButton.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
        } else {
            parkingButton.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
        }
    }
    
    func setEVCharger(_ evChargerChosen: Bool) {
        evChargerFiltered = evChargerChosen
        if (evChargerFiltered) {
            evChargerButton.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
        } else {
            evChargerButton.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func selectGasStation(_ sender: Any) {
        let toSelectGasStation = !gasStationFiltered
        if (toSelectGasStation) {
            setGasStation(true)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "Gas Station"
            request.resultTypes = .pointOfInterest
            
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let response = response else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    return
                }
                self.results = response.mapItems
                self.performSegue(withIdentifier: "unwindToMap", sender: self)
                self.delegate?.applyFilter(controller: self, results: self.results)
            }
        }
    }
    
    @IBAction func selectCarRental(_ sender: Any) {
        let toSelectCarRental = !carRentalFiltered
        if (toSelectCarRental) {
            setCarRental(true)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "Car Rental"
            request.resultTypes = .pointOfInterest
            
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let response = response else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    return
                }
                self.results = response.mapItems
                self.performSegue(withIdentifier: "unwindToMap", sender: self)
                self.delegate?.applyFilter(controller: self, results: self.results)
            }
        }
    }
    
    @IBAction func selectParking(_ sender: Any) {
        let toSelectParking = !parkingFiltered
        if (toSelectParking) {
            setParking(true)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "Parking"
            request.resultTypes = .pointOfInterest
            
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let response = response else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    return
                }
                self.results = response.mapItems
                self.performSegue(withIdentifier: "unwindToMap", sender: self)
                self.delegate?.applyFilter(controller: self, results: self.results)
            }
        }
    }
    
    @IBAction func selectEVCharger(_ sender: Any) {
        let toSelectEVCharger = !evChargerFiltered
        if (toSelectEVCharger) {
            setEVCharger(true)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "EV Charger"
            request.resultTypes = .pointOfInterest
            
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard let response = response else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    return
                }
                self.results = response.mapItems
                self.performSegue(withIdentifier: "unwindToMap", sender: self)
                self.delegate?.applyFilter(controller: self, results: self.results)
            }
        }
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
