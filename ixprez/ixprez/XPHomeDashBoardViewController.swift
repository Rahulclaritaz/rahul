//
//  XPHomeDashBoardViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 08/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPHomeDashBoardViewController: UIViewController {

    var userEmail = String()
    let userProfile = XPWebService()
    let userPrifileURL = URLDirectory.UserProfile()
    let userReplacingURL = URLDirectory.BaseRequestResponseURl()
    @IBOutlet weak var userProfileImage = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iXprez"
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        userEmail = "mathan6@gmail.com" //UserDefaults.value(forKey: "emailAddress") as! String
        userProfileImage?.layer.borderWidth = 1.0
        userProfileImage?.layer.masksToBounds = false
        userProfileImage?.layer.borderColor = UIColor.white.cgColor
        userProfileImage?.layer.cornerRadius = (userProfileImage?.frame.size.height)!/2
        userProfileImage?.clipsToBounds = true
        getUserProfile()
        
        
     //   someBarButtonItem.image = UIImage(named:"myImage")?.withRenderingMode(.alwaysOriginal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserProfile() {

    let parameter = [ "email_id" : userEmail]
        
        userProfile.getUserProfileWebService(urlString: userPrifileURL.url(), dicData: parameter as NSDictionary, callback: {(userprofiledata , error) in
            let imageURL: String = userprofiledata.value(forKey: "profile_image") as! String
            print(imageURL)
            let newString = imageURL.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress", with: "http://183.82.33.232:3000", options: .literal, range: nil)
            print(newString)
            let url = NSURL(string : newString)
            let imageData = NSData(contentsOf: url as! URL)
            self.userProfileImage?.image = UIImage(data: imageData as! Data)
            
//            if let url = NSURL(string: "http://183.82.33.232:3000/uploads/profileImage/1487756666037s.jpg") {
//                if let imageData = NSData(contentsOf: url as URL) {
//                    let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
//                    let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
//                     self.userProfileImage?.image = UIImage(data: data as Data)
//                    
//                }        
//            }
        
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
