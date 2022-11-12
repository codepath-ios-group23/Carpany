//
//  EditDescriptionViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 11/10/22.
//

import UIKit
import Parse

class EditDescriptionViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    let user = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionField.becomeFirstResponder()
        descriptionField.delegate = self
        descriptionField.text = user["bio"] as? String
        
        self.textViewDidChange(descriptionField)
        self.hideKeyboardWhenTappedAround()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        if descriptionField.text == nil {
            user["bio"] = ""
        } else {
            user["bio"] = descriptionField.text!
        }
        user.saveInBackground()
        self.dismiss(animated: true)
    }
    
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = String(descriptionField.text.count) + " / 500"
        if descriptionField.text.count > 480 {
            countLabel.textColor = UIColor.red
        } else {
            countLabel.textColor = UIColor.gray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let characterLimit = 500
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        return newText.count <= characterLimit
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
