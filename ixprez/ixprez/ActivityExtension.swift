//
//  ActivityExtension.swift
//  ixprez
//
//  Created by Quad on 6/2/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation
import UIKit



 extension UIActivityIndicatorView
{
    
    convenience init(activityIndicatorStyle: UIActivityIndicatorViewStyle, spinColor: UIColor,bgColor : UIColor,placeInTheCenterOf parentView: UIView)
    {
        self.init(activityIndicatorStyle: activityIndicatorStyle)
        self.color = spinColor
        //self.center = CGPoint(x: parentView.frame.size.width/2, y: parentView.frame.size.height/2)
     
        self.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
      
        self.center = CGPoint(x: parentView.frame.size.width/2, y: parentView.frame.size.height/2)
        
      
        self.hidesWhenStopped = true
        
        self.startAnimating()
        
        self.backgroundColor = bgColor
        
        self.layer.cornerRadius = 6.0
        
        self.clipsToBounds = true
        
        
        parentView.addSubview(self)
        
     
    }
    
}
