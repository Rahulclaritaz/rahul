//
//  XPFolllowsViewController.swift
//  ixprez
//
//  Created by Quad on 6/22/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
protocol passFollow
{
    func followCount(value : Int)
    
    
}


class XPFolllowsViewController: UIViewController
{
    
    var setFollowIcon : Bool!
    
    
    var getUploadData = MyUploadWebServices()
    
    var getUploadURL = URLDirectory.MyUpload()
    var followURL = URLDirectory.follow()
    
    
       var recordFollow = [[String : Any]]()
   
    
    var userPhoto = UIImage()
    
    var userName = String()
    
    var isPress : Bool!
    
    var dele : passFollow!
    
    @IBOutlet weak var followTableView: UITableView!

    
    
   
    var myEmail = String()
    
    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        setFollowIcon = false
        
        self.title = userName
        
        print("email id",myEmail)

        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, spinColor: .white, bgColor: .clear, placeInTheCenterOf: followTableView)
        
        getMyUploadPublicListData()
        
        followTableView.addScalableCover(with: userPhoto)
   
       
    }

 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func  getMyUploadPublicListData()
    {
        
        
        let  dicData = [ "user_email" : myEmail  , "index" : 0 , "limit" : 30] as [String : Any]
        
        
        
        getUploadData.getPublicPrivateMyUploadWebService(urlString: getUploadURL.publicMyUpload(), dicData: dicData as NSDictionary, callback:{(dicc, err) in
            
            
            
            if err == nil
            {
                print("matha  check Data",dicc)
                
                self.recordFollow = dicc
                
                DispatchQueue.main.async
                    {
                        self.activityIndicator.stopAnimating()
                        
                        self.followTableView.reloadData()
                        
                }
                
            }
                
            else
            {
                DispatchQueue.main.async
                    {
                        
                        self.activityIndicator.startAnimating()
                        
                }
                
            }
            
        })
        
    }

    

}




extension XPFolllowsViewController : UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return recordFollow.count
        
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! XPFollowsTableViewCell
        
        
        let followData = self.recordFollow[indexPath.row]
        
          
        
        cell.lblTitle.text = followData["title"] as? String
     
        cell.lblLikeCount.text = String(format: "%d", followData["likeCount"] as! Int)
   
        cell.lblReactionCount.text = String(format: "%d", followData["emotionCount"] as! Int)
        
        
        cell.lblViewCount.text = String(format: "%d", followData["viewed"] as! Int)
      
        
        var thumbPath = followData["thumbnailPath"] as? String
        
        
        thumbPath?.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        
        cell.imgProfileImage.getImageFromUrl(thumbPath!)
        
        
        
        return cell
        
        
    }
}

extension XPFolllowsViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    

    {
        
        return 80.0
        
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
     {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "XPFollowHeaderTableViewCell") as! XPFollowHeaderTableViewCell
        
        cell.imgProfileIcon.setBackgroundImage(userPhoto, for: .normal)
        
        cell.imgProfileIcon.layer.cornerRadius = cell.imgProfileIcon.frame.size.width/2
        
        cell.imgProfileIcon.clipsToBounds = true
        
        cell.imgProfileIcon.contentMode = .scaleAspectFit
        
        cell.lblProfileName.text = userName
        
        if setFollowIcon == false
        {
            
            cell.imgFollow.image = UIImage(named: "FollowsIcon")
            
           
            
        }
            
        else
        {
            
            cell.imgFollow.image = UIImage(named: "DashboardUnFollowIcon")
            
            
        }

       
        
        
        cell.btnFollow.addTarget(self, action: #selector(followAction(Sender:)), for: .touchUpInside)
        
        return cell
        }
    
    
   
func followAction(Sender:UIButton)
{
    if setFollowIcon == false
    {
        
        setFollowIcon = true
        
        
        let followDic = ["orignator":"venkat.r@quadrupleindia.com","followers":myEmail]
        
        self.getUploadData.getDeleteMyUploadWebService(urlString: followURL.follower(), dicData: followDic as NSDictionary, callback: { (dic, err) in
            
            print(dic)
            if( dic["status"] as! String == "OK" )
            {
                self.dele.followCount(value: 1)
            }
            
        })
        
        
   
    }
    else
    {
        setFollowIcon = false
        
        
        let followDic = ["orignator":"venkat.r@quadrupleindia.com","followers":myEmail]
        
        self.getUploadData.getDeleteMyUploadWebService(urlString: followURL.unFollower(), dicData: followDic as NSDictionary, callback: { (dic, err) in
            
            print(dic)
            if( dic["status"] as! String == "OK" )
            {
            self.dele.followCount(value: 0)
                
            }
            
        })

        
    }
    
    DispatchQueue.main.async
    {
        
        self.followTableView.reloadData()
    }
    
  /*
    let mmm = UIImage(named: "FollowsIcon")
    
    if setFollowIcon == true
    {
    
    Sender.setBackgroundImage(mmm, for: .normal)
        
        
        
        setFollowIcon = false
    }

    else
    {
    
    Sender.setBackgroundImage(UIImage(named: "DashboardUnFollowIcon") , for: .normal)
        
        setFollowIcon = true
        
      // myCell.imgFollow.image = UIImage(named: "DashboardUnFollowIcon")
    }
 */
    
    
}
    
    
func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        
        
           }
    
    
}
