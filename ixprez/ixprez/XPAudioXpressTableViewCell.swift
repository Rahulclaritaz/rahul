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
    func textFieldValidate(textFieldName : String, row : Int)
}

class XPAudioXpressTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    // MARK: Properties
    
    /// The text input field
    @IBOutlet weak var expressTitleTextField = UITextField()
    @IBOutlet weak var addContactButon = UIButton()
    @IBOutlet weak var labelCell = UILabel()
    var cellLabelExpress = UILabel ()
    var cellLabelMood = UILabel()
    var cellLabelFeeling = UILabel()
    var delegate : AudioTextFieldDelegate?
    var pickerStatusType = UILabel()
    var indexPathRow = Int ()
//    var audio = XPAudioViewController ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        expressTitleTextField?.delegate = self
        addContactButon?.isHidden = true
//        audioDelegate.delegateCell = self
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
//        delegate?.textFieldValidate(textFieldName: textField.text!)
        expressTitleTextField?.text = textField.text
        if (pickerStatusType.text == "Private" ){
            guard (indexPathRow == 0) else {
                delegate?.textFieldValidate(textFieldName: textField.text! , row: indexPathRow)
//            delegate?.textFieldValidate(textFieldName: cellLabelFeeling.text!)
                cellLabelFeeling.text = textField.text
                return
            }
            delegate?.textFieldValidate(textFieldName: textField.text!, row: indexPathRow)
            cellLabelExpress.text = textField.text
            print("The picker status type is :\(pickerStatusType.text)")
        } else if (pickerStatusType.text == "Public") {
            guard (indexPathRow == 0) else {
                delegate?.textFieldValidate(textFieldName: textField.text!, row:  indexPathRow)
                cellLabelMood.text = textField.text
                return
            }
            delegate?.textFieldValidate(textFieldName: textField.text!, row: indexPathRow)
            cellLabelExpress.text = textField.text
           print("The picker status type is :\(pickerStatusType.text)")
        } else if  (pickerStatusType.text == "Both") {
            if (indexPathRow == 0) {
                delegate?.textFieldValidate(textFieldName: textField.text!, row: indexPathRow)
                cellLabelMood.text = textField.text
            } else if (indexPathRow == 1) {
                delegate?.textFieldValidate(textFieldName: textField.text! , row:  indexPathRow)
               cellLabelExpress.text = textField.text
                
            } else if (indexPathRow == 2) {
                delegate?.textFieldValidate(textFieldName: textField.text! , row: indexPathRow)
                cellLabelFeeling.text = textField.text
                
            }

            print("The picker status type is :\(pickerStatusType.text)")
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //This the delegate method for the add contact method.
    @IBAction func addContactButtonTapped (sender: Any) {
        delegate?.addContact(cell: self)
    }
    
    
   // This is delegate method that will return the textfield value according to picker type.
//    func cellTextData(vc: XPAudioViewController) {
//        vc.delegateCell = self
//        if (pickerStatusType.text == "Private" ){
//            if (indexPathRow == 0) {
//                vc.emailAddressLabel.text =  cellLabelExpress.text
//            } else if (indexPathRow == 1) {
//                vc.feelingsLabel.text =  cellLabelFeeling.text
//                
//            }
//        } else if (pickerStatusType.text == "Public") {
//            if (indexPathRow == 0) {
//                vc.moodLabel.text =   cellLabelMood.text
//            } else if (indexPathRow == 1) {
//                vc.feelingsLabel.text =  cellLabelFeeling.text
//                
//            }
//        } else if  (pickerStatusType.text == "Both") {
//            if (indexPathRow == 0) {
//              vc.moodLabel.text =   cellLabelMood.text
//            } else if (indexPathRow == 1) {
//              vc.emailAddressLabel.text =  cellLabelExpress.text
//                
//            } else if (indexPathRow == 2) {
//               vc.feelingsLabel.text =  cellLabelFeeling.text
//                
//            }
//        }
//    }
    
    
}


