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
    
    func getCountryDataWebService(urlString : String ,dicData : NSDictionary, callback : @escaping(_ countData : [[String:Any]] ,_ countNeededData : NSArray, _ error : NSError? ) -> Void)
        
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
            print("Response: \(String(describing: response))")
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
                let jsonArrayData = jsonDictData["data"] as! [[String : Any]]
                let neededData = jsonDictData["data"] as! NSArray
                
                
                print(jsonArrayData)
                callback(jsonArrayData,neededData, nil)
                
                
            } catch {
                print("Error trying to convert data")
                return
            }
        })
        
        task.resume()
        
    }
    
    
    func getLanguageDataWebService(urlString : String ,dicData : NSDictionary, callBack : @escaping (_ countData: [[String:Any]]  , _ neededData : NSArray ,_ error : NSError?) -> Void)
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
                let jsonArrayData   = jsonDictData["data"] as! [[String:Any]]
                
                let needData = jsonDictData["data"] as! NSArray
                
                print(jsonArrayData)
                callBack(jsonArrayData,needData,nil)
                
            } catch {
                print("Error trying to convert data")
                return
            }
        })
        
        task.resume()
        
        
        
    }
    
    
    func getaddDeviceWebService(urlString : String ,dicData : NSDictionary,callBack : @escaping(_ dic : NSDictionary, _ error : NSError?) -> Void)
        
    {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        let urlString = NSURL(string: urlString )
        
        var request = URLRequest(url: urlString! as URL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data,response,error) -> Void in
            
            
            var myData =  NSDictionary()
            
            
            if(data != nil && error == nil)
            {
                do
                {
                    myData  = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    
                    
                }
                catch
                {
                    
                }
                callBack(myData, nil)
                
                
                
                
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
                    
                    print("ccc MMM ", otpMessage)
                    
                    callBack(otpMessage,nil)
                    
                }
                    
                catch
                {
                    
                }
            }
        })
        dataTask.resume()
        
    }
    
    
    func getResendOTPWebService(urlString : String , dicData : NSDictionary,callBack: @escaping(_ message : NSDictionary , _ error : NSError?) -> Void)
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
                
                var getData : Any!
                do
                {
                    getData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    
                    print(getData)
                }
                    
                catch
                {
                    
                }
                
                callBack(getData as! NSDictionary, nil)
                
                
                
            }
            
            
        })
        
        dataTask.resume()
        
        
        
    }
    
    
    func getAddContact(urlString: String, dicData: NSDictionary,callback: @escaping (_ dic: NSDictionary,_ error: Error?) -> Void)
        
    {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        let urlString = NSURL(string: urlString )
        var request = URLRequest(url: urlString! as URL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data,response,error) -> Void in
            
            if(data != nil && error == nil)
            {
                var myData = NSDictionary()
                
                do
                {
                    
                    myData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    
                    print(myData)
                    
                }
                catch
                {
                    
                }
                
                callback(myData , nil)
                
                
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
    
    func getAudioResponse(urlString : String , dictData : NSDictionary, callBack : @escaping(_ message : NSDictionary, _ error : Error?) -> Void) {
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
        let urlString = URL(string : urlString)
        var requestUrl = URLRequest(url: urlString! as URL)
        //        var requestUrl = URLRequest(url : urlString as! URL)
        //        requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        requestUrl.httpBody = jsonData
        let boundary = "--------14737809831466499882746641449----"
        //        let contentType = "multipart/form-data;boundary=\(boundary)"
        requestUrl.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        requestUrl.httpMethod = "POST"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: requestUrl , completionHandler:
        {
            
            (data,response,error) -> Void in
            
            if (data != nil && error == nil) {
                
                do {
                    
                    let jsonData : NSDictionary  = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    print(jsonData)
                    let responseUserImage = jsonData.value(forKey: "data")
                    
                    callBack(responseUserImage as! NSDictionary, error!)
                } catch {
                    
                }
                
            }
        })
        dataTask.resume()
        
    }
    
    
    // This func will upload the data and get the response from the server
    func getVideoResponse (urlString : String , dictData : NSDictionary, callBack : @escaping (_ message : NSDictionary , _ error : Error) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
        let urlString = URL(string : urlString)
        var requestUrl = URLRequest(url: urlString! as URL)
        requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestUrl.httpBody = jsonData
        requestUrl.httpMethod = "POST"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: requestUrl) { (data, response, error) in
            if (data != nil && error == nil)  {
                
                do {
                    
                    let jsonData : NSDictionary  = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    print(jsonData)
                    var jsonResponseStatus : String =  jsonData.value(forKey: "status") as! String
                    
                    if (jsonResponseStatus == "Failed") {
                        return
                    } else {
                        let responseData = jsonData.value(forKey: "data")
                        
                        callBack(responseData as! NSDictionary, error!)
                    }
                    
                    
                } catch {
                    
                }
                
                
            } else {
                return
            }
            
        }
        dataTask.resume()
    }
    
    
    // This function will send the data and get the response from the server.
    
    func getIcarouselFeaturesVideo(urlString : String, dicData: NSDictionary, callBack: @escaping (_ message : [[String : Any]], _ error : NSError? ) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        let urlString = URL(string: urlString)
        var requestedURL = URLRequest(url: urlString! as URL)
        // This will add the authentication token on the header of the API.
        let authtoken = UserDefaults.standard.value(forKey: "authtoken")
        requestedURL.addValue("authtoken \(authtoken)", forHTTPHeaderField:"Authorization")
        requestedURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestedURL.httpBody = jsonData
        requestedURL.httpMethod = "POST"
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: requestedURL) { (data, response, error) in
            if (data != nil && error == nil)
            {
                print("You will get the Response")
                do {
                    let jsonData : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    print(jsonData)
                    
                    
                    let jsonResponseValue : String = jsonData.value(forKey: "status") as! String
                    
                    if (jsonResponseValue == "Failed") {
                        return
                    } else
                    {
                        let responseData  = jsonData["data"] as! [[String : Any]]
                        
                        print(responseData)
                                               
                        callBack(responseData, nil)
                        
                    }
                    
                } catch {
                    
                }
            }else {
                print("You will not get the Response any Error Occour")
                return
            }
            
        }
        dataTask.resume()
    }
    
    
    
    // This function will get the treanding video response from server
    
    func getTreandingVideoResponse(urlString : String , parameter : NSDictionary, callBack : @escaping (_ message : NSArray, _ error : NSError?) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
        let urlString = URL(string: urlString)
        var requestedURL = URLRequest(url: urlString! as URL)
        let authtoken = UserDefaults.standard.value(forKey: "authtoken")
        requestedURL.addValue("authtoken \(authtoken)", forHTTPHeaderField:"Authorization")
        requestedURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestedURL.httpBody = jsonData
        requestedURL.httpMethod = "POST"
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: requestedURL) { (data, response, error) in
            if (data != nil && error == nil) {
                print("You will get the Response")
                do {
                    let jsonData : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    print(jsonData)
                    let jsonResponseValue : String = jsonData.value(forKey: "status") as! String
                    
                    if (jsonResponseValue == "Failed") {
                        return
                    } else {
                        let responseDataDictValue: NSDictionary = jsonData.value(forKey: "data") as! NSDictionary
                        let responseDataArrayValue : NSArray = responseDataDictValue.value(forKey: "Records") as! NSArray
                        callBack(responseDataArrayValue, nil)
                        print(responseDataArrayValue)
                        
                    }
                    
                } catch {
                    
                }
            }else {
                print("You will not get the Response any Error Occour")
                return
            }
            
        }
        dataTask.resume()
        
    }
    
    
    // This function will get the audio Video response from the server
    func getRecentAudioVideoResponse(urlString : String, dictParameter : NSDictionary, callBack : @escaping (_ messageResponse : NSArray , _ error : NSError?) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: dictParameter, options: .prettyPrinted)
        let urlString = NSURL(string: urlString)
        var requestedURl = URLRequest(url: urlString as! URL)
        requestedURl.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestedURl.httpMethod = "POST"
        requestedURl.httpBody = jsonData
        let session = URLSession.shared
        let dataTask = session.dataTask(with: requestedURl) { (data, response, error) in
            
            if (data != nil && error == nil) {
                print("You will get the Response")
                let jsonData: NSDictionary = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                print(jsonData)
                let  jsonStatusValue : String  = jsonData.value(forKey: "status") as! String
                if ( jsonStatusValue == "Failed") {
                    return
                } else {
                    let jsonDictResponse : NSDictionary = jsonData.value(forKey: "data") as! NSDictionary
                    let jsonArrayValue : NSArray = jsonDictResponse.value(forKey: "Records") as! NSArray
                    print(jsonArrayValue)
                    callBack(jsonArrayValue, nil)
                }
                
                
            } else {
                print("You will not get the Response any Error Occour")
                return
                
            }
            
        }
        dataTask.resume()
        
        
    }
    
    // MARK:TODO
    func getCountryLanguageDataWebService(urlString : String ,dicData : NSDictionary, callback : @escaping(_ countData : [[String : Any]] , _ error : NSError? ) -> Void)
        
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
                let jsonArrayData  = jsonDictData["data"] as! [[String : Any]]
                
                print(jsonArrayData)
                callback(jsonArrayData, nil)
                
            } catch {
                print("Error trying to convert data")
                return
            }
        })
        
        task.resume()
        
    }
    
    
   // This method will update the number of count of view
    
    func updateNumberOfViewOfCount (urlString : String , dicData : NSDictionary, callBack : @escaping (_ countData : Any, _ error : NSError?) -> Void) {
        
        guard let urlStringData = URL(string : urlString) else {
            print("We didn't get the Url")
            return
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        var requestedURL = URLRequest(url: urlStringData as URL)
        requestedURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestedURL.httpBody = jsonData
        requestedURL.httpMethod = "POST"
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: requestedURL) { (data, response, error) in
            if (data != nil && error == nil) {
                print("You will get the Response")
                do {
                    let jsonData : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    print(jsonData)
                    let jsonResponseValue : String = jsonData.value(forKey: "status") as! String
                    
                    if (jsonResponseValue == "Failed") {
                        return
                    } else {
                     callBack("1", nil)
                        
                    }
                    
                } catch {
                    
                }
            }else {
                print("You will not get the Response any Error Occour")
                return
            }
            
        }
        dataTask.resume()
        
        
    }
    
    
    // This method will update the notification
    
    func getNotificationData (urlString : String , dicData : NSDictionary, callBack : @escaping (_ countData : [[String : Any]], [String : Any], _ error : NSError?) -> Void) {
        
        guard let urlStringData = URL(string : urlString) else {
            print("We didn't get the Url")
            return
        }
        let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        var requestedURL = URLRequest(url: urlStringData as URL)
        requestedURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestedURL.httpBody = jsonData
        requestedURL.httpMethod = "POST"
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: requestedURL) { (data, response, error) in
            if (data != nil && error == nil) {
                print("You will get the Response")
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(jsonData)
                    
                    let jsonResponseValue : String = (jsonData as AnyObject).value(forKey: "status") as! String
                    
                    if (jsonResponseValue == "Failed") {
                        return
                    } else {
                        let jsonDictResponse  = jsonData as! [String : Any]
                        print(jsonDictResponse)
                        let jsonDictDataValue = jsonDictResponse["data"] as! [String : Any]
                        let jsonArrayValue  = jsonDictDataValue["Records"] as! [[String : Any]]
                        print(jsonArrayValue)
                        callBack(jsonArrayValue,jsonDictDataValue, nil)
                        
                    }
                    
                } catch {
                    
                }
            }else {
                print("You will not get the Response any Error Occour")
                return
            }
            
        }
        dataTask.resume()
        
        
    }
    
    
}
