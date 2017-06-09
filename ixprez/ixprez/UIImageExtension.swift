//
//  imgExtension.swift
//  ixprez
//
//  Created by Quad on 6/7/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation


extension UIImage
{
    
    var highestQualityJPEGNSData: Data
    {
        return UIImageJPEGRepresentation(self, 1.0)!
    }
    var highQualityJPEGNSData: Data
    {
        return UIImageJPEGRepresentation(self, 0.75)!
    }
    var mediumQualityJPEGNSData: Data
    { return UIImageJPEGRepresentation(self, 0.5)!
    }
    var lowQualityJPEGNSData: Data
    {
        return UIImageJPEGRepresentation(self, 0.25)!
    }
    var lowestQualityJPEGNSData: Data
    {
        return UIImageJPEGRepresentation(self, 0.0)!
    }
}
