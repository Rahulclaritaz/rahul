//
//  XPSettingTableViewCell.swift
//  ixprez
//
//  Created by Quad on 6/5/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPSettingTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var lblSettingName: UILabel!
    
    @IBOutlet weak var btnSettingSave: UIButton!
    
    @IBOutlet weak var switchNotify: UISwitch!
    
    @IBOutlet weak var txtEnterSettings: UITextField!
    
    
    @IBOutlet weak var lblWidthSize: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        switchNotify.onTintColor = UIColor.getOrangeColor()
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
