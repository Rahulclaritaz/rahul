//
//  XPFollowHeaderTableViewCell.swift
//  ixprez
//
//  Created by Quad on 6/22/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPFollowHeaderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgProfileIcon: UIButton!

    @IBOutlet weak var lblProfileName: UILabel!
    
    
    @IBOutlet weak var btnFollow: UIButton!
    
    @IBOutlet weak var imgFollow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
