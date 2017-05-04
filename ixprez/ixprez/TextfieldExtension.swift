//
//  TextfieldExtension.swift
//  ixprez
//
//  Created by Quad on 5/3/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation
import UIKit

extension UITextField
{

    func textFieldBoarder ( txtColor : UIColor , txtWidth : CGFloat ) -> UITextField
    {
       
        self.borderStyle = UITextBorderStyle.none
        let border = CALayer()
        let borderWidth : CGFloat = txtWidth
        border.borderWidth = borderWidth
        border.borderColor = txtColor.cgColor
        border.frame = CGRect(x: 0, y: CGFloat(self.frame.size.height - borderWidth), width: CGFloat(self.frame.size.width), height: CGFloat(self.frame.size.height - 15))
        
        self.layer.addSublayer(border)
        
        return self
        
    
    }
  
}
