//
//  StringURLExtension.swift
//  ixprez
//
//  Created by Quad on 5/9/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    
    mutating func replace(_ orginalString : String , with newString : String)
    {
        self = self.replacingOccurrences(of: orginalString, with: newString)
        
    }
}
