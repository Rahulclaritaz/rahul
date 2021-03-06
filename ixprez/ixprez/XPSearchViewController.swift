
//  XPSearchViewController.swift
//  ixprez

//  Created by Quad on 5/29/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.

import UIKit

class XPSearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,passFollow
    
{
    
   @IBOutlet weak var searchPublic: UISearchBar!
    
   @IBOutlet weak var publicTableView: UITableView!
    
    var getSearchURL = URLDirectory.Search()
    
    var getReloadData = URLDirectory.recentURL()
    
    var recordPopularVideo = [[String:Any]]()
    
    var recordPublicVideo = [[String:Any]]()
    
    var recordisFiltered = [[String:Any]]()
    
    var getWebService = PrivateWebService()

    var actInd  = UIActivityIndicatorView()
    
    @IBOutlet var searchBar : UISearchBar!
    
    let dashBoardCommonService = XPWebService()
    
    let followUpdateCountURL = URLDirectory.audioVideoViewCount()
    
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    
     var isFiltered : Bool!
    
     var isFlag : Bool!
    
    var lastRecord : Bool!
    
     let mylabel = UILabel()
    
    var Index = 0
    
    var userEmail : String!
    var nsuerDefault = UserDefaults.standard
    
    //let imageView = UIImageView()
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
     var imageView = UIImageView()
    
    var mySearchText  = String()
    
    var isFollowICon : Bool!
    
    var mySearchData : String!
    
    
    override func awakeFromNib()
    {
    
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        getPopularVideo()
        
        publicTableView.backgroundView = imageView
        
        publicTableView.separatorColor = UIColor.clear
    
        isFiltered = false
        self.publicTableView.reloadData()
        self.searchCollectionView.reloadData()

    }
    
    func followCount(value : Int)
     
    {
        
        if value == 1
        {
            
            isFollowICon = true
            
            
        }
        else
        {
            isFollowICon = false

        }
        
        
    }
    //let dicData = ["user_email":"mathan6@gmail.com","emotion":"like","index":Index,"limit":10,"language":"English (India)","country":"IN"] as [String : Any]
    
    // let requestParameter = ["user_email": UserDefaults.standard.value(forKey: "emailAddress"),"emotion":"like","index":"0","limit":"30","language":"English","country":"India"]
    
    //recentURL
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
  
        print(isFollowICon)
     
        setBackGroundView()
   
        userEmail = nsuerDefault.string(forKey: "emailAddress")
       
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
      
            
        }
        else
        {
            
            print("NO Internet Connection")
            
        let alertData = UIAlertController(title: "No Internet Connection ", message: "Make sure Your device is connected to the internet", preferredStyle: .alert)
            
        alertData.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
       self.present(alertData, animated: true, completion: nil)
            
            
        }
        publicTableView.delegate = self
        publicTableView.dataSource = self
 
        actInd = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, spinColor: .white, bgColor: .clear, placeInTheCenterOf: self.searchCollectionView)
     
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target:nil, action:nil)
        
    
         isFlag     = false
        
         lastRecord = false
        
   
    }
    
    
    
    @IBAction func BackButtonAction (sender : Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func setBackGroundView()
    {
        self.imageView.frame = CGRect(x: self.publicTableView.frame.origin.x-160, y: self.publicTableView.frame.origin.y, width: self.publicTableView.frame.size.width, height: self.publicTableView.frame.size.height - 160)
        
        self.imageView.image = UIImage(named: "WelcomeHeartImage")
        
        self.imageView.alpha = 0.1
        
        
        self.imageView.contentMode = .scaleAspectFit
     
        
    }
 
   /*
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
           self.publicTableView.endEditing(true)
    }
   */
    
    // This method will call when we search for a video
    func getSearchPublicVideo(myString : String)
    {
        
      print("check data mathan", myString)
        
    Index += 1
        
        let dicData = ["tags":myString,"index": Index - 1 ,"limit": 30,"sort":"like","user_email": userEmail] as [String : Any]
        
        getWebService.getPrivateDataWebService(urlString: getSearchURL.publicVideo(), dicData: dicData as NSDictionary, callback:  { (dic,responseCode, err ) in
      
            print("The search data is \(responseCode)")
            let responseReturnCode = responseCode.value(forKey: "code") as! String
            
            if (responseReturnCode != "200") {
                let alert = UIAlertController(title: nil, message:  "", preferredStyle: .actionSheet)
                
                let attributedString1 = NSAttributedString(string: "Nothing Found With the name \(myString), Why don't you Xpress one with that name yourself!", attributes: [
                    NSFontAttributeName : UIFont.xprezMediumFontOfsize(size: 15)  , //your font here
                    NSForegroundColorAttributeName : UIColor.white
                    ])
                
                alert.setValue(attributedString1, forKey: "attributedMessage")
                
                let subView1 = alert.view.subviews.first! as UIView
                let subView2 = subView1.subviews.first! as UIView
                let view = subView2.subviews.first! as UIView
                
                
                view.backgroundColor = UIColor(red: 255-255, green: 255-255, blue: 255-255, alpha: 0.8)
                
                alert.view.clipsToBounds = true
                
                DispatchQueue.main.async
                    {
                        
                        alert.show()
                }
            } else {
                let jsonSearchScrollData : Int = dic["last"] as! Int
                let jsonSearchArrayValue : NSArray = dic["Records"] as! NSArray
                
                let myData = jsonSearchArrayValue as! [[ String : Any]]
                print("The search data in key value formet is \(myData)")
                //            print("sssss",dataValue["code"] as! String)
                
                
                
                
                //        if (dataValue["code"] as! String) != "202"
                //        {
                
                self.isFiltered = true
                
                self.recordPublicVideo.removeAll()
                
                
                print("ffffffff",dic);
                
                if (jsonSearchScrollData == 0)
                {
                    
                    for dicData in myData
                    {
                        self.recordPublicVideo.append(dicData)
                        
                    }
                    
                    self.lastRecord = false
                    
                }
                    
                else
                {
                    for dicData in myData
                    {
                        self.recordPublicVideo.append(dicData)
                        
                    }
                    
                    self.lastRecord = true
                    print("last record")
                    
                }
            }
            
           
            
            
//            }
            /* else {
            self.isFiltered = false
            
            print("No record")
            
             let alert = UIAlertController(title: "", message:  "", preferredStyle: .actionSheet )
         
            let attributedString = NSAttributedString(string: "iXprez Nothing found with the name", attributes: [
                NSFontAttributeName : UIFont.xprezBoldFontOfSize(size: 15)  , //your font here
                NSForegroundColorAttributeName : UIColor.white
                ])
            
            let attributedString1 = NSAttributedString(string: myString, attributes: [
                NSFontAttributeName : UIFont.xprezMediumFontOfsize(size: 15)  , //your font here
                NSForegroundColorAttributeName : UIColor.white
                ])
            
            
            let subview1 = alert.view.subviews.first! as UIView
            let subview2 = subview1.subviews.first! as UIView
            let view = subview2.subviews.first! as UIView
            
            subview2.backgroundColor = UIColor.clear
            
            subview1.backgroundColor = UIColor.clear
            
            view.backgroundColor = UIColor(red:255-255, green:255-255, blue:255-255, alpha:0.5)
            
            view.layer.cornerRadius = 20.0

            
                         
           // alert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    
            alert.setValue(attributedString, forKey: "attributedTitle")
         
            alert.setValue(attributedString1, forKey: "attributedMessage")
            
            UIView.animate(withDuration: 15.0, delay: 0, options: .curveEaseIn, animations: {
                
                DispatchQueue.main.async {
                    
                    alert.show()
                   
                }
                
            }, completion: nil)
        
            
            } */
   
            DispatchQueue.main.async
                {
                    
                    self.publicTableView.reloadData()
                    
            }
        
        })
            
        
        
        
    }
    
    // This will return the video list that is search by the user
    func   getPopularVideo()
    {
        let dicData = ["user_email": userEmail]
        
        getWebService.getPrivateDataWebService(urlString: getSearchURL.searchPopularVideo() , dicData: dicData as NSDictionary, callback: {(dicc,responseCode, err) in
          
            if ( err == nil)
            {
                let jsonPopularScrollData : Int = dicc["last"] as! Int
                let jsonPopularArrayValue : NSArray = dicc["Records"] as! NSArray
                
            self.recordPopularVideo = jsonPopularArrayValue as! [[String : Any]]
                
                print ( "Popular Video", self.recordPopularVideo)
                
                
                DispatchQueue.main.async
                    {
                        self.actInd.stopAnimating()
                        self.searchCollectionView.reloadData()
               
                }
             
            }
            else
            {
                DispatchQueue.main.async
                {
                    self.actInd.startAnimating()
                }
            }
            
        })
     
    }
  
 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        

        if (searchBar.text?.characters.count)! <= 2
        {
            isFiltered = false
            
            let alert = UIAlertController(title: nil, message: "please enter minimum three characters", preferredStyle: .alert)
            
            
            let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action1)
            
            
            
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        else
        {
            recordPublicVideo.removeAll()
        
            isFiltered = false
            
            Index = 0
            
            mySearchData = searchBar.text?.lowercased()
            
         
           
            self.getSearchPublicVideo(myString: self.mySearchData)
            
            DispatchQueue.main.async {
                
                self.publicTableView.reloadData()
                
            }

                  }
        
        
        self.view.layoutIfNeeded()
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.navigationController?.navigationBar.isHidden = false
            
            self.collectionViewWidth.constant = 160
            
            self.view.layoutIfNeeded()
        }, completion: nil)
        
       
        searchBar.resignFirstResponder()
        
        
        searchBar.showsCancelButton = false
    
        
    
        
    }
 
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        
        
        isFiltered = false
        
         searchBar.resignFirstResponder()
        
        return true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if isFiltered == true
        {
            
            if lastRecord == false
            {
              return recordPublicVideo.count + 1
            }
            else
            {
              return recordPublicVideo.count
                
            }
            
            
        }
        else
        {
            
             return recordPublicVideo.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "publiccell") as! XPPublicDataTableViewCell
        
        cell.imgAudioVideo.layer.borderWidth = 0.5
        
        cell.imgAudioVideo.layer.borderColor = UIColor.lightGray.cgColor
        
        cell.imgAudioVideo.clipsToBounds = true
        
        
      if isFiltered == false
      {
        
      
          cell.isHidden = true
        
        
        publicTableView.backgroundView = imageView
        
        
       // publicTableView.backgroundView?.isHidden = false
        
        
        return cell
       
        
        }
        
        else
      {
        
        cell.isHidden = false
        
       // publicTableView.backgroundView?.isHidden = true
        
       if indexPath.row <= recordPublicVideo.count
       {
        
        var publicData = recordPublicVideo[indexPath.row]
        
        
        cell.lblTitle.text? = (publicData["title"] as? String)!.capitalized
           
            
        cell.lblReactionCount.text = String(format: "%d  Likes", publicData["emotionCount"] as! Int)
        
        
        cell.lblLikeCount.text = String(format: "%d  Likes", publicData["likeCount"] as! Int)
        
        let viewCount: Int = publicData["view_count"] as! Int
        
        cell.lblViewCount.text = String(format: "%d  Views", viewCount)

//        cell.btnPlayPublicVideo.tag = indexPath.row
//        
//        cell.btnPlayPublicVideo.addTarget(self, action: #selector(playPublicVideo(sender:)), for: .touchUpInside)
        
         
            cell.btnPress.tag = indexPath.row
            
        cell.btnPress.addTarget(self, action: #selector(callFollowProfile(sender :)), for: .touchUpInside)
        
        //isuerfollowing
        
        print("mathan isuserfollowing",(publicData["isuerfollowing"] as! Int))
        
        
        if ( (publicData["isuerfollowing"] as! Int) == 0)
        {
        
        cell.imgFollowIcon.image = UIImage(named: "DashboardFollowIcon")
        }
        else
        {//DashboardUnFollowIcon
            
            cell.imgFollowIcon.image = UIImage(named: "DashboardUnFollowIcon")
        }
        
        if  (publicData["filemimeType"] as! String) == "video/mp4"
        {
            cell.imgVA.image = UIImage(named: "SearchVideoOn")
            
            isFlag = true
            
        }
        else
        {
            
            cell.imgVA.image = UIImage(named: "privateAudio")
            
        }
        
        cell.imgAudioVideo.image = nil
      
        if ( publicData["thumbnailPath"] as? String != nil )
        {
         
            
            var thumbString = publicData["thumbnailPath"] as! String
            
            
            thumbString.replace("/root/cpanel3-skel/public_html/Xpress/",with: "http://103.235.104.118:3000/")
            
            
            
            print("mathan check thumString",thumbString)
            
            cell.imgAudioVideo.getImageFromUrl(thumbString)
            

        }
            
        else
        {
            
            
            cell.imgAudioVideo.backgroundColor = UIColor.getPrivateCellColor()
            
            
        }
        
                 print("mathan ma",indexPath.row)
        
        return cell

        
        }
    
       else
        {
            
           print("mathan what happen")
           self.getSearchPublicVideo(myString: self.mySearchData)
          
        
        }
        
        }
       
        return cell
        
    }
    
    func callFollowProfile(sender : UIButton)
    {
        print("mathan index",sender.tag)
        
        let indexValue = IndexPath(row: sender.tag, section: 0)
        
        //let myCell = publicTableView.cellForRow(at: indexValue)
        
        let followData = recordPublicVideo[indexValue.row]
        
        
        print("mathan followData", followData )
        
        //from_user
        
        //thumbnailPath
        
        
        let followEmail = followData["from_email"] as! String
        
        let userName1 = followData["from_user"] as! String
        
        var orginalString = followData["thumbnailPath"] as! String
        
        
        orginalString.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        
        let myImage = UIImageView()
        
        
        myImage.getImageFromUrl(orginalString)
        
        
      
        
        
        let followView = self.storyboard?.instantiateViewController(withIdentifier: "XPFolllowsViewController") as! XPFolllowsViewController
        
        followView.followersEmail = followEmail
        followView.isUserFollowing = (followData["isuerfollowing"] as! Int)
        
         followView.userPhoto = myImage.image!
        
        followView.userName = userName1
        
        followView.dele = self
        
        
        self.navigationController?.pushViewController(followView, animated: true)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if isFiltered == false
        {
        
            let publicData = recordPublicVideo[indexPath.row]
            
            // This will send the parameter to the view count service and return the response
            
            let fileType: String = publicData["filemimeType"] as! String
            
            let followFileType = fileType.replacingOccurrences(of: "/mp4", with: "")
            
            var  fileTypeData =  String()
            
            if (followFileType == "video")
            {
                fileTypeData = followFileType
            } else
            {
                fileTypeData = "audio"
            }
            print(followFileType)
            let requestParameter = ["id" : publicData["_id"] as! String,"video_type": fileTypeData] as [String : Any]
            
            dashBoardCommonService.updateNumberOfViewOfCount(urlString: followUpdateCountURL.viewCount(), dicData: requestParameter as NSDictionary) { (updateCountresponse, error
                ) in
                print(updateCountresponse)
                if (error == nil) {
                    //                storyBoard.playView = labelPlayView + 1
                } else {
                    //                storyBoard.playView = labelPlayView
                }
            }
            
            let playTitle = publicData["title"] as! String
            
            var playVideoPath = publicData["fileuploadPath"] as! String
            
            playVideoPath.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
            
            let playFilemimeType = publicData["filemimeType"] as! String
            
            let playID = publicData["_id"] as! String
            
            let playLikeCount = publicData["likeCount"] as! Int
            
            let playViewCount = publicData["view_count"] as! Int
            
            let playSmiley = publicData["emotionCount"] as! Int
            
            let checkUserLike = publicData["isUserLiked"] as! Int
        
        
        print("mathan check search",checkUserLike)
        
            
            let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
            
            playViewController.playTitle = playTitle
            
            playViewController.playUrlString = playVideoPath
            
            playViewController.playLike = playLikeCount
            
            playViewController.playView = playViewCount + 1
            
            playViewController.playSmiley = playSmiley
            
            playViewController.nextFileType = playFilemimeType
            
            playViewController.nextID = playID
            
            playViewController.checkLike = checkUserLike
            
            self.navigationController?.pushViewController(playViewController, animated: true)
            
            
        }
        else
        {
//            let indexPathValue = IndexPath(row: sender.tag, section: 0)
            
            
            let publicData = recordPublicVideo[indexPath.row ]
            
            // This will send the parameter to the view count service and return the response
            let fileType: String = publicData["filemimeType"] as! String
            let followFileType = fileType.replacingOccurrences(of: "/mp4", with: "")
            var  fileTypeData =  String()
            if (followFileType == "video"){
                fileTypeData = followFileType
            } else {
                fileTypeData = "audio"
            }
            print(followFileType)
            let requestParameter = ["id" : publicData["_id"] as! String,"video_type": fileTypeData] as [String : Any]
            
            dashBoardCommonService.updateNumberOfViewOfCount(urlString: followUpdateCountURL.viewCount(), dicData: requestParameter as NSDictionary) { (updateCountresponse, error
                ) in
                print(updateCountresponse)
                if (error == nil) {
                    //                storyBoard.playView = labelPlayView + 1
                } else {
                    //                storyBoard.playView = labelPlayView
                }
            }
            
            
            let playTitle = publicData["title"] as! String
            
            var playVideoPath = publicData["fileuploadPath"] as! String
            
            playVideoPath.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
            
            let playFilemimeType = publicData["filemimeType"] as! String
            
            let playID = publicData["_id"] as! String
            
            
            print("playID",playID)
            
            
            let playLikeCount = publicData["likeCount"] as! Int
            
            let playViewCount = publicData["view_count"] as! Int
            
            let playSmiley = publicData["emotionCount"] as! Int
            
             let checkUserLike = publicData["isUserLiked"] as! Int
            
            let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
            
         
            

            
            playViewController.playTitle = playTitle
            
            playViewController.playUrlString = playVideoPath
            
            playViewController.playLike = playLikeCount
            
            playViewController.playView = playViewCount + 1
            
            playViewController.playSmiley = playSmiley
            
            playViewController.nextFileType = playFilemimeType
            
            playViewController.nextID = playID
            
            playViewController.checkLike = checkUserLike
            
            
            self.navigationController?.pushViewController(playViewController, animated: true)
        }
    }
    
    
/*  func playPublicVideo(sender: UIButton)
    {
        if isFiltered == false
        {
            
        
      let indexPathValue = IndexPath(row: sender.tag, section: 0)
        
       // let cell = self.publicTableView.cellForRow(at: indexPathValue) as! XPPublicDataTableViewCell
    
    
        let publicData = recordPublicVideo[indexPathValue.row]
            
            // This will send the parameter to the view count service and return the response
            let fileType: String = publicData["filemimeType"] as! String
            let followFileType = fileType.replacingOccurrences(of: "/mp4", with: "")
            print(followFileType)
            let requestParameter = ["id" : publicData["_id"],"video_type": followFileType] as [String : Any]
            
            dashBoardCommonService.updateNumberOfViewOfCount(urlString: followUpdateCountURL.viewCount(), dicData: requestParameter as NSDictionary) { (updateCountresponse, error
                ) in
                print(updateCountresponse)
                if (error == nil) {
                    //                storyBoard.playView = labelPlayView + 1
                } else {
                    //                storyBoard.playView = labelPlayView
                }
            }
        
        let playTitle = publicData["title"] as! String
        
        var playVideoPath = publicData["fileuploadPath"] as! String
        
        playVideoPath.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        let playFilemimeType = publicData["filemimeType"] as! String
        
        let playID = publicData["_id"] as! String
        
        let playLikeCount = publicData["likeCount"] as! Int
        
        let playViewCount = publicData["viewed"] as! Int
        
        let playSmiley = publicData["emotionCount"] as! Int
            
         let checkUserLike = publicData["isUserLiked"] as! Int
    
        let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
    
        playViewController.playTitle = playTitle
        
        playViewController.playUrlString = playVideoPath
        
        playViewController.playLike = playLikeCount
        
        playViewController.playView = playViewCount + 1
        
        playViewController.playSmiley = playSmiley
        
        playViewController.nextFileType = playFilemimeType
        
        playViewController.nextID = playID
            
        playViewController.checkLike = checkUserLike
        
        self.navigationController?.pushViewController(playViewController, animated: true)
            
   
        }
        else
        {
            let indexPathValue = IndexPath(row: sender.tag, section: 0)

            
            let publicData = recordPublicVideo[indexPathValue.row ]
            
            // This will send the parameter to the view count service and return the response
            let fileType: String = publicData["filemimeType"] as! String
            let followFileType = fileType.replacingOccurrences(of: "/mp4", with: "")
            print(followFileType)
            let requestParameter = ["id" : publicData["_id"],"video_type": followFileType] as [String : Any]
            
            dashBoardCommonService.updateNumberOfViewOfCount(urlString: followUpdateCountURL.viewCount(), dicData: requestParameter as NSDictionary) { (updateCountresponse, error
                ) in
                print(updateCountresponse)
                if (error == nil) {
                    //                storyBoard.playView = labelPlayView + 1
                } else {
                    //                storyBoard.playView = labelPlayView
                }
            }
            
            
            let playTitle = publicData["title"] as! String
            
            var playVideoPath = publicData["fileuploadPath"] as! String
            
           playVideoPath.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
            
            let playFilemimeType = publicData["filemimeType"] as! String
            
            let playID = publicData["_id"] as! String
            
            let playLikeCount = publicData["likeCount"] as! Int
            
            let playViewCount = Int(publicData["view_count"] as! String)
            
            let playSmiley = publicData["emotionCount"] as! Int
            
            let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
            
            playViewController.playTitle = playTitle
            
            playViewController.playUrlString = playVideoPath
            
            playViewController.playLike = playLikeCount
            
            playViewController.playView = playViewCount! + 1
            
            playViewController.playSmiley = playSmiley
            
            playViewController.nextFileType = playFilemimeType
            
            playViewController.nextID = playID
            
            self.navigationController?.pushViewController(playViewController, animated: true)
        }
        
    
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell") as! XPSearchTableViewCell
        
 
       self.mySearchData =  cell.publicSearch.text
        
        cell.publicSearch.delegate = self
        
        return cell.contentView
   
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat

    {
        
        return 50
        
    }
 
 */

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
    return self.recordPopularVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
     {
     
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell", for: indexPath) as! XPSearchPopularCollectionViewCell
        
      cell.layer.cornerRadius = 5.0
        
      cell.layer.borderWidth = 1.0
        
      cell.layer.borderColor = UIColor.clear.cgColor
        
      let popularData = recordPopularVideo[indexPath.item]
        
//      cell.lblPopularTitle.text = popularData["title"] as? String
//        
//      cell.lblPopularLike.text =  String(format: "%d Likes", arguments: [popularData["likeCount"] as! Int])
//        
//      cell.lblPopularEmotion.text = String(format: "%d Reactions", arguments: [popularData["emotionCount"] as! Int])
//        
//      cell.lblPopularViews.text = popularData["view_count"] as? String
        
        
        
        
        //createdAt
        
       let dateInfo = popularData["createdAt"] as! String
        
        
        let dataStringFormatter = DateFormatter()
        
        dataStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date1 = dataStringFormatter.date(from: dateInfo)
        
        
        let date2 = Date()
        
        
        let calender = NSCalendar.current
        
        let myDate1 = calender.startOfDay(for: date1!)
        
        let myDate2 = calender.startOfDay(for: date2)
        
        
        let components = calender.dateComponents([.day], from: myDate1, to: myDate2)
        
        
        cell.lblPopularDay.text = String(format:"%d Dayago", components.day!)
        
        
        cell.imgPopularPhoto.image = nil
        
     
        
        if (popularData["filemimeType"] as! String) == "video/mp4"
        {
            cell.imgPlayPopularVideo.image = UIImage(named: "privatePublicBigPlay")
        }
        else
        {
            
            cell.imgPlayPopularVideo.image = UIImage(named: "privateAudio")
            
        }
        
        if ( popularData["thumbnailPath"] as? String != nil )
        {
            
 
            var orginalStringUrl = popularData["thumbnailPath"] as! String
        
            
            orginalStringUrl.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")

            print("Check Image URL video  ",orginalStringUrl)
            
            cell.imgPopularPhoto.getImageFromUrl(orginalStringUrl)
        }
        
      else
        {
            
            
            cell.imgPopularPhoto.backgroundColor = UIColor.getPrivateCellColor()
            
            
        }
        
        let likeCount = popularData["likeCount"] as! Int
        cell.lblPopularLike.text = String(likeCount)
        let viewCount = popularData["view_count"] as! Int
        cell.lblPopularViews.text = String(viewCount)
        let emotionCount = popularData["emotionCount"] as! Int
        cell.lblPopularEmotion.text = String(emotionCount)
        cell.lblPopularTitle.text = popularData["title"] as? String
        
        
        cell.btnPlayPopularVideo.tag = indexPath.item
        
        
        cell.btnPlayPopularVideo.addTarget(self, action: #selector(playPopularVideo(sender:)), for: .touchUpInside)
        
        
      return cell
        
        
    }
    
    func playPopularVideo(sender : UIButton)
    {
        
        let indexPathValue = IndexPath(item: sender.tag, section: 0)
 
        let popularData = recordPopularVideo[indexPathValue.item]
 
        let playTitle = popularData["title"] as! String
 
        var playVideoPath = popularData["tokenizedUrl"] as! String
 
//        playVideoPath.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
 
        let playFilemimeType = popularData["filemimeType"] as! String
 
        let playID = popularData["_id"] as! String
        
        let playLikeCount = popularData["likeCount"] as! Int
        
        let playViewCount = popularData["view_count"] as! Int
        
        let playSmiley = popularData["emotionCount"] as! Int
        
        let checkUserLike = popularData["isUserLiked"] as! Int
     
        print("check collection video ",checkUserLike)
        
        let requestParameter = ["id" : popularData["_id"] as! String,"video_type": playFilemimeType] as [String : Any]
        
        dashBoardCommonService.updateNumberOfViewOfCount(urlString: followUpdateCountURL.viewCount(), dicData: requestParameter as NSDictionary) { (updateCountresponse, error
            ) in
            print(updateCountresponse)
            if (error == nil) {
                //                storyBoard.playView = labelPlayView + 1
            } else {
                //                storyBoard.playView = labelPlayView
            }
        }
        
        
        let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
        
        
        playViewController.playTitle = playTitle
        
        playViewController.playUrlString = playVideoPath
        
        playViewController.playLike = playLikeCount
        
        playViewController.playView = playViewCount + 1
        
        playViewController.playSmiley = playSmiley
        
        playViewController.nextFileType = playFilemimeType
        
        playViewController.nextID = playID
        
        playViewController.checkLike = checkUserLike
        
        
        
        
     self.navigationController?.pushViewController(playViewController, animated: true)
        
        
    }
 
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
      let cellWidth = self.searchCollectionView.frame.size.width/2 - 30
        
        let cellHight = self.searchCollectionView.frame.size.height - 30
        
        
        
      var returnCell = CGSize(width: cellWidth, height: cellHight)
        
        
        returnCell.width += 13
        
       // returnCell.height += 15
        
        
        return returnCell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat

    {
       return 10.0
    }
 

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
       return 10.0
        
    }
    
   
    
 func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
 {
   
    isFiltered = false
    
    searchBar.text = ""
    
    
    recordPublicVideo.removeAll()
    
    
    DispatchQueue.main.async
        {
        
        self.publicTableView.reloadData()
       }
    
    
        searchBar.showsCancelButton = true
    
    
    self.view.layoutIfNeeded()
    
    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
        self.navigationController?.navigationBar.isHidden = false
        
        self.collectionViewWidth.constant = -160
        
        self.view.layoutIfNeeded()
    }, completion: nil)
    
    
               return true
    
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
    
        
       isFiltered = false
        
        self.navigationController?.navigationBar.isHidden = false
        
        

    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
   
    
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.navigationController?.navigationBar.isHidden = false
            
            self.collectionViewWidth.constant = 160
            
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        DispatchQueue.main.async {
            
            self.publicTableView.reloadData()
            
            
        }
        
    }
    
 func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
 
    return true
    
    }
    
}


