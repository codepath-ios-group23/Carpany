//
//  CarDetailViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 11/11/22.
//

import UIKit
import Parse

class CarDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageTableView: UITableView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    
    var car : PFObject!
    var infoList =  [Int: [String]]()
    var images = [PFObject?]()
    var usercars: Array<String> = []
    var inGarage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageTableView.delegate = self
        imageTableView.dataSource = self
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
        initialize()
        saveInfo()
        let maker = car["Maker"] as! String
        let model = car["Genmodel"] as! String
        nameLabel.text = maker + " " + model
        
        switchBtn.addTarget(self, action: #selector(switchClick(swi:)), for:UIControl.Event.valueChanged )
        // Do any additional setup after loading the view.
    }
    
    func saveInfo() {
        self.infoList = [
                        0: ["Maker", car["Maker"] as! String],
                        1: ["Genmodel", car["Genmodel"] as! String],
                        2: ["Genmodel_ID", car["Genmodel_ID"] as! String],
                        3: ["Color", car["Color"] as! String],
                        4: ["Reg_year", String(describing: car["Reg_year"]!)],
                        5: ["Bodytype", car["Bodytype"] as! String],
                        6: ["Engin_size", car["Engin_size"] as! String],
                        7: ["Gearbox", car["Gearbox"] as! String],
                        8: ["Fuel_type", car["Fuel_type"] as! String],
                        9: ["Price", "\(String(describing: car["Price"]!))"],
                        10: ["Engine_power", "\(String(describing: car["Engine_power"]!))"],
                        11: ["Wheelbase", "\(String(describing: car["Wheelbase"]!))" ],
                        12: ["Height", "\(String(describing: car["Height"]!))" ],
                        13: ["Width", "\(String(describing: car["Width"]!))" ],
                        14: ["Length","\(String(describing: car["Length"]!))" ],
                        15: ["Average_mpg", car["Average_mpg"] as! String],
                        16: ["Top_speed", car["Top_speed"] as! String],
                        17: ["Seat_num", "\(String(describing: car["Seat_num"]!))" ],
                        18: ["Door_num", "\(String(describing: car["Door_num"]!))" ]
                    ]
        self.infoTableView.reloadData()
        
        let query = PFQuery(className: "image")
        query.whereKey("Maker", equalTo: car["Maker"]!)
        query.whereKey("Genmodel", equalTo: car["Genmodel"]!)
        query.whereKey("Genmodel_ID", equalTo: car["Genmodel_ID"]!)
        query.findObjectsInBackground(){(imageItems, error) in
            if imageItems != nil && imageItems?.count != 0 {
                self.images = imageItems!
                let imageName = imageItems![0]["Image_name"] as! String
                print(imageName)
                
            } else {
                self.images.append(nil)
                print("No preview")
            }
            self.imageTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case infoTableView:
            return infoList.count
        case imageTableView:
            return self.images.count
        default:
            return 1
        }
    }
    
    @objc func switchClick(swi:UISwitch){
        let user = PFUser.current()!
        if swi.isOn{
            self.usercars.append(self.car.objectId!)
        }else{
            self.usercars = self.usercars.filter(){$0 != self.car.objectId!}
        }
        user["cars"] = self.usercars
        user.saveInBackground()
    }
    
    func initialize(){
        let user = PFUser.current()!
        self.usercars = (user["cars"] as? Array<String>)!
        if (self.usercars.contains(self.car.objectId!)){
            switchBtn.setOn(true, animated: true)
        } else {
            switchBtn.setOn(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case infoTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailInfoCell", for: indexPath) as! DetailInfoCell
            cell.propertyLabel.text = infoList[indexPath.row]![0]
            cell.infoLabel.text = infoList[indexPath.row]![1]
            return cell

        case imageTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailImageCell", for: indexPath) as! DetailImageCell
            cell.carImage.layer.cornerRadius = 30
     

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
                    cell.carImage.af.setImage(withURL: url!)
                } else {
                    let url = URL(string: "https://i.imgur.com/ai65MME.png")!
                    cell.carImage.af.setImage(withURL: url)
                }
                
            }
            return cell
        default:
            print("Some things Wrong!!")
            return UITableViewCell()
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
