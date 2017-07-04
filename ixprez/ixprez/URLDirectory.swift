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
//    var newURL = "http://183.82.33.232:3000"   //New
//    var url = "http://103.235.104.118:3001"  //Old
    
    
    struct BaseRequestResponseURl {
        func url() -> String
        {
            return "http://183.82.33.232:3000"
        }
    }
    
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
    
    struct UserProfile {
        func url() -> String
        {
            return "http://103.235.104.118:3000/commandService/getProfileImage"
        }
    }
    
    
    struct audioDataUpload {
        func url() -> String
        {
           return "http://103.235.104.118:3000/commandService/audioFileUpload"
        }
    }
    
    
    
    
    struct PrivateData
    {
        func privateDataUrl() -> String
        {
            return "http://103.235.104.118:3000/queryService/myVideosToPlay"
            
            //  return "http://192.168.1.20:3000/queryService/myVideosToPlay"
            
        }
        func privateAcceptRejectAudioVideo() -> String
        {
            return "http://103.235.104.118:3000/commandService/feedbackAboutFile"
            
            //      return "http://192.168.1.20:3000/commandService/feedbackAboutFile"
            
        }
        
        func privateBlockAudioVideo() -> String
        {
            return "http://103.235.104.118:3000/commandService/blockUser"
            
            //  return "http://192.168.1.20:3000/commandService/blockUser"
        }
        
    }
    
    struct MyUpload
    {
        func publicMyUpload() -> String
        {
            
            return "http://103.235.104.118:3000/queryService/myUploads"
            
        }
        func privateMyUpload() -> String
        {
            
            return "http://103.235.104.118:3000/queryService/ownuploads"
            
        }
        
        func deleteMyUploadPublic() -> String
        {
            
            
            return "http://103.235.104.118:3000/commandService/deleteAudioVideo"
            
            
        }
        
        func deleteMyUploadPrivate() -> String
        {
            
            return "http://103.235.104.118:3000/commandService/del_status"
            
        }
        
        
        func uploadEmotionCount() -> String
            
        {
            return "http://103.235.104.118:3000/commandService/emotionCount"
            
        }
        
        func uploadReportAbuse() -> String
        {
            
            return  "http://103.235.104.118:3000/commandService/audioVideoReportAbuse"
            
        }
        
        func saveEmotionCount() -> String
        {
            
            return "http://103.235.104.118:3000/commandService/likeAudioVideo"
            
        }
        
    }
  
    
    struct  Search
    {
        func searchPopularVideo() -> String
        
        {
            return "http://103.235.104.118:3000/queryService/getPopularVideosByHash"
            
        }
        
        func publicVideo() -> String
        {
            
   return "http://103.235.104.118:3000/queryService/getVideosByHashTags"
            
        }
    }
    struct videoDataUpload {
        func url () -> String {
            return "http://103.235.104.118:3000/commandService/videoFileUpload"
        }
    }
    
    struct getIcarouselFeatureURL {
        func url() -> String {
            return  "http://103.235.104.118:3000/commandService/getFeaturedVideoList"
        }
    }
    
    struct treandingURL {
        func url () -> String {
            return "http://103.235.104.118:3000/queryService/getAudioVideoListByLike"
        }
    }
    
    struct recentURL {
    func url () -> String {
            return "http://103.235.104.118:3000/queryService/myVideosList"
    }
    }
    
    struct Setting
    {
        func getPrivateData() -> String
        {
            
            return  "http://103.235.104.118:3000/queryService/getPrivateFollowCount"
            
        }
        func uploadProfileImage() -> String
        {
            
            return "http://103.235.104.118:3000/commandService/profileImage"
        }
    }
    
    struct follow {
        
        func follower() -> String
        {
            return "http://103.235.104.118:3000/commandService/followers"
        }
        
        func unFollower() -> String
        {
            return "http://103.235.104.118:3000/commandService/unfollowers"
            
        }
        
    }

    
    
    
}
