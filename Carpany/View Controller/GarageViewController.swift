//
//  GarageViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 11/4/22.
//

import UIKit
import Parse
import AlamofireImage

class GarageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cars = [PFObject]()
    var images = [PFObject?]()
    var selectedCar: PFObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCars()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onReturn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.loadCars()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadCars()
        self.tableView.reloadData()
    }
    
    @objc func loadCars() {
        let user = PFUser.current()!
        let cars = user["cars"] as? Array<String>
        for car in cars ?? [] {
            let query = PFQuery(className: "Car_table")
            query.getObjectInBackground(withId: car) { (carItem, error) in
                if carItem != nil {
                    let maker = carItem!["Maker"] as! String
                    let genmodel = carItem!["Genmodel"] as! String
                    let genmodelId = carItem!["Genmodel_ID"] as! String
                    let color = carItem!["Color"] as! String
                    print(maker)
                    print(genmodel)
                    print(genmodelId)
                    print(color)
                    
                    let query2 = PFQuery(className: "image")
                    query2.whereKey("Genmodel_ID", equalTo:genmodelId)
                    query2.whereKey("Genmodel", equalTo:genmodel)
                    query2.whereKey("Maker", equalTo:maker)
                    query2.whereKey("Color", equalTo:color)
                    
                    query2.getFirstObjectInBackground() { (imageItem, error) in
                        if imageItem != nil {
                            self.cars.append(carItem!)
                            self.images.append(imageItem)
                            let imageName = imageItem!["Image_name"] as! String
                            print(imageName)
                        } else {
                            self.images.append(nil)
                            print("No preview")
                        }
                    }
                } else {
                    print("No cars found!")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GarageCell") as! GarageCell
        let imagess = self.images
        cell.carImage.layer.cornerRadius = cell.carImage.frame.height / 2
        if self.images[indexPath.row] != nil {
            let basicURL = "http://www.zhang-jihao.com/resized_DVM/"
            
            let maker = self.images[indexPath.row]!["Maker"] as! String
            let genmodel = self.images[indexPath.row]!["Genmodel"] as! String
            let year = String(self.images[indexPath.row]!["Year"] as! Int)
            let color = self.images[indexPath.row]!["Color"] as! String
            let imageName = self.images[indexPath.row]!["Image_name"] as! String
            
            let url = URL(string: basicURL + maker + "/" + genmodel + "/" + year + "/" + color + "/" + imageName)!
            print(url)
            
            cell.carImage.af.setImage(withURL: url)
        }
        return cell
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
