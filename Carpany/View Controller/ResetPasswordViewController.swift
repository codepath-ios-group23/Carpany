//
//  ResetPasswordViewController.swift
//  Carpany
//
//  Created by Trang Do on 11/6/22.
//

import UIKit
import Parse

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let emailPlaceholderText = NSAttributedString(string: "Email",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.hideKeyboardWhenTappedAround()
        emailField.attributedPlaceholder = emailPlaceholderText
        
    }
    
    @IBAction func emailChanged(_ sender: Any) {
        emailField.text = ""
    }
    
    @IBAction func onSendLink(_ sender: Any) {
        if (emailField.text!.isEmpty) {
            displayEmailBlankError()
        } else {
            PFUser.requestPasswordResetForEmail(inBackground: self.emailField.text!) { (success, error) in
                if (error == nil) {
                    self.displaySuccess()
                } else {
                    print("Error: \(String(describing: error?.localizedDescription))")
                    self.displayResetError(error: error!)
                }
            }
        }
    }
    
    func displayEmailBlankError() -> Void {
        let title = "Error"
        let message = "Email field cannot be empty"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        //add the OK Action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    func displaySuccess() -> Void {
        let title = "Email Successfully Sent"
        let message = "If you already have an account registered with this email, you should receive an email to reset your password."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default)
        //add the OK Action to the alert controller
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
    
    func displayResetError(error: Error) -> Void {
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
