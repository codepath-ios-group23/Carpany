//
//  DetailReadingViewController.swift
//  Carpany
//
//  Created by Richard Zhang on 11/11/22.
//

import UIKit
import Parse
import Alamofire

class DetailReadingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var images: UICollectionView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var thumbsUpBtn: UIButton!
    @IBOutlet weak var thumbsDownBtn: UIButton!
    
    var post: PFObject!
    var user: PFUser!
    var isUp = false
    var isDown = false
    
    var imgs: Array<PFFileObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = images.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        images.delegate = self
        images.dataSource = self
        
        imgs = post["images"] as! Array<PFFileObject>
        
        if imgs.count == 1 {
            let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2)
            layout.itemSize = CGSize(width: width, height: width)
        }
        else if imgs.count <= 4 {
            let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 2 - 16
            layout.itemSize = CGSize(width: width, height: width)
        }
        else {
            let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2) / 3 - 16
            layout.itemSize = CGSize(width: width, height: width)
        }
        
        user = post["author"] as! PFUser
        
        let profile = user["profileImage"] as! PFFileObject
        let profileUrlString = profile.url!
        let profileUrl = URL(string: profileUrlString)!
        profileImage.af.setImage(withURL: profileUrl)
        
        nameLabel.text = user["Nickname"] as! String
        
        postText.text = post["caption"] as! String
        profileButton.setTitle("", for: .normal)
        commentButton.setTitle("", for: .normal)
        
        
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 20
        
        let me = PFUser.current()!
        let upBy = post["upBy"] as! Array<String>
        let downBy = post["downBy"] as! Array<String>
        if upBy.contains(me.objectId!) {
            isUp = true
            thumbsUpBtn.setImage(UIImage(named: "thumbs-up-fill"), for: .normal)
        } else {
            isUp = false
            thumbsUpBtn.setImage(UIImage(named: "thumbs-up"), for: .normal)
        }
        if downBy.contains(me.objectId!) {
            isDown = true
            thumbsDownBtn.setImage(UIImage(named: "thumbs-down-fill"), for: .normal)
        } else {
            isDown = false
            thumbsDownBtn.setImage(UIImage(named: "thumbs-down"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        images.reloadData()
    }
    
    @IBAction func onSkimDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "toSkimDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSkimDetail") {
           let secondView = segue.destination as! PostUserDetailViewController
            secondView.user = self.user
        } else if (segue.identifier == "readComment") {
            let secondView = segue.destination as! ReadingCommentsViewController
             secondView.post = self.post
         }
    }
    
    @IBAction func onReturn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onReadComment(_ sender: Any) {
        self.performSegue(withIdentifier: "readComment", sender: self)
    }
    
    @IBAction func up(_ sender: Any) {
        let user = PFUser.current()!
        var upBy = post["upBy"] as! Array<String>
        var downBy = post["downBy"] as! Array<String>
        if isUp == true {
            upBy = upBy.filter(){$0 != user.objectId!}
            thumbsUpBtn.setImage(UIImage(named: "thumbs-up"), for: .normal)
            isUp = false
        } else {
            if isDown == true {
                downBy = downBy.filter(){$0 != user.objectId!}
                thumbsDownBtn.setImage(UIImage(named: "thumbs-down"), for: .normal)
                isDown = false
            }
            upBy.append(user.objectId!)
            thumbsUpBtn.setImage(UIImage(named: "thumbs-up-fill"), for: .normal)
            isUp = true
        }
        print(isUp)
        print(isDown)
        post["upBy"] = upBy
        post["downBy"] = downBy
        post.saveInBackground()
    }
    
    
    @IBAction func down(_ sender: Any) {
        let user = PFUser.current()!
        var upBy = post["upBy"] as! Array<String>
        var downBy = post["downBy"] as! Array<String>
        if isDown == true {
            downBy = downBy.filter(){$0 != user.objectId!}
            thumbsDownBtn.setImage(UIImage(named: "thumbs-down"), for: .normal)
            isDown = false
        } else {
            if isUp == true {
                upBy = upBy.filter(){$0 != user.objectId!}
                thumbsUpBtn.setImage(UIImage(named: "thumbs-up"), for: .normal)
                isUp = false
            }
            downBy.append(user.objectId!)
            thumbsDownBtn.setImage(UIImage(named: "thumbs-down-fill"), for: .normal)
            isDown = true
        }
        print(isUp)
        print(isDown)
        post["upBy"] = upBy
        post["downBy"] = downBy
        post.saveInBackground()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(imgs.count)
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailReadingImageCell", for: indexPath) as! DetailReadingImageCell
        let imgFile = imgs[indexPath.item]
        let urlString = imgFile.url!
        let url = URL(string: urlString)!
        cell.postImage.af.setImage(withURL: url)
        return cell
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
