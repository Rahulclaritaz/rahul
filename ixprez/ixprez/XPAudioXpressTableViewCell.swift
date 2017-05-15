//
//  XPAudioXpressTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit


class XPAudioXpressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var expressTitleTextField: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        expressTitleTextField.delegate = self as? UITextFieldDelegate
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        print("u click on the express cell")
        
        expressTitleTextField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func reloadTable() {
        expressTitleTextField.text = "Rahul"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
