//
//  CarTableViewController.swift
//  Carpany
//
//  Created by CYH on 11/6/22.
//


import UIKit

class CarTableViewController: UITableViewController {
    
 
  

    
    let searchController = UISearchController(searchResultsController: nil)
    
    var currentCar: [String] = MockData.displayableCars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentCar.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell") as! CarCell
        cell.carLabel.text = currentCar[indexPath.row]
        
        
    
        
        
        
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(currentCar[indexPath.row])
    }
    
    

    

}

extension CarTableViewController: UISearchResultsUpdating {

    
    func updateSearchResults(for searchController: UISearchController) {
        let searchedText = searchController.searchBar.text ?? ""
        
        
        currentCar = MockData.displayableCars.filter{
            car in car.starts(with: searchedText)
        }
        tableView.reloadData()
    }
}

class CarCell: UITableViewCell{
    @IBOutlet weak var carLabel:UILabel!
   
}


