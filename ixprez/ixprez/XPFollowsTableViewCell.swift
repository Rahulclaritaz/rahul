//
//  XPFollowsTableViewCell.swift
//  ixprez
//
//  Created by Quad on 6/22/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPFollowsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgProfileImage: UIImageView!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var lblReactionCount: UILabel!
    
    
    @IBOutlet weak var lblViewCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
