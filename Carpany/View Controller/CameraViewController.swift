//
//  CameraViewController.swift
//  Carpany
//
//  Created by Dorothy on 2022/11/8.
//

import UIKit
import AlamofireImage
import Foundation
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var commentField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        commentField.delegate = self
        commentField.layer.masksToBounds = true
        commentField.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text!
        post["author"] =  PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground{(success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            }else{
                print("error!")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
    
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            picker.sourceType = .camera
            picker.sourceType = .photoLibrary // I have some issue on my iphone simulator which will trigger the camera but black
        }else{
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaleimage = image.af_imageScaled(to: size)
        
        imageView.image = scaleimage
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = String(commentField.text.count) + " / 2000"
        if commentField.text.count > 1950 {
            countLabel.textColor = UIColor.red
        } else {
            countLabel.textColor = UIColor.gray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let characterLimit = 2000
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        return newText.count <= characterLimit
    }
    
    @IBAction func onCancel(_ sender: Any) {
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

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
