//
//  XPNotificationViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 08/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPNotificationViewController: UIViewController {
    var userEmail = String()
    var commomWebService = XPWebService()
    var commonWebUrl = URLDirectory.notificationData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notification"
        userEmail = UserDefaults.standard.string(forKey: "emailAddress")!
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white];
        self.getValueFromService()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getValueFromService() {
        let parameter : NSDictionary = ["user_email" :userEmail,"limit" : "30","index":"0","notificationCount":"1"]
        commomWebService.getNotificationData(urlString: commonWebUrl.getNotificationData(), dicData: parameter, callBack: {
            (myData,erro) in
            
            print("check private web service data",myData)
            
//            self.recordPrivateData = dicc as [[String : Any]]
            
            DispatchQueue.main.async{
                
//                self.refershController.beginRefreshing()
//                
//                self.privateTableView.reloadData()
//                
//                self.refershController.endRefreshing()
                
            }
            
        })
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
