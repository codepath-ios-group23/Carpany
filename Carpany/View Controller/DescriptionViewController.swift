//
//  DescriptionViewController.swift
//  Carpany
//
//  Created by CYH on 11/8/22.
//

import UIKit

import Parse

class DescriptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    
    @IBOutlet weak var sCar: UILabel!
    @IBOutlet weak var descriptionTableView: UITableView!
    
    @IBOutlet weak var DescriptionItems: UITableView!
    
    @IBOutlet weak var DescriptionImage: UITableView!
    


    
    var images = [PFObject?]()
    var label: String = ""
    var carList =  [Int: [String]]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        
        DescriptionItems.delegate = self
        DescriptionItems.dataSource = self
        
        DescriptionImage.delegate = self
        DescriptionImage.dataSource = self
        
        pass()
        
//        let components = label.split(separator: " ")
//        let maker = components[0]
//        let genmodelId = components[components.endIndex-1]
//        var genmodel: String = ""
//        if components.count > 3{
//            for index in components.startIndex + 1 ..< components.endIndex-1{
//                genmodel += components[index]
//                if index < components.endIndex-2{
//                    genmodel += " "
//
//                } }}
//        else {
//            genmodel = String(components[1])
//            }
       
      //  print(carItems)

        
        sCar.text = label
        
  
        
       
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func pass() {
        let query = PFQuery(className: "Agg_car")
        query.whereKey("Full_name", equalTo: label)
        
        
        
                query.limit = 20
        query.getFirstObjectInBackground(){ (carIts, error) in
                    if carIts != nil {
                        self.carList = [
                            0: ["Maker", carIts!["Maker"] as! String],
                            1: ["Genmodel", carIts!["Genmodel"] as! String],
                            2: ["Genmodel_ID", carIts!["Genmodel_ID"] as! String],
                            3: ["Color", carIts!["Color"] as! String],
                            4: ["Reg_year", String(describing: carIts!["Reg_year"]!)],
                            5: ["Bodytype", carIts!["Bodytype"] as! String],
                            6: ["Engin_size", carIts!["Engin_size"] as! String],
                            7: ["Gearbox", carIts!["Gearbox"] as! String],
                            8: ["Fuel_type", carIts!["Fuel_type"] as! String],
                            9: ["Price", "\(String(describing: carIts!["Price"]!))"],
                            10: ["Engine_power", "\(String(describing: carIts!["Engine_power"]!))"],
                            11: ["Wheelbase", "\(String(describing: carIts!["Wheelbase"]!))" ],
                            12: ["Height", "\(String(describing: carIts!["Height"]!))" ],
                            13: ["Width", "\(String(describing: carIts!["Width"]!))" ],
                            14: ["Length","\(String(describing: carIts!["Length"]!))" ],
                            15: ["Average_mpg", carIts!["Average_mpg"] as! String],
                            16: ["Top_speed", carIts!["Top_speed"] as! String],
                            17: ["Seat_num", "\(String(describing: carIts!["Seat_num"]!))" ],
                            18: ["Door_num", "\(String(describing: carIts!["Door_num"]!))" ]
                        
                        ]
                        
                        let query = PFQuery(className: "image")
                        query.whereKey("Maker", equalTo: self.carList[0]?[1])
                        query.whereKey("Genmodel", equalTo: self.carList[1]?[1] )
                        query.whereKey("Genmodel_ID", equalTo:self.carList[2]?[1])
                        query.findObjectsInBackground(){(imageItems, error) in
                            if imageItems != nil {
                                self.images = imageItems!
                                let imageName = imageItems![0]["Image_name"] as! String
                                print(imageName)
                                
                            } else {
                                print("No preview")
                            }
                            self.DescriptionImage.reloadData()
                        }
                        
                        self.descriptionTableView.reloadData()
                        
                        
                        
                        
                    } else {
                        print("Not found a car!")
                    }
                }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch tableView {
            case DescriptionItems:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptTableViewCell", for: indexPath) as! DescriptTableViewCell
                cell.Dparameter?.text = carList[indexPath.row]?[0]
                cell.Dvalue?.text = carList[indexPath.row]?[1]
                return cell
    
            case DescriptionImage:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionImageTableViewCell", for: indexPath) as! DescriptionImageTableViewCell
                cell.DescriptImage.layer.cornerRadius = 30
         

                if self.images.count != 0 {
                    if self.images[indexPath.row] != nil {
                        let basicURL = "http://www.zhang-jihao.com/resized_DVM/"
                        let maker = self.images[indexPath.row]!["Maker"] as! String
                        let genmodel = self.images[indexPath.row]!["Genmodel"] as! String
                        let year = String(self.images[indexPath.row]!["Year"] as! Int)
                        let color = self.images[indexPath.row]!["Color"] as! String
                        let imageName = self.images[indexPath.row]!["Image_name"] as! String
                        
                        let raw = basicURL + maker + "/" + genmodel + "/" + year + "/" + color + "/" + imageName
                        let link = raw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        
                        let url = URL(string: link)
                        cell.DescriptImage.af.setImage(withURL: url!)
                        print(url)
                    } else {
                        let url = URL(string: "https://i.imgur.com/ai65MME.png")!
                        cell.DescriptImage.af.setImage(withURL: url)
                    }
                    
                }
                return cell
            default:
                print("Some things Wrong!!")
                return UITableViewCell()
            }
       }
    
    
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 0
        switch tableView {
        case DescriptionItems:
            numberOfRow = self.carList.count
            
        case DescriptionImage:
            numberOfRow = self.images.count
        default:
            print("Some things Wrong!!")
        }
        return numberOfRow
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


