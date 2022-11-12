//
//  LoginViewController.swift
//  Carpany
//
//  Created by Trang Do on 10/17/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPlaceHolder()
        initializeHideKeyboard()
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupPlaceHolder() {
        usernameField.autocorrectionType = .no
        passwordField.autocorrectionType = .no
        let usernamePlaceholderText = NSAttributedString(string: "Username",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        usernameField.attributedPlaceholder = usernamePlaceholderText
        
        let passwordPlaceholderText = NSAttributedString(string: "Password",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordField.attributedPlaceholder = passwordPlaceholderText
        passwordField.isSecureTextEntry = true
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

    @IBAction func onSignIn(_ sender: Any) {
        if usernameAndPasswordNotEmpty() {
            let username = usernameField.text!
            let password = passwordField.text!
            
            PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                if user != nil {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    self.displayLoginError(error: error!)
                }
            }
        }
    }
    
    func usernameAndPasswordNotEmpty() -> Bool {
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty {
            displayError()
            return false
        } else {
            return true
        }
    }
    
    func displayError() -> Void {
        let title = "Error"
        let message = "Username and password field cannot be empty"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        //add the OK Action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    func displayLoginError(error: Error) -> Void {
        let title = "Login Error"
        let message = "Oops! Something went wrong while logging in: \(error.localizedDescription)"
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
