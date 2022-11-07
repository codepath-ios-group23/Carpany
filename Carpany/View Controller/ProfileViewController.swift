//
//  ProfileViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 10/28/22.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2 
        statusLabel.layer.masksToBounds = true
        descriptionTextView.layer.masksToBounds = true
        statusLabel.layer.cornerRadius = 5
        descriptionTextView.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        
        let user = PFUser.current()!
        nicknameLabel.text = user.username
        descriptionTextView.text = user["bio"] as? String
        
        let imageFile = user["profileImage"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        profileImage.af.setImage(withURL: url)
    }
    
    @IBAction func onEnterGarage(_ sender: Any) {
        self.performSegue(withIdentifier: "enterGarage", sender: nil)
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
