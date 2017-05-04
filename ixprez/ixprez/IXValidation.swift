//
//  IXValidation.swift
//  ixprez
//
//  Created by Quad on 5/3/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation
import UIKit


extension String
{
    func isValidEmail() -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
 
 
}
