//
//  XPAudioXpressTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

protocol AudioTextFieldDelegate {
    func addContact (cell: XPAudioXpressTableViewCell)
}

class XPAudioXpressTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    // MARK: Properties
    
    /// The text input field
    @IBOutlet weak var expressTitleTextField = UITextField()
    @IBOutlet weak var addContactButon = UIButton()
    @IBOutlet weak var labelCell = UILabel()
    var delegate : AudioTextFieldDelegate?
    
    // The block to call when the value of the textfield changes
//    var textFieldValueChanged : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addContactButon?.isHidden = true
    }
    
    // MARK: UITextFieldDelegate
    
    /// Handle the event when user start changing the field
    func textFieldDidBeginEditing(textField: UITextField) {
        
//        delegate?.textFieldValueChanged()
        print("u click on the express cell")
        
    }
    
    /// Handle the event when user finishing changing the value of the text field
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("You finish to write the textfield'")
//        textFieldValueChanged?()
    }
    
    func textFieldValueChanged (sender : XPAudioXpressTableViewCell) {
//        expressTitleTextField?.text = "Jay Mata di"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addContactButtonTapped (sender: Any) {
        delegate?.addContact(cell: self)
    }
    
    
}


