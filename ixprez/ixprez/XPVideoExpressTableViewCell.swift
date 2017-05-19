//
//  XPVideoExpressTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 19/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

protocol videoAddContactDelegate {
    func addContactButtonTapped (cell : XPVideoExpressTableViewCell)
}

class XPVideoExpressTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    // MARK: Properties
    
    /// The text input field
    @IBOutlet weak var expressTitleTextField = UITextField()
    @IBOutlet weak var addContactButon = UIButton()
    @IBOutlet weak var labelCell = UILabel()
    var delegate : videoAddContactDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        expressTitleTextField?.delegate = self
        addContactButon?.isHidden = true
    }
    
    // MARK: UITextFieldDelegate
    
    /// Handle the event when user start changing the field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("u click on the express cell")
        expressTitleTextField?.text = ""
    }
    
    /// Handle the event when user finishing changing the value of the text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("You finish to write the textfield'")
        expressTitleTextField?.text = textField.text
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //This the delegate method for the add contact method.
    @IBAction func addContactButtonTapped (sender: Any) {
        delegate?.addContactButtonTapped(cell: self)
    }

}
