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
    
    var isUserFollowing = Int ()
    
    let dashBoardCommonService = XPWebService()
    let followUpdateCountURL = URLDirectory.audioVideoViewCount()
    var getUploadData = MyUploadWebServices()
    
    var getUploadURL = URLDirectory.MyUpload()
    var followURL = URLDirectory.follow()
    
    
    var recordFollow = [[String : Any]]()
    
    var profileIconImage =  UIImageView ()
    var userPhoto = UIImage()
    
    var userName = String()
    
    var isPress : Bool!
    
    var dele : passFollow!
    
    @IBOutlet weak var followTableView: UITableView!

    var followersEmail = String()
    
    var followingUserId = String()
    
    var activityIndicator = UIActivityIndicatorView()
    
    // This will add the pull refresh in th etable view
    lazy var refershController : UIRefreshControl = {
        
        let refersh = UIRefreshControl()
        
        refersh.addTarget(self, action: #selector(getPulledRefreshedData), for: .valueChanged)
        
        return refersh
        
    }()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        followTableView.addSubview(refershController)
        self.title = userName
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        self.navigationController?.navigationBar.tintColor = UIColor.white
        

        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, spinColor: .white, bgColor: .clear, placeInTheCenterOf: followTableView)
        
//        followTableView.addScalableCover(with: userPhoto)
        getMyUploadPublicListData()
       
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool)
//    {
//        DispatchQueue.main.async { 
//            self.followTableView.reloadData()
//        }
//        
//    }
    
    func getPulledRefreshedData () {
        
        print("You Pulled the tableview")
        //        refershController.beginRefreshing()
         getMyUploadPublicListData()
        DispatchQueue.main.async
            {
                self.followTableView.reloadData()
        }
        self.refershController.endRefreshing()
        
        
    }
    
    @IBAction func backButton (_ sender : Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func  getMyUploadPublicListData()
    {
        
        
        let  dicData = [ "user_email" : followersEmail  , "index" : 0 , "limit" : 30] as [String : Any]
        
        
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "XPFollowsTableViewCell") as! XPFollowsTableViewCell
        
        
        let followData = self.recordFollow[indexPath.row]
        
        
        
        cell.lblTitle.text = followData["title"] as? String
        
        cell.lblLikeCount.text = String(format: "%d Like", followData["likeCount"] as! Int)
        
        cell.lblReactionCount.text = String(format: "%d Rect", followData["emotionCount"] as! Int)
        
        cell.imgProfileImage.layer.cornerRadius = 4.0
        cell.imgProfileImage.layer.masksToBounds = true
        let viewCount : Int = followData["view_count"] as! Int
        cell.lblViewCount.text = String(format: "%d Views", viewCount)
        
        
        var thumbPath = followData["thumbtokenizedUrl"] as? String
        
        
//        thumbPath?.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        
        cell.imgProfileImage.getImageFromUrl(thumbPath!)
        
        
        
        return cell
        
        
    }
}

extension XPFolllowsViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
        
        
    {
        
        return 150.0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "XPFollowHeaderTableViewCell") as! XPFollowHeaderTableViewCell
        cell.followerProfileBGImage.image = userPhoto
        cell.followerProfileBGImage.alpha = 0.3
        
//        cell.imgProfileIcon.setBackgroundImage(userPhoto, for: .normal)
        cell.followerProfileImage.image = userPhoto //profileIconImage.image
        
        cell.followerProfileImage.layer.cornerRadius = cell.followerProfileImage.frame.size.width/2
        
        cell.followerProfileImage.clipsToBounds = true
        
//        cell.followerProfileImage.contentMode = .scaleAspectFit
        
        cell.lblProfileName.text = userName
        
        cell.imgFollowBG.layer.cornerRadius = cell.imgFollowBG.frame.size.width/2
        
        cell.imgFollowBG.clipsToBounds = true
        
        if (isUserFollowing == 0)
        {
            cell.imgFollow.image = UIImage(named: "FollowHeartIcon")
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
        if (isUserFollowing == 0)
        {
            // orignator - to whom going to follow & follower - who is going to follow.
            let followDic = ["user_id":followingUserId]
            
            self.getUploadData.getDeleteMyUploadWebService(urlString: followURL.follower(), dicData: followDic as NSDictionary, callback: { (dic, err) in
                
                print(dic)
                if( dic["status"] as! String == "OK" )
                {
                   // self.dele.followCount(value: 1)
                    self.isUserFollowing = 1
                    DispatchQueue.main.async(execute: {
                        self.followTableView.reloadData()
                    })
                }
                
            })
            
        }
        else
        {
            
            // orignator - to whom going to follow & follower - who is going to follow.
            let followDic = ["user_id":followingUserId]
            
            self.getUploadData.getDeleteMyUploadWebService(urlString: followURL.unFollower(), dicData: followDic as NSDictionary, callback: { (dic, err) in
                
                print(dic)
                if( dic["status"] as! String == "OK" )
                {
                    //self.dele.followCount(value: 0)
                    self.isUserFollowing = 0
                    DispatchQueue.main.async(execute: {
                        self.followTableView.reloadData()
                    })
                    
                }
                
            })
            
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
        
        //        let cellIndexPath = sender.tag
        
        // This will send the parameter to the view count service and return the response
        var recordFollowData = self.recordFollow[indexPath.row]
        let fileType: String = recordFollowData["filemimeType"] as! String
        let followFileType = fileType.replacingOccurrences(of: "/mp4", with: "")
        var  fileTypeData =  String()
        if (followFileType == "video"){
            fileTypeData = followFileType
        } else {
            fileTypeData = "audio"
        }
        print(followFileType)
        let requestParameter = ["id" : recordFollowData["_id"],"video_type": fileTypeData] as [String : Any]
        
        dashBoardCommonService.updateNumberOfViewOfCount(urlString: followUpdateCountURL.viewCount(), dicData: requestParameter as NSDictionary) { (updateCountresponse, error
            ) in
            print(updateCountresponse)
            if (error == nil) {
                //                storyBoard.playView = labelPlayView + 1
            } else {
                //                storyBoard.playView = labelPlayView
            }
        }
        
        let urlPath = recordFollowData["tokenizedUrl"] as! String
        
        var finalURlPath = urlPath.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        storyBoard.playUrlString = finalURlPath
        storyBoard.nextID = recordFollowData["_id"] as! String
        let labelLikeCount: NSInteger = recordFollowData["likeCount"] as! NSInteger
        storyBoard.playLike = labelLikeCount
        let labelSmileyCount: NSInteger = recordFollowData["emotionCount"] as! NSInteger
        storyBoard.playSmiley = labelSmileyCount
        storyBoard.playTitle = recordFollowData["title"] as! String
        let labelPlayView: NSInteger = recordFollowData["view_count"] as! NSInteger
        storyBoard.playView = labelPlayView + 1
        
        print("the carousel video url path is \(storyBoard.playUrlString)")
        self.navigationController?.pushViewController(storyBoard, animated: true)
        
    }

    
}
