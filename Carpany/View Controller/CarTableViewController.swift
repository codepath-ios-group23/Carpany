//
//  CarTableViewController.swift
//  Carpany
//
//  Created by CYH on 11/6/22.
//


import UIKit
import Foundation
import Parse

class CarTableViewController: UITableViewController, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    
    var cars = [PFObject]()
    var originalCars = [PFObject]()
    var carNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        getCars()
        
     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCars()
    }
    
    func getCars() {
        let query = PFQuery(className: "Agg_car")
        query.limit = 800
        query.findObjectsInBackground() {(carItems, error) in
            if carItems != nil {
                self.cars = carItems!
                self.cars.sort {
                    let model1 = $0["Genmodel"] as! String
                    let maker1 = $0["Maker"] as! String
                    
                    let model2 = $1["Genmodel"] as! String
                    let maker2 = $1["Maker"] as! String
                    
                    let lname = maker1 + " " + model1
                    let rname = maker2 + " " + model2
                    return lname.lowercased() < rname.lowercased()
                }
                if self.originalCars.count == 0 {
                    self.originalCars = self.cars
                }
                for car in self.cars {
                    let model = car["Genmodel"] as! String
                    let maker = car["Maker"] as! String
                    self.carNames.append(maker + " " + model)
                }
                self.tableView.reloadData()
            } else {
                print("Found no cars!")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell") as! CarTableViewCell
        let car = self.cars[indexPath.row]
        let maker = car["Maker"] as! String
        let genmodel = car["Genmodel"] as! String
        let genmodelId = car["Genmodel_ID"] as! String
        
        let query2 = PFQuery(className: "image")
        query2.whereKey("Genmodel_ID", equalTo:genmodelId)
        query2.whereKey("Genmodel", equalTo:genmodel)
        query2.whereKey("Maker", equalTo:maker)
        query2.getFirstObjectInBackground() {(imageItem, error) in
            if imageItem != nil && error == nil {
                let basicURL = "http://www.zhang-jihao.com/resized_DVM/"
                let maker = imageItem!["Maker"] as! String
                let genmodel = imageItem!["Genmodel"] as! String
                let year = String(imageItem!["Year"] as! Int)
                let color = imageItem!["Color"] as! String
                let imageName = imageItem!["Image_name"] as! String
                
                let raw = basicURL + maker + "/" + genmodel + "/" + year + "/" + color + "/" + imageName
                let link = raw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                
                let url = URL(string: link)
                cell.carImage.af.setImage(withURL: url!)
            } else {
                let url = URL(string: "https://i.imgur.com/ai65MME.png")!
                cell.carImage.af.setImage(withURL: url)
                print("No preview")
            }
            cell.makerLabel.text = maker
            cell.modelLabel.text = genmodel
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchedText = searchController.searchBar.text ?? ""
        
        if searchedText == "" {
            self.cars = self.originalCars
        }
        else {
            self.cars = self.originalCars.filter{(item) -> Bool in
                let model = item["Genmodel"] as! String
                let maker = item["Maker"] as! String
                let name = maker + " " + model
                return name.contains(searchedText)
            }
        }
        
        tableView.reloadData()
    }
}


