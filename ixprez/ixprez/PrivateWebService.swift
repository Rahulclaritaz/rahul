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
    


    
    func getPrivateDataWebService(urlString : String ,dicData : NSDictionary , callback : @escaping (_ dicc: NSArray,_ error : Error?) -> Void)
        
    {
        let privateData = try! JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
      
        request.httpBody = privateData
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // This will add the authentication token on the header of the API.
        let authtoken = UserDefaults.standard.value(forKey: "authToken")
        request.addValue(authtoken as! String, forHTTPHeaderField: "authtoken")

        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler:
        { (data,response,error) -> Void in
            
            if( data != nil && error == nil)
            {
//                var privateDictionary : Any?
                
                do
                {
        
                    let  jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    print(jsonData)
              
                    let jsonResponseValue : String = (jsonData as AnyObject).value(forKey: "status") as! String
                    
                    if(jsonResponseValue == "Failed") {
                        return
                    } else {
                        return
                        
//                        let jsonArrayValue : NSArray = (jsonData as AnyObject).value(forKey: "Records") as! NSArray
//                        
//                        if (jsonArrayValue == nil) {
//                            print("Record have No value to display in serach ")
//                            return
//                        } else {
//                           callback(jsonArrayValue,nil)
//                        }
                        
//                        let jsonDictResponse = jsonData as! [String : Any]
//                        print(jsonDictResponse)
//                        let jsonDictDataValue = jsonDictResponse["data"] as! [String : Any]
//                        let jsonArrayValue = jsonDictDataValue["Records"] as! [[String : Any]]
                        
                    }
                }
                
                catch
                {
                }
                
                
//                let myPrivateDictionary = privateDictionary  as! [ String : Any]
//                
//                let dataPrivate = myPrivateDictionary["data"] as! [ String : Any]
//                
//                let recordPrivate = dataPrivate["Records"] as! [[String : Any]]
//                
//                print(recordPrivate)
//         
//                callback(recordPrivate,myPrivateDictionary,error)
         
                
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
        
        // This will add the authentication token on the header of the API.
        let authtoken = UserDefaults.standard.value(forKey: "authToken")
        request.addValue(authtoken as! String, forHTTPHeaderField: "authtoken")
        
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
    
    
    func  getPrivateAcceptRejectWebService1(urlString : String ,dicData : [String : [String]] , callback : @escaping (_ dic : NSDictionary , _ error : Error?) -> Void)
    {
        
        
        
        let datadic = try! JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        
        let url = URL(string: urlString )
        
        var request = URLRequest(url: url!)
        
        request.httpBody = datadic
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // This will add the authentication token on the header of the API.
        let authtoken = UserDefaults.standard.value(forKey: "authToken")
        request.addValue(authtoken as! String, forHTTPHeaderField: "authtoken")
        
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

    func  getPrivateAcceptRejectWebService2(urlString : String ,dicData : [String : [String]] , callback : @escaping (_ dic : NSDictionary , _ error : Error?) -> Void)
    {
        
        
        
        let datadic = try! JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        
        let url = URL(string: urlString )
        
        var request = URLRequest(url: url!)
        
        request.httpBody = datadic
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // This will add the authentication token on the header of the API.
        let authtoken = UserDefaults.standard.value(forKey: "authToken")
        request.addValue(authtoken as! String, forHTTPHeaderField: "authtoken")
        
        let session = URLSession.shared
        
        
        let taskData1 = session.dataTask(with: request, completionHandler:
        {(data,response,error ) in
            
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
                    print("Data No")
                }
                
                let sendBackDic = jsonDic as! NSDictionary
                
                
                callback(sendBackDic, error)
                
            }
            else
                
            {
                print("Not data ")
            }
        })
        
        taskData1.resume()
        
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
        
        // This will add the authentication token on the header of the API.
        let authtoken = UserDefaults.standard.value(forKey: "authToken")
        requestData.addValue(authtoken as! String, forHTTPHeaderField: "authtoken")
        // This will add the authentication token on the header of the API.
//        let authtoken = UserDefaults.standard.value(forKey: "authtoken")
//requestData.addValue("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbF9pZCI6InJhaHVsQGNsYXJpdGF6LmNvbSIsImlhdCI6MTUwNDU5MTY1MiwiZXhwIjoxODE5OTUxNjUyfQ.zAvHJ_5ReoTPogypidnA_SJy1SWxl_Br9Du-Yv_34ck", forHTTPHeaderField: "authtoken")
        //        requestData.addValue(authtoken as! String, forHTTPHeaderField:"Authorization")
        
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
