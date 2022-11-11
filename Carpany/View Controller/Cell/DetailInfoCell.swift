//
//  DetailInfoCell.swift
//  Carpany
//
//  Created by Richard Zhang on 11/11/22.
//

import UIKit

class DetailInfoCell: UITableViewCell {

    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
