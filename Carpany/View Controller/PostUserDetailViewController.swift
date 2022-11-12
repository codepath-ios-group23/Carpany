//
//  PostUserDetailViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 11/11/22.
//

import UIKit
import Parse

class PostUserDetailViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var user: PFUser!

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        statusLabel.layer.masksToBounds = true
        descriptionTextView.layer.masksToBounds = true
        statusLabel.layer.cornerRadius = 5
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        descriptionTextView.layer.borderWidth = 2.0;
        profileImage.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        profileImage.layer.borderWidth = 2.0;
        statusLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        statusLabel.layer.borderWidth = 2.0;
        // Do any additional setup after loading the view.
        
        nicknameLabel.text = user["Nickname"] as? String
        descriptionTextView.text = user["bio"] as? String
        statusLabel.text = user["status"] as? String
        statusLabel.text = "  #" + statusLabel.text! + "  "
        
        let imageFile = user["profileImage"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        profileImage.af.setImage(withURL: url)
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
