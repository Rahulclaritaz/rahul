//
//  XPContactHeaderTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 14/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPContactHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var xprezButton = UIButton ()
    @IBOutlet weak var xprezBottomLine = UIView ()
    @IBOutlet weak var recentButton = UIButton ()
    @IBOutlet weak var recentBottomLine = UIView ()
    @IBOutlet weak var searchBar = UISearchBar ()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
