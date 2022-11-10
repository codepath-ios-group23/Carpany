//
//  ProfileViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 10/28/22.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.width / 2 
        statusLabel.layer.masksToBounds = true
        descriptionTextView.layer.masksToBounds = true
        logoutBtn.layer.masksToBounds = true
        statusLabel.layer.cornerRadius = 5
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        descriptionTextView.layer.borderWidth = 2.0;
        profileImage.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        profileImage.layer.borderWidth = 2.0;
        statusLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        statusLabel.layer.borderWidth = 2.0;
        logoutBtn.layer.cornerRadius = logoutBtn.frame.height / 2
        logoutBtn.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        logoutBtn.layer.borderWidth = 2.0;
        // Do any additional setup after loading the view.
        
        let user = PFUser.current()!
        nicknameLabel.text = user["Nickname"] as? String
        descriptionTextView.text = user["bio"] as? String
        statusLabel.text = user["status"] as? String
        statusLabel.text = "  #" + statusLabel.text! + "  "
        
        let imageFile = user["profileImage"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        profileImage.af.setImage(withURL: url)
    }
    
    @IBAction func onEnterGarage(_ sender: Any) {
        self.performSegue(withIdentifier: "enterGarage", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    @IBAction func onChangeProfileImage(_ sender: UIGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            picker.sourceType = .photoLibrary
        } else {
            picker.sourceType = .camera
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func onChangeDescription(_ sender: Any) {
        self.performSegue(withIdentifier: "changeDescription", sender: nil)
    }
    
    @IBAction func onChangeName(_ sender: Any) {
        self.performSegue(withIdentifier: "changeName", sender: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let user = PFUser.current()!
        let image = info[.editedImage] as! UIImage
        
        let scaledImage = image.af.imageAspectScaled(toFit: profileImage.frame.size)
        
        self.profileImage.image = scaledImage
        
        let imageData = profileImage.image!.pngData()!
        let file = PFFileObject(name: "image.png", data: imageData)
        user["profileImage"] = file
        user.saveInBackground()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else{return}
        delegate.window?.rootViewController = loginViewController
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
