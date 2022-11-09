//
//  StatusGridViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 11/8/22.
//

import UIKit
import Parse

class StatusGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var statusList = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.layer.masksToBounds = true
        collectionView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        collectionView.layer.borderWidth = 2.0;
        
        cancelBtn.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = cancelBtn.frame.height / 2
        cancelBtn.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        cancelBtn.layer.borderWidth = 2.0;
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 32
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 2
        
        layout.itemSize = CGSize(width: width, height: 48)
        
        loadStatus()
        // Do any additional setup after loading the view.
    }
    
    func loadStatus() {
        let query = PFQuery(className: "Status")
        
        query.findObjectsInBackground() { [self] (status, error) in
            if status != nil {
                self.statusList = status!
                self.collectionView.reloadData()
            } else {
                print("No status")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statusList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatusGridCell", for: indexPath) as! StatusGridCell
        cell.statusLabel.text = statusList[indexPath.item]["statusName"] as? String
        cell.statusLabel.text = "  #" + cell.statusLabel.text! + "  "
        cell.statusLabel.layer.masksToBounds = true
        cell.statusLabel.layer.cornerRadius = 12
        cell.statusLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        cell.statusLabel.layer.borderWidth = 2.0;
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = PFUser.current()!
        user["status"] = statusList[indexPath.item]["statusName"] as! String
        user.saveInBackground()
        let presentedBy = presentingViewController as? ProfileViewController
        presentedBy?.changeStatus()
        self.dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
