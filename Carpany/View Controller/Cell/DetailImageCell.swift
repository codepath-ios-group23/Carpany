//
//  DetailImageCell.swift
//  Carpany
//
//  Created by Richard Zhang on 11/11/22.
//

import UIKit

class DetailImageCell: UITableViewCell {

    @IBOutlet weak var carImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
