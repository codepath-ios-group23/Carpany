//
//  DetailReadingViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 11/11/22.
//

import UIKit
import Parse
import Alamofire

class DetailReadingViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    
    var post: PFObject!
    var user: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = post["author"] as! PFUser
        
        let profile = user["profileImage"] as! PFFileObject
        let profileUrlString = profile.url!
        let profileUrl = URL(string: profileUrlString)!
        profileImage.af.setImage(withURL: profileUrl)
        
        nameLabel.text = user["Nickname"] as! String
        
        postText.text = post["caption"] as! String
        profileButton.setTitle("", for: .normal)
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        postImage.af.setImage(withURL: url)
        
        postImage.layer.masksToBounds = true
        postImage.layer.cornerRadius = 5
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSkimDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "toSkimDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSkimDetail") {
           let secondView = segue.destination as! PostUserDetailViewController
            secondView.user = self.user
        }
    }
    
    @IBAction func onReturn(_ sender: Any) {
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

}
