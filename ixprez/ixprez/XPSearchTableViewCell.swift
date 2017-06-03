//
//  XPSearchTableViewCell.swift
//  ixprez
//
//  Created by Quad on 5/30/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPSearchTableViewCell: UITableViewCell
{
    
    
    @IBOutlet weak var publicSearch: UISearchBar!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
