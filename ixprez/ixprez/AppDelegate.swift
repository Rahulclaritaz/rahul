//
//  AppDelegate.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 27/04/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//
//Claritaz-Techlabs.ixprez

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
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


}

