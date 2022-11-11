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
    
    var carsList = [PFObject]()
    var images = [PFObject?]()
    var selectedCar : PFObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onReturn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.images.removeAll()
        self.carsList.removeAll()
        let user = PFUser.current()!
        let cars = user["cars"] as? Array<String>
        if cars != nil && cars?.count != 0 {
            self.getCarItem(i: 0, cars: cars!)
        }
        
    }
    
    func getCarItem(i : Int, cars : Array<String>) {
        if cars.count != 0 {
            let query = PFQuery(className: "Agg_car")
            let car = cars[i] as String
            query.getObjectInBackground(withId: car) { (carItem, error) in
                if carItem != nil {
                    let maker = carItem!["Maker"] as! String
                    let genmodel = carItem!["Genmodel"] as! String
                    let genmodelId = carItem!["Genmodel_ID"] as! String
                    
                    let query2 = PFQuery(className: "image")
                    query2.whereKey("Genmodel_ID", equalTo:genmodelId)
                    query2.whereKey("Genmodel", equalTo:genmodel)
                    query2.whereKey("Maker", equalTo:maker)
                    query2.getFirstObjectInBackground() {(imageItem, error) in
                        if imageItem != nil && error == nil {
                            self.carsList.append(carItem!)
                            self.images.append(imageItem)
                            print(i)
                            print("Number of image: \(self.images.count)")
                            let imageName = imageItem!["Image_name"] as! String
                            print(imageName)
                            
                        } else {
                            self.carsList.append(carItem!)
                            print(i)
                            self.images.append(nil)
                            print("No preview")
                        }
                        self.tableView.reloadData()
                        if i < cars.count - 1 {
                            self.getCarItem(i: i + 1, cars: cars)
                        }
                    }
                } else {
                    print("No cars found!")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCar = carsList[indexPath.row]
        self.performSegue(withIdentifier: "toCarDetail", sender: nil)
    }
      
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "toCarDetail") {
          let secondView = segue.destination as! CarDetailViewController
           secondView.car = self.selectedCar!
       }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GarageCell") as! GarageCell
        cell.carImage.layer.cornerRadius = 30
 

        if images.count != 0 {
            if images[indexPath.row] != nil {
                let basicURL = "http://www.zhang-jihao.com/resized_DVM/"
                let maker = self.images[indexPath.row]!["Maker"] as! String
                let genmodel = self.images[indexPath.row]!["Genmodel"] as! String
                let year = String(self.images[indexPath.row]!["Year"] as! Int)
                let color = self.images[indexPath.row]!["Color"] as! String
                let imageName = self.images[indexPath.row]!["Image_name"] as! String
                
                let raw = basicURL + maker + "/" + genmodel + "/" + year + "/" + color + "/" + imageName
                let link = raw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                
                let url = URL(string: link)
                cell.carImage.af.setImage(withURL: url!)
            } else {
                let url = URL(string: "https://i.imgur.com/ai65MME.png")!
                cell.carImage.af.setImage(withURL: url)
            }
            
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
