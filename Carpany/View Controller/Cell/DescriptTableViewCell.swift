//
//  DescriptTableViewCell.swift
//  Carpany
//
//  Created by CYH on 11/10/22.
//

import UIKit

class DescriptTableViewCell: UITableViewCell {

    @IBOutlet weak var Dparameter: UILabel!
    @IBOutlet weak var Dvalue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
