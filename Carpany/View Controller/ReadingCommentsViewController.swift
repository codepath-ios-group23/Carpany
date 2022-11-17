//
//  ReadingCommentsViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 11/16/22.
//

import UIKit
import Parse
import Alamofire
import MessageInputBar

class ReadingCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addCommentBtn: UIButton!
    
    var post: PFObject!
    var comments = [PFObject]()
    var showsCommentBar = false
    let commentBar = MessageInputBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        table.rowHeight = UITableView.automaticDimension
        
        addCommentBtn.layer.masksToBounds = true
        addCommentBtn.layer.cornerRadius = addCommentBtn.frame.height / 2
        addCommentBtn.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        addCommentBtn.layer.borderWidth = 2.0;
        
        comments = (post["comments"] as? [PFObject]) ?? []
        
        table.keyboardDismissMode = .interactive
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        commentBar.inputTextView.becomeFirstResponder()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHiidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil )
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoad()
    }
    
    @objc func keyboardWillBeHiidden(note:Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentBar
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] =  text
        comment["post"] = post
        comment["author"] = PFUser.current()!
        
        post.add(comment, forKey: "comments")
        
        post.saveInBackground{(success,error) in
        if success {
                        print("Comment saved")
                    } else {
                        print("Error saving comment")
                    }
                }
        //clear and dismiss
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
        comments = (post["comments"] as? [PFObject]) ?? []
        table.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCommentCell") as! DetailCommentCell
        let comment = comments[indexPath.row]
        cell.commentLabel.text = comment["text"] as? String
        let user = comment["author"] as! PFUser
        cell.nameLabel.text = user["Nickname"] as! String
        let profile = user["profileImage"] as! PFFileObject
        let profileUrlString = profile.url!
        let profileUrl = URL(string: profileUrlString)!
        cell.profileImage.af.setImage(withURL: profileUrl)
        cell.profileImage.layer.masksToBounds = true
        cell.profileImage.layer.cornerRadius = 20
        let time = comment.createdAt
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        cell.timeLabel.text = df.string(from: time ?? Date())
        return cell
    }
    
    
    @IBAction func onAddPost(_ sender: Any) {
        showsCommentBar = true
        becomeFirstResponder()
        commentBar.inputTextView.becomeFirstResponder()
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
