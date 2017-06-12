//
//  XPHumburgerMenuViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPHumburgerMenuViewController: UIViewController {

    @IBOutlet weak var humburgerMenuTableView : UITableView?
    @IBOutlet weak var humburgerMenuUserProfile : UIImageView?
    @IBOutlet weak var humburgerMenuUserName : UILabel?
    let dashBoardCommonService = XPWebService()
    let userPrifileURL = URLDirectory.UserProfile()
    var userEmail = String ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmail = "mathan6@gmail.com"
        humburgerMenuUserName?.text = "Mathan"
         self.getUserProfile()
        let imageLogo = UIImage (named: "DashboardTitleImage")
        let imageView = UIImageView(image : imageLogo)
        self.navigationItem.titleView = imageView
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        humburgerMenuUserProfile?.layer.masksToBounds = true
        humburgerMenuUserProfile?.layer.cornerRadius = (self.humburgerMenuUserProfile?.frame.size.width)!/2
        humburgerMenuUserProfile?.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
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
            cell.menuLabel?.text = "Help"
            return cell
        case 4:
            cell.menuLabel?.text = "About"
            return cell
            
        default:
            return cell
        }
        
    }
}

extension XPHumburgerMenuViewController : UITableViewDelegate {
    
}









