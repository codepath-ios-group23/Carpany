//
//  MainViewController.swift
//  Carpany
//
//  Created by Dorothy on 2022/11/5.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var addPostBtn: UIButton!
    
    let commentBar = MessageInputBar()
    let myRefreshControl = UIRefreshControl()
    var showsCommentBar = false
    var posts = [PFObject]()
    var selectedPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        myRefreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        
        tableView.refreshControl = myRefreshControl
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        
        logoutBtn.layer.masksToBounds = true
        logoutBtn.layer.cornerRadius = logoutBtn.frame.height / 2
        
        addPostBtn.layer.masksToBounds = true
        addPostBtn.layer.cornerRadius = 20
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHiidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil )
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillBeHiidden(note:Notification){
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    @objc func loadPosts() {
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "comments","comments.author"])
        query.addDescendingOrder("createdAt")
        query.limit = 50
        
        query.findObjectsInBackground{(posts,error) in
            if posts != nil{
                self.posts = posts!
                self.tableView.reloadData()
                self.myRefreshControl.endRefreshing()
            }
        }
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadPosts()
    }
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] =  text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!
        
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground{(success,error) in
        if success {
                        print("Comment saved")
                    } else {
                        print("Error saving comment")
                    }
                }
        
        tableView.reloadData()
        //clear and dismiss
        commentBar.inputTextView.text = nil
        
        
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        

        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            let user = post["author"] as! PFUser
            cell.post = post
            let me = PFUser.current()!
            let upBy = post["upBy"] as! Array<String>
            let downBy = post["downBy"] as! Array<String>
            if upBy.contains(me.objectId!) {
                cell.isUp = true
                cell.upBtn.setImage(UIImage(named: "thumbs-up-fill"), for: .normal)
            }
            if downBy.contains(me.objectId!) {
                cell.isDown = true
                cell.downBtn.setImage(UIImage(named: "thumbs-down-fill"), for: .normal)
            }
            
            let profile = user["profileImage"] as! PFFileObject
            let profileUrlString = profile.url!
            let profileUrl = URL(string: profileUrlString)!
            cell.profileImage.af.setImage(withURL: profileUrl)
            
            cell.usernameLabel.text = user["Nickname"] as! String
            
            cell.captionLabel.text = post["caption"] as! String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af.setImage(withURL: url)
            
            cell.photoView.layer.masksToBounds = true
            cell.photoView.layer.cornerRadius = 5
            
            cell.profileImage.layer.masksToBounds = true
            cell.profileImage.layer.cornerRadius = 20
            
            return cell
        } else if indexPath.row <= comments.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user["Nickname"] as! String
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        
        let comments = (post["comments"] as? [PFObject]) ?? []
        selectedPost = post
        
        if indexPath.row == comments.count+1{
            showsCommentBar = true
            becomeFirstResponder()
            
            commentBar.inputTextView.becomeFirstResponder()
            
        } else if indexPath.row == 0 {
            self.performSegue(withIdentifier: "toPostDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toPostDetail") {
           let secondView = segue.destination as! DetailReadingViewController
            secondView.post = self.selectedPost
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else{return}
        delegate.window?.rootViewController = loginViewController
    }
    
}
