//
//  SignUpViewController.swift
//  Carpany
//
//  Created by Trang Do on 10/17/22.
//

import UIKit
import Parse
import AlamofireImage


class SignUpViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nicknameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioTextView.delegate = self
        // Do any additional setup after loading the view.
        setupOutlets()
        initializeHideKeyboard()
        
    }
    
    func setupOutlets() {
        let usernamePlaceholderText = NSAttributedString(string: "Username",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        usernameField.attributedPlaceholder = usernamePlaceholderText
        
        let passwordPlaceholderText = NSAttributedString(string: "Password",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordField.attributedPlaceholder = passwordPlaceholderText
        passwordField.isSecureTextEntry = true
        
        bioTextView.text = "Self-description"
        
        let nicknamePlaceholderText = NSAttributedString(string: "Nickname",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        nicknameField.attributedPlaceholder = nicknamePlaceholderText
        
        let emailPlaceholderText = NSAttributedString(string: "Email",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailField.attributedPlaceholder = emailPlaceholderText
        
        let phoneNumberPlaceholderText = NSAttributedString(string: "Phone Number (Optional)",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        phoneNumberField.attributedPlaceholder = phoneNumberPlaceholderText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func usernameChanged(_ sender: Any) {
        usernameField.text = ""
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        passwordField.text = ""
        passwordField.isSecureTextEntry = true
    }
    
    @IBAction func emailChanged(_ sender: Any) {
        emailField.text = ""
    }
    
    
    @IBAction func phoneNumberChanged(_ sender: Any) {
        phoneNumberField.text = ""
    }
    
    @IBAction func nicknameChanged(_ sender: Any) {
        nicknameField.text = ""
    }
    //    func textViewDidBeginEditing(_ textView: UITextView) {
//        bioTextView.text = ""
//    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        bioTextView.text = ""
        return true
    }
    
    func initializeHideKeyboard(){
            //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(dismissMyKeyboard))
            
            //Add this tap gesture recognizer to the parent view
            view.addGestureRecognizer(tap)
        }
    
    @objc func dismissMyKeyboard(){
            //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
            //In short- Dismiss the active keyboard.
            view.endEditing(true)
        }
    
    @IBAction func onCameraButton(_ sender: Any) {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 100, height: 100)
        let scaledImage = image.af.imageAspectScaled(toFit: size)
        
        profileImage.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreate(_ sender: Any) {
        if usernameAndPasswordNotEmpty() {
            let user = PFUser()
            user.username = self.usernameField.text
            user.password = self.passwordField.text
            user.email = self.emailField.text
            
            user["bio"] = self.bioTextView.text
            user["phone"] = self.phoneNumberField.text
            user["Nickname"] = self.nicknameField.text
            
            let imageData = profileImage.image!.pngData()!
            print(imageData)
            let file = PFFileObject(name: "image.png", data: imageData)
            
            user["profileImage"] = file
            
            user.signUpInBackground { (success, error) in
                if success {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    self.displaySignupError(error: error!)
                }
            }
        }
    }
    
    func usernameAndPasswordNotEmpty() -> Bool {
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty || emailField.text!.isEmpty{
            displayError()
            return false
        } else {
            return true
        }
    }
    
    func displayError() -> Void {
        let title = "Error"
        let message = "Username, password, and email field cannot be empty"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        //add the OK Action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    func displaySignupError(error: Error) -> Void {
        let title = "Login Error"
        let message = "Oops! Something went wrong while signing up: \(error.localizedDescription)"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        //add the OK Action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
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
