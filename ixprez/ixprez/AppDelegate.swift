//
//  AppDelegate.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 27/04/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//
//Claritaz-Techlabs.ixprez

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window     : UIWindow?
    var deviceUDID : String!
    var deviceModel: String!
    var deviceName : String!
    var deviceOS : String!
    var systemName : String!
    var checkEmail = UserDefaults.standard
    var isAppFirstTime = Bool ()
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  
        let pageControl = UIPageControl.appearance()
       pageControl.pageIndicatorTintColor = .getLightBlueColor()
       pageControl.currentPageIndicatorTintColor = .getOrangeColor()
       
        deviceUDID = (UIDevice.current.identifierForVendor?.uuidString)!
        deviceModel = UIDevice.current.model
        print(deviceModel)
        deviceName = UIDevice.current.name
        print(deviceName)
        deviceOS = UIDevice.current.systemVersion
        print(deviceOS)
        systemName = UIDevice.current.systemName
        print(systemName)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            //FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        
        // Here will check app is going to launch is first time.
        if (checkEmail.value(forKey: "emailAddress") == nil) {
            isAppFirstTime = true
            let regPage = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
            
            self.window?.rootViewController = regPage
        } else {
            let dashBoard = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            
            self.window?.rootViewController = dashBoard
        }
        
        
        
              return true
    }
    func changeInitialViewController()
    {
        
        let dashBoard = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "WelcomePageViewController") as! WelcomePageViewController
        
        self.window?.rootViewController = dashBoard
        
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Registration succeeded! Token: ", token)
        let FCMtoken = Messaging.messaging().fcmToken
        print("FCM token: \(FCMtoken ?? "")")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registration failed!")
    }
    

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Firebase notification received
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(notification.request.content.userInfo)")
        
        let dict = notification.request.content.userInfo["aps"] as! NSDictionary
        let d : [String : Any] = dict["alert"] as! [String : Any]
        let body : String = d["body"] as! String
        let title : String = d["title"] as! String
        print("Title:\(title) + body:\(body)")
        self.showAlertAppDelegate(title: title,message:body,buttonTitle:"ok",window:self.window!)
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("Handle push from background or closed\(response.notification.request.content.userInfo)")
    }
    
    func showAlertAppDelegate(title: String,message : String,buttonTitle: String,window: UIWindow){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        window.rootViewController?.present(alert, animated: false, completion: nil)
    }
    // Firebase ended here


}

