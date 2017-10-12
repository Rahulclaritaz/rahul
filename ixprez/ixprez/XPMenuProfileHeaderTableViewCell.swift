//
//  XPMenuProfileHeaderTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/10/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPMenuProfileHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage = UIImageView ()
    @IBOutlet weak var userName = UILabel ()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage?.layer.cornerRadius = (profileImage?.frame.size.width)!/2
        profileImage?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
