//
//  DateExtension.swift
//  ixprez
//
//  Created by Quad on 5/9/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//


import Foundation
import UIKit

extension String
    
{
    
  
    


    func getDatePart(dateString : String) -> String
        
        
    {
        
        let dataStringFormatter = DateFormatter()
        
        dataStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date1 = dataStringFormatter.date(from: dateString)
        
      
        let dataStringFormatterDay = DateFormatter()
        
        dataStringFormatterDay.dateFormat = "MMM d, YYYY"
        
        let dayData : String = dataStringFormatterDay.string(from: date1!)
        
      
        return dayData
        
 

    }
 
    func getTimePart(dateString : String) -> String
    {
        
        let dataStringFormatter = DateFormatter()
        
        dataStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date1 = dataStringFormatter.date(from: dateString)
        
        
        let dataStringFormatterTime = DateFormatter()
        
        dataStringFormatterTime.dateFormat = "hh:mm"
        
        let timeData : String = dataStringFormatterTime.string(from: date1!)

        
        return timeData
        
        
        
    }
    
    
    
    
    
    
}
