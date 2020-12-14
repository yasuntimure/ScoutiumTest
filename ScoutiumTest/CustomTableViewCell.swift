//
//  CustomTableViewCell.swift
//  ScoutiumTest
//
//  Created by Eyüp YASUNTİMUR on 13.12.2020.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
