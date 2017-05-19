//
//  Service.swift
//  ixprez
//
//  Created by Quad on 5/2/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation

class XPWebService
{
    
    func getCountryDataWebService(urlString : String ,dicData : NSDictionary, callback : @escaping(_ countData : NSArray , _ error : NSError? ) -> Void)
        
    {
       guard let urlStringData = URL(string: urlString) else
       {
        print("Error : can not create the URL")
        return
        }
        
        let request = NSMutableURLRequest(url: urlStringData)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: dicData, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            print("Response: \(response)")
            guard let responseData = data else {
                print("Error: didn't  get the data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonDictData: NSDictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary else {
                    print("Error : didn't get the json Data")
                    return
                }
                let jsonArrayData : NSArray = jsonDictData["data"] as! NSArray
            
                print(jsonArrayData)
                callback(jsonArrayData, nil)
                
            } catch {
                print("Error trying to convert data")
                return
            }
        })
        
        task.resume()

    }
    
    
    func getLanguageDataWebService(urlString : String ,dicData : NSDictionary, callBack : @escaping (_ countData: NSArray , _ error : NSError?) -> Void)
    {
        
        
        guard let urlStringData = URL(string: urlString) else {
            print("Error : can not create the URL")
            return
        }
        
        let request = NSMutableURLRequest(url: urlStringData as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
    
        request.httpBody = try! JSONSerialization.data(withJSONObject: dicData, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            guard let responseData = data else {
                print("Error: didn't get the data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let jsonDictData: NSDictionary = try JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary else {
                    print("Error : didn't get the json Data")
                    return
                }
                let jsonArrayData : NSArray  = jsonDictData["data"] as! NSArray
                print(jsonArrayData)
                callBack(jsonArrayData, nil)
            } catch {
                print("Error trying to convert data")
                return
            }
        })
        
        task.resume()

        
        
    }

    
    func getaddDeviceWebService(urlString : String ,dicData : NSDictionary )
    {
    
        let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        let urlString = NSURL(string: urlString )
        
        var request = URLRequest(url: urlString as! URL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data,response,error) -> Void in
            
            if(data != nil && error == nil)
            {
                do
                {
                    let myData: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    print(myData)
                    let  dicData = myData.value(forKey: "data")
                    print(dicData)
                    
                }
                catch
                {
                    
                }
            }
        })
        
        dataTask.resume()
    }

    
    
   // This method will send the request to server and will get the response
    func getOTPWebService(urlString : String , dicData : NSDictionary, callBack : @escaping (_ message : String, _ error : NSError? ) -> Void)
    {
    
      let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
    
        let url = URL(string: urlString)
        var request = URLRequest(url:url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
       let dataTask = session.dataTask(with: request, completionHandler:
        {
            (data,response,error) -> Void in
            
            if ( error == nil && data != nil)
            {
                do{
                    let otpArray: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    print(otpArray)
                    let otpMessage : String = otpArray.value(forKey: "status") as! String
                    callBack(otpMessage,nil)
                    
                    
//                    callBack (otpArray as! Dictionary,nil)
                }
                
                catch
                {
                    
                }
            }
       })
        dataTask.resume()
        
    }
    

    func getResendOTPWebService(urlString : String , dicData : NSDictionary)
    
    {
        
       let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        let url = NSURL(string: urlString)
        
        var request = URLRequest(url: url! as URL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        request.httpMethod = "POST"
       
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request , completionHandler:
        {
            
            (data,response,error) -> Void in
            
        
            if data != nil && error == nil
            {
                
                do
                {
                   let getData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    print(getData)
                }
        
                catch
                {
                    
                }
       
             }
   
            
        })
        
        dataTask.resume()
        
        
        
    }
 
    func getAddContact(urlString: String, dicData: NSDictionary,callback: @escaping (_ dic: NSDictionary,_ error: Error?) -> Void)
    
    {
        
     let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        let urlString = NSURL(string: urlString )
        var request = URLRequest(url: urlString as! URL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data,response,error) -> Void in
            
          if(data != nil && error == nil)
          {
            do
            {
                
                let myData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                print(myData)
                
                callback(myData as! NSDictionary, nil)
            }
            catch
            {
                
            }
         }
            
        })
        
        dataTask.resume()
    }
    
    func getUserProfileWebService(urlString : String, dicData : NSDictionary, callback : @escaping (_ message : NSDictionary , _ error : Error?) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        let urlString = URL(string : urlString)
        var requestUrl = URLRequest(url: urlString! as URL)
//        var requestUrl = URLRequest(url : urlString as! URL)
        requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestUrl.httpBody = jsonData
        requestUrl.httpMethod = "POST"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: requestUrl , completionHandler:
        {
            
            (data,response,error) -> Void in
            
            if (data != nil && error == nil) {
                
                do {
                    
                    let jsonData : NSDictionary  = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    print(jsonData)
                    var jsonResponseStatus : String =  jsonData.value(forKey: "status") as! String
                    
                    if (jsonResponseStatus == "Failed") {
                        return
                    } else {
                        let responseUserImage = jsonData.value(forKey: "data")
                        
                        callback(responseUserImage as! NSDictionary, nil)
                    }
                    
                    
                } catch {
                    
                }
                
            } else {
                return
            }
        })
        dataTask.resume()
        
    }
    
    // This function will upload the audio data with parameter and will return the response.
    
//    func uploadTheAudioData (urlString : String , dictData : NSDictionary, callBack : @escaping(_ message : NSDictionary, _ error : Error) -> Void) {
//        
//        let jsonData = try? JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
//        let urlString = URL(string : urlString)
//        var requestUrl = URLRequest(url: urlString! as URL)
//        //        var requestUrl = URLRequest(url : urlString as! URL)
//        requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        requestUrl.httpBody = jsonData
//        requestUrl.httpMethod = "POST"
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: requestUrl , completionHandler:
//        {
//            
//            (data,response,error) -> Void in
//            
//            if (data != nil && error == nil) {
//                
//                do {
//                    
//                    let jsonData : NSDictionary  = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
//                    
//                    print(jsonData)
//                    let responseUserImage = jsonData.value(forKey: "data")
//                    
//                    callback(responseUserImage as! NSDictionary, nil)
//                } catch {
//                    
//                }
//                
//            }
//        })
//        dataTask.resume()
//        
//    }
    
    
}
