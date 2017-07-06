//
//  XPPublicDataTableViewCell.swift
//  ixprez
//
//  Created by Quad on 5/30/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPPublicDataTableViewCell: UITableViewCell
{

    @IBOutlet weak var btnPlayPublicVideo: UIButton!
    
    @IBOutlet weak var imgAudioVideo: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    @IBOutlet weak var imgFollowIcon: UIImageView!
    
   // @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var lblReactionCount: UILabel!
    
    @IBOutlet weak var lblViewCount: UILabel!
    
    @IBOutlet weak var btnPress: UIButton!
    
    @IBOutlet weak var imgVA: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
