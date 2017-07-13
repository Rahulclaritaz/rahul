//
//  PopupAlert.swift
//  ixprez
//
//  Created by Quad on 7/13/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation

import UIKit

public extension UIAlertController
{
    
   func show()
   {
 
    let window = UIWindow(frame: UIScreen.main.bounds)
    
    let vc = UIViewController()
    
    vc.view.backgroundColor = UIColor.clear
    
    window.rootViewController = vc
 
    window.makeKeyAndVisible()

    vc.present(self, animated: true, completion: { _ in
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            
            let delayInSeconds = 2.0
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                
              self.dismiss(animated: true, completion: nil)
                
           }
           }, completion: nil)

          })
   
    
    
   }
    
       
}
