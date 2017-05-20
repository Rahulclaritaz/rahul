//
//  MyUploadWebServices.swift
//  ixprez
//
//  Created by Quad on 5/18/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation


class MyUploadWebServices
{
    
    func getPublicPrivateMyUploadWebService(urlString : String ,dicData : NSDictionary , callback : @escaping (_ dicc: [[String :Any]] ,_ error : Error?) -> Void)
    
    {
        
    
        let url = URL(string: urlString)
        
        let dicDataa = try! JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        var request = URLRequest(url: url!)
        
        request.httpBody = dicDataa
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let taskData = session.dataTask(with: request, completionHandler: {
            (data,response,error) -> Void in
         
            if data != nil && error == nil
            {
                  var jsonData : Any?
                
                do
                {
                    
                  jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                  print(jsonData!)
                    
                }
                
                catch
                {
                    
                }
     
                 let jsonDataValue = jsonData as! [String : Any]
                
                 let jsonDataData = jsonDataValue["data"] as! [String:Any]
                
                 let jsonResule = jsonDataData["Records"] as! [[String : Any]]
              
                 callback(jsonResule,nil)
                
            }
            
            else
            {
                print("error")
                
            }
            
            
        })
        
        taskData.resume()
        
        
        
    }
    
    
    func getDeleteMyUploadWebService(urlString : String ,dicData : NSDictionary , callback : @escaping (_ dicc: [[String :Any]] ,_ error : Error?) -> Void)
        
    {
        
        
        
        
        
        let url = URL(string: urlString)
        
        let dicDataValue = try!  JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        
        var request = URLRequest(url: url!)
        
        request.httpBody = dicDataValue
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let session = URLSession.shared

        
        let taskData = session.dataTask(with: request, completionHandler: {
            (data,response,error) -> Void in
           
            
            let jsonData : Any?
            
        
            if data != nil && error == nil
            {
                
             do
               {
              jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                print(jsonData!)
                
                
            }
            
                catch
            {
                
            }
                
                
                
                
            }
                
            else
            {
                print("error")
                
            }
            
        })
        
        taskData.resume()
        
    
    }
    
}
