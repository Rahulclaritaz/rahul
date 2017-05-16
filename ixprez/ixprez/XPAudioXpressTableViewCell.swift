//
//  XPAudioXpressTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit


class XPAudioXpressTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var expressTitleTextField = UITextField()
    @IBOutlet weak var addContactButon = UIButton()
    @IBOutlet weak var labelCell = UILabel()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addContactButon?.isHidden = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        print("u click on the express cell")
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
