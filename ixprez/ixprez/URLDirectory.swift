//
//  URLDirectory.swift
//  ixprez
//
//  Created by Quad on 5/2/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import Foundation

var UniversalURL : String = "http://34.234.11.46:3000/" // universal
var localURL : String = "http://183.82.33.232:3000/"   //local
var LiveURL : String = "http://103.235.104.118:3000/"   //Live

struct URLDirectory
{
    
    
    
    struct BaseRequestResponseURl {
        func url() -> String
        {
            return "http://183.82.33.232:3000"
        }
    }
    
    struct Country {
     
        func url() -> String
        {
            return    localURL + "queryservice/getIsoList"
        }
        
        }
    
    
  

    struct Language {
        func url() -> String
        {
            return  localURL + "queryservice/getIsoList"
        }
    }
    
    struct  RegistrationData
    {
    
        func url() -> String
        {
            
            return  localURL + "commandService/addDevice"
    
        }
    }
    struct OTPVerification
    {
        
        func url() -> String
        {
            
            return  localURL + "commandService/OTPVerification"
        }
        
    }
    
   
    struct ResendOTP
    {
        
        func url() -> String
        {
            return  localURL + "commandService/resendOTP"
            
        }
        
    }
    
    struct UserProfile {
        func url() -> String
        {
            return  localURL + "commandService/getProfileImage"
        }
    }
    
    
    struct audioDataUpload {
        func url() -> String
        {
           return  localURL + "commandService/audioFileUpload"
        }
    }
    
    
    
    
    struct PrivateData
    {
        func privateDataUrl() -> String
        {
            return localURL + "queryService/myVideosToPlay"
            
            //  return "http://192.168.1.20:3000/queryService/myVideosToPlay"
            
        }
        func privateAcceptRejectAudioVideo() -> String
        {
            return localURL + "commandService/feedbackAboutFile"
            
            //      return "http://192.168.1.20:3000/commandService/feedbackAboutFile"
            
        }
        
        func privateBlockAudioVideo() -> String
        {
            return localURL + "commandService/blockUser"
            
            //  return "http://192.168.1.20:3000/commandService/blockUser"
        }
        
         func audioVideoReportAbuse() -> String
        {
            
            return localURL + "commandService/audioVideoReportAbuse"
        }
        
    }
    
    struct MyUpload
    {
        func publicMyUpload() -> String
        {
            
            return localURL + "queryService/myUploads"
            
        }
        func privateMyUpload() -> String
        {
            
            return localURL + "queryService/ownuploads"
            
        }
        
        func deleteMyUploadPublic() -> String
        {
            
            
            return localURL + "commandService/deleteAudioVideo"
            
            
        }
        
        func deleteMyUploadPrivate() -> String
        {
            
            return localURL + "commandService/del_status"
            
        }
        
        
        func uploadEmotionCount() -> String
            
        {
            return localURL + "commandService/emotionCount"
            
        }
        
        func uploadReportAbuse() -> String
        {
            
            return  localURL + "commandService/audioVideoReportAbuse"
            
        }
        
        func saveEmotionCount() -> String
        {
            
            return localURL + "commandService/likeAudioVideo"
            
        }
        
    }
  
    
    struct  Search
    {
        func searchPopularVideo() -> String
        
        {
            return localURL + "queryService/getPopularVideosByHash"
            
        }
        
        func publicVideo() -> String
        {
            
   return localURL + "queryService/getVideosByHashTags"
            
        }
    }
    struct videoDataUpload {
        func url () -> String {
            return localURL + "commandService/videoFileUpload"
        }
    }
    
    struct getIcarouselFeatureURL {
        func url() -> String {
            return  localURL + "commandService/getFeaturedVideoList"
        }
    }
    
    struct treandingURL {
        func url () -> String {
            return localURL + "queryService/getAudioVideoListByLike"
        }
    }
    
    struct recentURL {
    func url () -> String {
            return localURL + "queryService/myVideosList"
    }
    }
    
    struct Setting
    {
        func getPrivateData() -> String
        {
            
            return  localURL + "queryService/getPrivateFollowCount"
            
        }
        func uploadProfileImage() -> String
        {
            
            return localURL + "commandService/profileImage"
        }
    }
    
    struct follow {
        
        func follower() -> String
        {
            return localURL + "commandService/followers"
        }
        
        func unFollower() -> String
        {
            return localURL + "commandService/unfollowers"
            
        }
        
    }
    
    struct audioVideoViewCount {
        func viewCount() -> String {
            return localURL + "commandService/updateAudioView"
        }
    }

    struct  contactData
    {
        func getXpressContact() -> String
        {
            return  localURL + "queryService/getIxpressMobileList"
           // return localURL + "queryService/getIxpressContactList"
            
        }
    }
    
    struct notificationData {
        func getNotificationData() -> String {
            return localURL + "queryService/getPrivateFollowList"
        }
    }

    struct audioVideoPlayURL {
        func getAudioVideoPlayUrl () -> String
        {
            return localURL  + "queryService/onclickplay"
        }
    }
    
    struct followUserDetail {
        func followUserDataDetailURL () -> String
        {
           return localURL  +  "queryService/followerscreen"
        }
    }
    
    struct getSettingPageDetails {
        func settingPageUserDetailURL () -> String
        {
          return localURL  +  "commandService/details"  
        }
    }
    
    struct getSettingPageModificationDetails {
        func settingPageModificationUserDetailURL () -> String
        {
            return localURL  +  "commandService/settings"
        }
    }
    
}
