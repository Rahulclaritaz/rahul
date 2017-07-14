//
//  XPFollowHeaderTableViewCell.swift
//  ixprez
//
//  Created by Quad on 6/22/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPFollowHeaderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var followerProfileButton: UIButton!
    @IBOutlet weak var followerProfileImage: UIImageView!
    @IBOutlet weak var followerProfileBGImage: UIImageView!

    @IBOutlet weak var lblProfileName: UILabel!
    
    
    @IBOutlet weak var btnFollow: UIButton!
    
    @IBOutlet weak var imgFollow: UIImageView!
    @IBOutlet weak var imgFollowBG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
