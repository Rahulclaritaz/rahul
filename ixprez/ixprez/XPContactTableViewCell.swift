//
//  XPContactTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 14/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactUserName = UILabel()
    @IBOutlet weak var contactUserEmail = UILabel()
    @IBOutlet weak var contactUserProfile = UIImageView ()
    @IBOutlet weak var contactType = UIImageView ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
