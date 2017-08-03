//
//  XPContactTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 14/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit


class XPContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactUserName = UILabel()
    @IBOutlet weak var contactUserEmail = UILabel()
    @IBOutlet weak var contactUserProfile = UIImageView ()
    @IBOutlet weak var contactType = UIImageView ()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCircularAvatar() {
        contactUserProfile?.layer.cornerRadius = (contactUserProfile?.bounds.size.width)! / 2.0
        contactUserProfile?.layer.masksToBounds = true
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setCircularAvatar()
    }
    
    func configureWithContactEntry(_ contact: ContactList)
    {
        contactUserProfile?.image = nil
        
        setCircularAvatar()
        
        
        if expressEmailId.contains(contact.emailId)
        {
            contactType?.image =  UIImage(named: "ExpressUser")
        }
            
        else{
            contactType?.image =  UIImage(named: "ContactUser")
            
        }
        
        
        if contact.imageData != nil
        {
            
            contactUserName?.text = contact.userName
            contactUserEmail?.text = contact.emailId!
            contactUserProfile?.image = contact.imageData
            
        }
        else
        {
            
            
            contactUserName?.text = contact.userName
            contactUserEmail?.text = contact.emailId!
            contactUserProfile?.image = UIImage(named: "")
            
            
        }
        
    }
    
    func configureWithContactEntry1(_ contact : ContactList)
    {
        
        contactType?.image =  UIImage(named: "ExpressUser")
         
        if contact.imageData != nil
        {
         
            contactUserName?.text = contact.userName
            contactUserEmail?.text = contact.emailId!
            contactUserProfile?.image = contact.imageData
            
        }
        else
        {
            contactUserName?.text = contact.userName
            contactUserEmail?.text = contact.emailId!
            contactUserProfile?.image = UIImage(named: "")
        }
        
        setCircularAvatar()
    }
    

}
