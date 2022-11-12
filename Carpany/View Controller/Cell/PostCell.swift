//
//  PostCell.swift
//  Carpany
//
//  Created by Dorothy on 2022/11/9.
//

import UIKit
import Parse

class PostCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    
    var isUp : Bool = false
    var isDown : Bool = false
    var post : PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func thumbsUp(_ sender: Any) {
        let user = PFUser.current()!
        var upBy = post["upBy"] as! Array<String>
        var downBy = post["downBy"] as! Array<String>
        if isUp == true {
            upBy = upBy.filter(){$0 != user.objectId!}
            upBtn.setImage(UIImage(named: "thumbs-up"), for: .normal)
            isUp = false
        } else {
            if isDown == true {
                downBy = downBy.filter(){$0 != user.objectId!}
                downBtn.setImage(UIImage(named: "thumbs-down"), for: .normal)
                isDown = false
            }
            upBy.append(user.objectId!)
            upBtn.setImage(UIImage(named: "thumbs-up-fill"), for: .normal)
            isUp = true
        }
        print(isUp)
        print(isDown)
        post["upBy"] = upBy
        post["downBy"] = downBy
        post.saveInBackground()
    }
    
    @IBAction func thumbsDown(_ sender: Any) {
        let user = PFUser.current()!
        var upBy = post["upBy"] as! Array<String>
        var downBy = post["downBy"] as! Array<String>
        if isDown == true {
            downBy = downBy.filter(){$0 != user.objectId!}
            downBtn.setImage(UIImage(named: "thumbs-down"), for: .normal)
            isDown = false
        } else {
            if isUp == true {
                upBy = upBy.filter(){$0 != user.objectId!}
                upBtn.setImage(UIImage(named: "thumbs-up"), for: .normal)
                isUp = false
            }
            downBy.append(user.objectId!)
            downBtn.setImage(UIImage(named: "thumbs-down-fill"), for: .normal)
            isDown = true
        }
        print(isUp)
        print(isDown)
        post["upBy"] = upBy
        post["downBy"] = downBy
        post.saveInBackground()
    }
}
