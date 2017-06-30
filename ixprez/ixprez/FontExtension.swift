//
//  FontExtension.swift
//  ixprez
//
//  Created by Quad on 6/17/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation


extension UIFont
{
    class func xprezBoldFontOfSize(size : CGFloat) -> (UIFont)
    {
       return UIFont(name: "MoskSemi-Bold600", size: size)!
        
    }
    
    class func xprezMediumFontOfsize(size : CGFloat) -> (UIFont)
    {
        
        return UIFont(name: "MoskMedium500", size: size)!
        
    }
    
    class func xprezLightFontOfSize(size : CGFloat) -> (UIFont)
    {
        
        return UIFont(name: "MoskLight300", size: size)!
        
        
    }
}
