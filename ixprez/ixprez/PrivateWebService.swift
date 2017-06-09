//
//  PrivateWebServices.swift
//  ixprez
//
//  Created by Quad on 5/8/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation

class  PrivateWebService
{
    


    
    func getPrivateDataWebService(urlString : String ,dicData : NSDictionary , callback : @escaping (_ dicc: [[String :Any]] ,_ error : Error?) -> Void)
        
    {
        let privateData = try! JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
      
        request.httpBody = privateData
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler:
        { (data,response,error) -> Void in
            
            if( data != nil && error == nil)
            {
                var privateDictionary : Any?
                
                do
                {
        
                    privateDictionary = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    print(privateDictionary!)
              
                    
                }
                
                catch
                {
                }
                
                let myPrivateDictionary = privateDictionary  as! [ String : Any]
                
                let dataPrivate = myPrivateDictionary["data"] as! [ String : Any]
                
                let recordPrivate = dataPrivate["Records"] as! [[String : Any]]
                
                print(recordPrivate)
         
                callback(recordPrivate,error)
         
                
            }
            
        
    
        })
        
        dataTask.resume()
        
    }
    
    
    func  getPrivateAcceptRejectWebService(urlString : String ,dicData : NSDictionary , callback : @escaping (_ dic : NSDictionary , _ error : Error?) -> Void)
    {
        
        
        
        let datadic = try! JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        
        let url = URL(string: urlString )
       
        var request = URLRequest(url: url!)
        
        request.httpBody = datadic
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        
        let taskData = session.dataTask(with: request, completionHandler: {
            (data,response,error ) in
            
            if data != nil && error == nil
            
            {
             
                var  jsonDic : Any?
                
                
                do
                {
                  
                 jsonDic  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    
                  
                  print(jsonDic!)
                    
                    
                }
                
                catch
                {
                    
                }
                
                let sendBackDic = jsonDic as! NSDictionary
                
                
                callback(sendBackDic, error)
                
            }
        })
        
        taskData.resume()
    
    }
    
    // This method will will return the fllower and Fllowing user data from the server in [setting page]
    func  getPrivateData(urlString : String ,dicData : [String:Any] , callback : @escaping (_ dic : [String:Any] , _ error : Error?) -> Void)
    {
        
        let datadic = try! JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        let urlData = URL(string: urlString )
        
        var requestData = URLRequest(url: urlData!)
        
        requestData.httpBody = datadic
        
        requestData.httpMethod = "POST"
        
        requestData.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session1 = URLSession.shared
        
        print("mathan mathan")
        
        
        let taskData1 = session1.dataTask(with: requestData, completionHandler: {
            (data,response,error ) in
            
            if data != nil && error == nil
                
            {
                var  jsonDic = [String:Any]()
                
                do
                {
                    
                    jsonDic  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                    
                }
                    
                catch
                {
                    
                }
                callback(jsonDic, error)
                
            }
        })
        
        taskData1.resume()
    }
    
}
