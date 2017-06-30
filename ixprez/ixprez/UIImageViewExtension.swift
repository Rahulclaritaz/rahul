//
//  ImageExtension.swift
//  ixprez
//
//  Created by Quad on 5/9/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation
import  UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension  UIImageView{
    
    
    func getImageFromUrl(_ urlString : String)
    {
        
        self.image = nil
        
        let catchImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage
        
        if  catchImage != nil
        {
            
            
            self.image = catchImage
            
        }
            
        else
        {
            
            let session = URLSession.shared
            
            let url = URL(string:urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
            
            
            let taskData = session.dataTask(with:url as URL, completionHandler: {(data,response,error) -> Void  in
                
                if (data != nil)
                {
                    // Cache to image so it doesn't need to be reloaded every time the user scrolls and table cells are re-used.
                    
                    
                    DispatchQueue.main.async {
                        
                        if let downloadedImage = UIImage(data: data!)
                        {
                            imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                            self.image = UIImage(data: data!)
                            
                        }
                        
                    }
                    
                    
                }
                
                
                
            })
            
            
            
            taskData.resume()
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
