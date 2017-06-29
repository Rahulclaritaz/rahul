//
//  XPDashBoardProfileTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 28/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPDashBoardProfileTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellUserProfileImage = UIImageView()
    @IBOutlet weak var userProfileBorder = UIImageView()
    @IBOutlet weak var pulseAnimationView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellUserProfileImage?.layer.masksToBounds = false
        cellUserProfileImage?.layer.borderColor = UIColor.white.cgColor
        cellUserProfileImage?.layer.cornerRadius = (cellUserProfileImage?.frame.size.height)!/2
        cellUserProfileImage?.clipsToBounds = true
        
        userProfileBorder?.layer.borderWidth = 5.0
        userProfileBorder?.layer.masksToBounds = false
        userProfileBorder?.layer.borderColor = UIColor.white.cgColor
        userProfileBorder?.layer.cornerRadius = (userProfileBorder?.layer.frame.size.height)!/2
        userProfileBorder?.clipsToBounds = true
        userProfileBorder?.alpha = 0.1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
