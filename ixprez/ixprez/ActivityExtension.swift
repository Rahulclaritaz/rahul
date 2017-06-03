//
//  ActivityExtension.swift
//  ixprez
//
//  Created by Quad on 6/2/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation



 extension UIActivityIndicatorView
{
    
    convenience init(activityIndicatorStyle: UIActivityIndicatorViewStyle, color: UIColor, placeInTheCenterOf parentView: UIView)
    {
        self.init(activityIndicatorStyle: activityIndicatorStyle)
        self.color = color
        self.center = CGPoint(x: parentView.frame.size.width/2, y: parentView.frame.size.height/2)
        parentView.addSubview(self)
        
        self.hidesWhenStopped = true
        
       
    }
    
}
