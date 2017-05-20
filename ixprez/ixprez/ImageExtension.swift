//
//  ImageExtension.swift
//  ixprez
//
//  Created by Quad on 5/9/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation
import  UIKit


extension  UIImageView{
    
    
    func getImageFromUrl(_ urlString : String)
    {
        
        let url = NSURL(string: urlString)
        
        let session = URLSession.shared
        
        let taskData = session.dataTask(with: url! as URL, completionHandler: {(data,response,error) -> Void  in
           
         if (data != nil)
         {
            
            DispatchQueue.main.async {
                
                self.image = UIImage(data: data!)
     
            }
            
            
        }
            
 
        })
            
        
        taskData.resume()
        

}
}









