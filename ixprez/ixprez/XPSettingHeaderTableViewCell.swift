//
//  XPSettingHeaderTableViewCell.swift
//  ixprez
//
//  Created by Quad on 6/5/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPSettingHeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    
    @IBOutlet weak var lblProfileName: UILabel!
    
    @IBOutlet weak var lblFollowers: UILabel!
    
    @IBOutlet weak var lblFollowing: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
