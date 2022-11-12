//
//  EditNameViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 11/10/22.
//

import UIKit
import Parse

class EditNameViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameField: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    let user = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.becomeFirstResponder()
        nameField.delegate = self
        nameField.text = user["Nickname"] as? String
        
        self.textViewDidChange(nameField)
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSubmit(_ sender: Any) {
        if nameField.text != nil && nameField.text.count != 0 {
            user["Nickname"] = nameField.text
            user.saveInBackground()
            self.dismiss(animated: true)
        }
    }
    
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = String(nameField.text.count) + " / 20"
        if nameField.text.count > 15 {
            countLabel.textColor = UIColor.red
        } else {
            countLabel.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let characterLimit = 20
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
