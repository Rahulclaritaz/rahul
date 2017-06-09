//
//  XPSettingLanConDoneTableViewCell.swift
//  ixprez
//
//  Created by Quad on 6/8/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPSettingLanConDoneTableViewCell: UITableViewCell
{

    @IBOutlet weak var btnDismissView: UIButton!
    
    
    @IBOutlet weak var btnDoneDismiss: UIButton!
 
    override func awakeFromNib() {
        super.awakeFromNib()
     
      btnDismissView.layer.cornerRadius = 5.0
        
      btnDismissView.backgroundColor = UIColor.getOrangeColor()
        
      btnDoneDismiss.layer.cornerRadius = 5.0
        
      btnDoneDismiss.backgroundColor = UIColor.getOrangeColor()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
