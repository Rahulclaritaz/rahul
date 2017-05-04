//
//  URLDirectory.swift
//  ixprez
//
//  Created by Quad on 5/2/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation


struct URLDirectory
{
  
    
    struct Country {
     
        func url() -> String
        {
            return "http://103.235.104.118:3000/queryservice/getIsoList"
        }
        
        }
    
    
  

    struct Language {
        func url() -> String
        {
            return "http://103.235.104.118:3000/queryservice/getIsoList"
        }
    }
    
    struct  RegistrationData
    {
    
        func url() -> String
        {
            
            return "http://103.235.104.118:3000/commandService/addDevice"
    
        }
    }
    struct OTPVerification
    {
        
        func url() -> String
        {
            
            return "http://103.235.104.118:3000/commandService/OTPVerification"
        }
        
    }
    
   
    struct ResendOTP
    {
        
        func url() -> String
        {
            return "http://103.235.104.118:3000/commandService/resendOTP"
            
        }
        
    }
    
    
    
}
