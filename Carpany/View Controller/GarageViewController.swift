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
    var selectedCar: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onReturn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let user = PFUser.current()!
        let cars = user["cars"] as? Array<String>
        for car in cars ?? [] {
            let query = PFQuery(className: "Car_table")
            query.getObjectInBackground(withId: car) { (carItem, error) in
                if carItem != nil {
                    let maker = carItem!["Maker"] as! String
                    let genmodel = carItem!["Genmodel"] as! String
                    let genmodelId = carItem!["Genmodel_ID"] as! String
                } else {
                    print("Noting found!")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GarageCell") as! GarageCell
        cell.carImage.layer.cornerRadius = cell.carImage.frame.height / 2
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
