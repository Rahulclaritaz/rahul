//
//  XPDashboardHeaderTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 06/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPDashboardHeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var treadingButton = UIButton ()
    @IBOutlet weak var recentButton = UIButton ()
    @IBOutlet weak var treadingViewLine = UIView ()
    @IBOutlet weak var recentViewLine = UIView ()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
