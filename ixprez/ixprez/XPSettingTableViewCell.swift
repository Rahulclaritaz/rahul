//
//  XPSettingTableViewCell.swift
//  ixprez
//
//  Created by Quad on 6/5/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPSettingTableViewCell: UITableViewCell,UITextFieldDelegate
{
    
    @IBOutlet weak var lblSettingName: UILabel!
    
    @IBOutlet weak var btnSettingSave: UIButton!
    
    @IBOutlet weak var switchNotify: UISwitch!
    
    @IBOutlet weak var txtEnterSettings: UITextField!
    
    @IBOutlet weak var imgRightArrow: UIImageView!
    @IBOutlet weak var downArrow: UIButton!
    @IBOutlet weak var saveWidth: NSLayoutConstraint!
    
    @IBOutlet weak var lblWidthSize: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        switchNotify.onTintColor = UIColor.getOrangeColor()
        
        btnSettingSave.layer.cornerRadius = 25.0
        
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("You click on text field for edit purpose")
    }

}
