//
//  AlertControllerExtension.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 29/08/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    func alertViewDisplay() {
        let alert = UIAlertController(title: "Warning", message: "Hello", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
    }
    
}
