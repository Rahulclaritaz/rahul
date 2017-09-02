//
//  AlertControllerExtension.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 29/08/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func alertViewControllerWithCancel(headerTile : String , bodyMessage : String) {
        let alert = UIAlertController(title: headerTile, message: bodyMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func alertViewControlerWithOkAndCancel(headerTitle : String, bodyMessage : String) {
        let alert = UIAlertController(title: headerTitle, message: bodyMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            
        }
        let cancal = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancal)
        present(alert, animated: true, completion: nil)
    }
    
}
