//
//  XPSearchViewController.swift
//  ixprez
//
//  Created by Quad on 5/29/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//



import UIKit

class XPSearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,passFollow
    
{
    
   @IBOutlet weak var publicTableView: UITableView!
    
    var getSearchURL = URLDirectory.Search()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        getPopularVideo()
        
        publicTableView.backgroundView = imageView
        
        publicTableView.separatorColor = UIColor.clear
        

        isFiltered = false
        

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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
/*
         ixprez
         
  Nothing found with the name
         " "
 */
        
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
        
        self.imageView.alpha = 0.5
        
        
        self.imageView.contentMode = .scaleAspectFit
     
        
    }
 
 /*
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
           self.publicTableView.endEditing(true)
    }
    */
    
    
    func getPublicVideo(myString : String)
    {
        
      print("check data mathan", myString)
        
    Index += 1
        
        let dicData = ["tags":myString,"index": Index - 1 ,"limit": 30,"sort":"like"] as [String : Any]
        
        getWebService.getPrivateDataWebService(urlString: getSearchURL.publicVideo(), dicData: dicData as NSDictionary, callback:  { (dic,dataValue, err ) in
      
           
         let myData = dataValue["data"] as! [ String : Any]
            
            print("sssss",dataValue["code"] as! String)
            
            
        if (dataValue["code"] as! String) != "202"
        {
            
            self.isFiltered = true
            
            self.recordPublicVideo.removeAll()
            
            
            print("ffffffff",dic);
            
            if (myData["last"] as! Int == 0)
            {
            
              for dicData in dic
              {
                 self.recordPublicVideo.append(dicData)
              
              }
                
                self.lastRecord = false
                
           
            }
            
               else
              {
                for dicData in dic
                {
                    self.recordPublicVideo.append(dicData)
                    
                }
                
                self.lastRecord = true
                
                
                print("last record")
                
                          
                
             }
           
            
            
            }
            else
           {
            self.isFiltered = false
            
            print("No record")
            
            
            }
            
            
            
            
            
            DispatchQueue.main.async
                {
                    
                    self.publicTableView.reloadData()
                    
            }
        
        })
            
        
        
        
    }
    
    func   getPopularVideo()
    {
        let dicData = ["user_email": userEmail]
        
        getWebService.getPrivateDataWebService(urlString: getSearchURL.searchPopularVideo() , dicData: dicData as NSDictionary, callback: {(dicc, myData, err) in
          
            if ( err == nil)
            {
            self.recordPopularVideo = dicc
                
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
            
         
           
            self.getPublicVideo(myString: self.mySearchData)
            
            DispatchQueue.main.async {
                
                self.publicTableView.reloadData()
                
            }

            
            
        }
        
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.navigationController?.navigationBar.isHidden = false
            self.collectionViewWidth.constant = 160
            
            self.view.layoutIfNeeded()
            
            
        })
        
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
        
        
        publicTableView.backgroundView?.isHidden = false
        
        
        return cell
       
        
        }
        
        else
      {
        
        cell.isHidden = false
        
        publicTableView.backgroundView?.isHidden = true
        
       if indexPath.row <= recordPublicVideo.count
       {
        
        var publicData = recordPublicVideo[indexPath.row]
        
        
        cell.lblTitle.text? = (publicData["title"] as? String)!.capitalized
           
            
        cell.lblReactionCount.text = String(format: "%d  Likes", publicData["emotionCount"] as! Int)
        
        
        cell.lblLikeCount.text = String(format: "%d  Likes", publicData["likeCount"] as! Int)
        
        let viewCount: Int = Int(publicData["view_count"] as! String)!
        
        cell.lblViewCount.text = String(format: "%d  Views", viewCount)

//        cell.btnPlayPublicVideo.tag = indexPath.row
//        
//        cell.btnPlayPublicVideo.addTarget(self, action: #selector(playPublicVideo(sender:)), for: .touchUpInside)
        
         
            cell.btnPress.tag = indexPath.row
            
        cell.btnPress.addTarget(self, action: #selector(callFollowProfile(sender :)), for: .touchUpInside)
        
        //isuerfollowing
        
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
           self.getPublicVideo(myString: self.mySearchData)
          
        
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
        
         followView.userPhoto = myImage.image!
        
        followView.userName = userName1
        
        followView.dele = self
        
        
        self.navigationController?.pushViewController(followView, animated: true)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltered == false
        {
            
            
//            let indexPathValue = IndexPath(row: sender.tag, section: 0)
            
            // let cell = self.publicTableView.cellForRow(at: indexPathValue) as! XPPublicDataTableViewCell
            
            
            let publicData = recordPublicVideo[indexPath.row]
            
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
            
            let playLikeCount = publicData["likeCount"] as! Int
            
            let playViewCount = Int(publicData["view_count"] as! String)
            
            let playSmiley = publicData["emotionCount"] as! Int
            
            let checkUserLike = publicData["isUserLiked"] as! Int
            
            let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
            
            playViewController.playTitle = playTitle
            
            playViewController.playUrlString = playVideoPath
            
            playViewController.playLike = playLikeCount
            
            playViewController.playView = playViewCount! + 1
            
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
        
    
    } */
    
    
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
        
      cell.lblPopularTitle.text = popularData["title"] as? String
        
      cell.lblPopularLike.text =  String(format: "%d Likes", arguments: [popularData["likeCount"] as! Int])
        
      cell.lblPopularEmotion.text = String(format: "%d Reactions", arguments: [popularData["emotionCount"] as! Int])
        
      cell.lblPopularViews.text = popularData["view_count"] as! String
        
        
        
        
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
        
        
        
        cell.btnPlayPopularVideo.tag = indexPath.item
        
        
        cell.btnPlayPopularVideo.addTarget(self, action: #selector(playPopularVideo(sender:)), for: .touchUpInside)
        
        
      return cell
        
        
    }
    
    func playPopularVideo(sender : UIButton)
    {
        
        let indexPathValue = IndexPath(item: sender.tag, section: 0)
        
        let popularData = recordPopularVideo[indexPathValue.item]
        
        let playTitle = popularData["title"] as! String
        
        var playVideoPath = popularData["fileuploadPath"] as! String
        
        playVideoPath.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        let playFilemimeType = popularData["filemimeType"] as! String
        
        let playID = popularData["_id"] as! String
        
        let playLikeCount = popularData["likeCount"] as! Int
        
        let playViewCount = Int(popularData["view_count"] as! String)
        
        let playSmiley = popularData["emotionCount"] as! Int
        
        let checkUserLike = popularData["isUserLiked"] as! Int
        
        
        let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
        
        
        playViewController.playTitle = playTitle
        
        playViewController.playUrlString = playVideoPath
        
        playViewController.playLike = playLikeCount
        
        playViewController.playView = playViewCount!
        
        playViewController.playSmiley = playSmiley
        
        playViewController.nextFileType = playFilemimeType
        
        playViewController.nextID = playID
        
        playViewController.checkLike = checkUserLike
        
        //playViewController.checkLike = checkUserLike 
        
        
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
    
    recordPublicVideo.removeAll()
    
    
    DispatchQueue.main.async
        {
        
        self.publicTableView.reloadData()
       }
    
    
        searchBar.showsCancelButton = true
    
    
    self.view.layoutIfNeeded()
    
    UIView.animate(withDuration: 0.3, animations: {
        self.navigationController?.navigationBar.isHidden = true
        self.collectionViewWidth.constant = -160
        
        self.view.layoutIfNeeded()
    })
    
    
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
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationController?.navigationBar.isHidden = false
            self.collectionViewWidth.constant = 160
            
            self.view.layoutIfNeeded()
        })
        
        
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


