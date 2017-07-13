//
//  XPDashboardTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 06/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPDashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbNailImage = UIImageView ()
    @IBOutlet weak var likeCountLabel = UILabel ()
    @IBOutlet weak var emotionCountLabel = UILabel ()
    @IBOutlet weak var ViewCountLabel = UILabel ()
    @IBOutlet weak var titleLabel = UILabel ()
    @IBOutlet weak var playButton = UIButton ()
    @IBOutlet weak var imgVA: UIImageView!
    @IBOutlet weak var followUserButton = UIButton ()
    @IBOutlet weak var followerUserImage = UIImageView ()
    var isUserFollowing = Int ()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
