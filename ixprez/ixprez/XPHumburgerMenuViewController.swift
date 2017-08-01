//
//  XPHumburgerMenuViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPHumburgerMenuViewController: UIViewController {
    var customActivityView : UIActivityViewController?
    var shareTextField = UITextField ()
    @IBOutlet weak var humburgerMenuTableView : UITableView?
    @IBOutlet weak var humburgerMenuUserProfile : UIImageView?
    @IBOutlet weak var humburgerMenuUserName : UILabel?
    let dashBoardCommonService = XPWebService()
    let userPrifileURL = URLDirectory.UserProfile()
    var userEmail = String ()
    var imageGesture =  UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageGesture = UITapGestureRecognizer(target: self, action: #selector(gotoSettingView(gesture:)))
        
        userEmail = UserDefaults.standard.value(forKey: "emailAddress") as! String
        humburgerMenuUserName?.text = UserDefaults.standard.value(forKey: "userName") as! String
         self.getUserProfile()
        let imageLogo = UIImage (named: "DashboardTitleImage")
        let imageView = UIImageView(image : imageLogo)
        self.navigationItem.titleView = imageView
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.leftBarButtonItem?.badgeValue = "757"
        
        humburgerMenuUserProfile?.layer.masksToBounds = true
        humburgerMenuUserProfile?.layer.cornerRadius = (self.humburgerMenuUserProfile?.frame.size.width)!/2
        humburgerMenuUserProfile?.clipsToBounds = true
        
        humburgerMenuUserProfile?.isUserInteractionEnabled = true
        
        humburgerMenuUserProfile?.addGestureRecognizer(imageGesture)
        

        // Do any additional setup after loading the view.
    }
 func gotoSettingView(gesture:UIGestureRecognizer)
   {
    let settingView = storyboard?.instantiateViewController(withIdentifier: "XPSettingsViewController") as! XPSettingsViewController
    
    settingView.isFromMenu = true
    
    let navigation = UINavigationController.init(rootViewController: settingView)
    
    
    
    self.navigationController?.present(navigation, animated: true, completion: nil)
    
    
    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    // This method will logout the application
    @IBAction func signOutButton (sender : Any) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        exit(0)
        
//        UserDefaults.standard.removeObject(forKey: "emailAddress")
//        UserDefaults.standard.synchronize()
    }
    // This method will navigate to  the setting page
    @IBAction func settingButton (sender : Any) {
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPSettingsViewController") as! XPSettingsViewController
        storyboard.isFromMenu = true
        let navigation = UINavigationController.init(rootViewController: storyboard)
        self.navigationController?.present(navigation, animated: true, completion: nil)
    }
    
    
    func getUserProfile() {
        
        let parameter = [ "email_id" : userEmail]
        
        dashBoardCommonService.getUserProfileWebService(urlString: userPrifileURL.url(), dicData: parameter as NSDictionary, callback: {(userprofiledata , error) in
            let imageURL: String = userprofiledata.value(forKey: "profile_image") as! String
            print(imageURL)
            
            var urlString = imageURL.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress", with: "http://103.235.104.118:3000")
            
            let url = NSURL(string: urlString)
            
            let session = URLSession.shared
            
            let taskData = session.dataTask(with: url! as URL, completionHandler: {(data,response,error) -> Void  in
                
                if (data != nil)
                {
                    
                    DispatchQueue.main.async {
                        
                        self.humburgerMenuUserProfile?.image = UIImage(data: data!)
                        
                    }
                }
            })
            
            
            taskData.resume()
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

// MARK: UITableview datasource Method
extension XPHumburgerMenuViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cellIdentifier = "XPHumburgerMenuTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPHumburgerMenuTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.menuLabel?.text = "My Uploads"
            return cell
        case 1:
            cell.menuLabel?.text = "Contacts"
            return cell
        case 2:
            cell.menuLabel?.text = "Private Xpressions"
            return cell
        case 3:
            cell.menuLabel?.text = "Share ixprez"
            return cell
        case 4:
            cell.menuLabel?.text = "About"
            return cell
            
        default:
            return cell
        }
        
    }
}
// MARK: UITableview delegate Method
extension XPHumburgerMenuViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.row) {
        case 0:
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadViewController") as! XPMyUploadViewController
            storyboard.isFromMenu = true
            let navigation = UINavigationController.init(rootViewController: storyboard)
            self.navigationController?.present(navigation, animated: true, completion: nil)
                
//            revealViewController().rightViewRevealWidth = 375
//            self.present(storyboard, animated: true, completion: nil)
//            self.navigationController?.pushViewController(storyboard, animated: true)
            return
        case 1:
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPContactViewController") as! XPContactViewController
            storyboard.isFromMenu = true
            let navigation = UINavigationController.init(rootViewController: storyboard)
            self.navigationController?.present(navigation, animated: true, completion: nil)
        case 2:
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "IXPrivateViewController") as! IXPrivateViewController
            storyboard.isFromMenu = true
            let navigation = UINavigationController.init(rootViewController: storyboard)
            self.navigationController?.present(navigation, animated: true, completion: nil)
//            self.navigationController?.pushViewController(storyboard, animated: true)
        case 3:
           // This will open the default activity view 
            customActivityView = UIActivityViewController(activityItems: [shareTextField.text as! NSString], applicationActivities: nil)
            present(customActivityView!, animated: true, completion: nil)
//            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPShareXprezViewController") as! XPShareXprezViewController
            
//            let navigation = UINavigationController.init(rootViewController: storyboard)
//            self.navigationController?.present(navigation, animated: true, completion: nil)
 
        case 4:
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPAboutViewController") as! XPAboutViewController
            storyboard.isFromMenu = true
            let navigation = UINavigationController.init(rootViewController: storyboard)
            self.navigationController?.present(navigation, animated: true, completion: nil)
//            self.navigationController?.pushViewController(storyboard, animated: true)
        default:
            let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadViewController") as! XPMyUploadViewController
            self.navigationController?.pushViewController(storyboard, animated: true)
        }
    }
 
}









