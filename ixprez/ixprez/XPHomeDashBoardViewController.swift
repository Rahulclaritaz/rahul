//
//  XPHomeDashBoardViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 08/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPHomeDashBoardViewController: UIViewController ,iCarouselDataSource,iCarouselDelegate,SWRevealViewControllerDelegate,UIScrollViewDelegate,DashBoardHeartButtonDelegate {
    

    var trendingLikeCount = NSArray ()
    var trendingEmotionCount = NSArray ()
    var trendingViewCount = NSArray ()
    var trendingTitle = NSArray ()
    var trendingThumbnail = NSArray ()
    var trendingFileURLPath = NSArray ()
    var trendingFeaturesId = NSArray ()
    var treadingFileType = NSArray ()
    var treadingUserEmail = NSArray ()
    var treadingUserName = NSArray ()
    var dashboardUserfollowing = NSArray ()
    var followingUserDP = NSArray ()
    var followingUserID = NSArray()
    var activityIndicator = UIActivityIndicatorView ()
    var buttonTrendingSelected = Bool ()
    var buttonRecentSelected = Bool ()
    var userProfileImageResponseURl = String ()
    var isHeartButtonTapped = Bool()
    @IBOutlet weak var xpressBGView = UIView ()
    @IBOutlet var carousel: iCarousel?
    @IBOutlet weak var xpressScrollView = UIScrollView ()
    @IBOutlet weak var xpressTableView = UITableView ()
    @IBOutlet weak var scrollView: UIScrollView!
    let screenHeight = UIScreen.main.bounds.height
    let scrollViewContentHeight = 800 as CGFloat
    var userEmail = String ()
    let dashBoardCommonService = XPWebService()
    let icarouselFeatureVideoURL = URLDirectory.getIcarouselFeatureURL()
    let userPrifileURL = URLDirectory.UserProfile()
    let userReplacingURL = URLDirectory.BaseRequestResponseURl()
    let treandingVideoURL = URLDirectory.treandingURL()
    let recentAudioVideoURL = URLDirectory.recentURL()
    let followUpdateCountURL = URLDirectory.audioVideoViewCount()
    let dashboardScreenCount = URLDirectory.Setting()
    let audioVideoPlayURLString = URLDirectory.audioVideoPlayURL ()
    let followUserURLString = URLDirectory.followUserDetail ()
    let getDashBoardCountWebService = PrivateWebService()
    let getSettingPageDetail = URLDirectory.getSettingPageDetails ()
    let heartDashboardXpressionButton = UIBarButtonItem ()
    var dashboardHeartButtonCount = Int ()
    var dashboardPrivateButtonCount = Int ()
    var dashboardNotifiacationCount = Int ()
    var dashboardCountData = [String : AnyObject]()
    var userVerifiedEmail = Int ()
    var userNameSetting = NSArray ()
    var userMobileSetting =  NSArray ()
    var userEmailSetting =  NSArray ()
    var userReminderSetting = NSArray ()
    var userNotificationSetting = NSArray ()
    var userLanguageSetting = NSArray ()
    var userCountrySetting = NSArray ()
    
    let pulsrator = Pulsator()
    var  popController = UIViewController()
    @IBOutlet weak var userProfileImage = UIImageView()
    @IBOutlet weak var userProfileBorder = UIImageView()
    @IBOutlet weak var userProfileAnimationOne = UIImageView()
    @IBOutlet weak var userProfileAnimationTwo = UIImageView()
    @IBOutlet weak var humburgerMenuIcon = UIBarButtonItem ()
    @IBOutlet weak var privateButton = UIBarButtonItem ()
    @IBOutlet weak var notificationButton = UIBarButtonItem ()
    @IBOutlet weak var settingButton = UIBarButtonItem ()
    
    var imageGesture = UITapGestureRecognizer()
    
    var recordFeatureVideo = [[String : Any]]()
    
    
    var setFlag : Bool!
    
    @IBOutlet weak var pulseAnimationView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userEmail = UserDefaults.standard.value(forKey: "emailAddress") as! String
//        dashboardXpressionCount()  // This will return the dashboard heart, private upload and notification count
        getIcarouselFeaturesVideo() // This will return the carousel video
        getTrendingResponse()  // This will return the treanding video (most like video)
//        getRecentResponse()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//       let tutorialScreen = self.storyboard?.instantiateViewController(withIdentifier: "XPDashboardTutorialViewController")  as! XPDashboardTutorialViewController
//        self.addChildViewController(tutorialScreen)
//        tutorialScreen.view.frame = self.view.frame
//        self.view.addSubview(tutorialScreen.view)
//        tutorialScreen.didMove(toParentViewController: self)
//        heartDashboardXpressionButton.addBadge(number: 10)
        imageGesture = UITapGestureRecognizer(target: self, action: #selector(gotoSettingView(gesture:)))
            
            
        setFlag = true
        
        // It will set the image in the navigation bar.
//        xpressScrollView?.contentSize = CGSize(width: 375, height: scrollViewContentHeight)
//        xpressScrollView?.delegate = self
        xpressTableView?.delegate = self
//        xpressScrollView?.bounces = false
        xpressTableView?.bounces = false
//        xpressTableView?.addSubview(refershController)
//        refershController.backgroundColor = UIColor.red
//        xpressTableView?.isScrollEnabled = false
//        xpressScrollView?.contentSize = CGSize(width: self.view.frame.width, height: 870)
//        carousel?.type = .rotary
//        carousel?.autoscroll = 0.2
        let imageLogo = UIImage (named: "DashboardTitleImage")
        let imageView = UIImageView(image : imageLogo)
        self.navigationItem.titleView = imageView
        
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        userProfileImage?.isHidden = true
//        userProfileBorder?.isHidden = true
        userProfileImage?.layer.masksToBounds = false
        userProfileImage?.layer.borderColor = UIColor.white.cgColor
        userProfileImage?.layer.cornerRadius = (userProfileImage?.frame.size.height)!/2
        userProfileImage?.clipsToBounds = true
        userProfileBorder?.layer.borderWidth = 5.0
        userProfileBorder?.layer.masksToBounds = false
        userProfileBorder?.layer.borderColor = UIColor.white.cgColor
        userProfileBorder?.layer.cornerRadius = (userProfileBorder?.layer.frame.size.height)!/2
        userProfileBorder?.clipsToBounds = true
        userProfileBorder?.alpha = 0.1
        userProfileAnimationOne?.isHidden = true
        userProfileAnimationOne?.layer.borderWidth = 20.0
        userProfileAnimationOne?.layer.masksToBounds = false
        userProfileAnimationOne?.layer.borderColor = UIColor.white.cgColor
        userProfileAnimationOne?.layer.cornerRadius = (userProfileAnimationOne?.layer.frame.size.width)!/2
        userProfileAnimationOne?.clipsToBounds = false
        userProfileAnimationOne?.alpha = 0.1
        userProfileAnimationTwo?.isHidden = true
//        userProfileAnimationTwo?.layer.borderWidth = 25.0
        userProfileAnimationTwo?.layer.masksToBounds = false
        userProfileAnimationTwo?.layer.borderColor = UIColor.white.cgColor
        userProfileAnimationTwo?.layer.cornerRadius = (userProfileAnimationTwo?.layer.frame.size.width)!/2
        
        userProfileAnimationTwo?.clipsToBounds = true
//        userProfileAnimationTwo?.alpha = 0.5
        pulseAnimationView?.layer.addSublayer(pulsrator)
        
        
        
      //  activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge, color: .darkGray, placeInTheCenterOf: self.xpressTableView!)
//        self.activityIndicator.startAnimating()
        DispatchQueue.main.async(execute: {
            self.xpressTableView?.reloadData()
        })
//       getIcarouselFeaturesVideo()
        if revealViewController() != nil {
            
            revealViewController().rightViewRevealWidth = 235
            humburgerMenuIcon?.target = revealViewController()
            humburgerMenuIcon?.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
     //   self.xpressTableView?.reloadData()
        
     //   someBarButtonItem.image = UIImage(named:"myImage")?.withRenderingMode(.alwaysOriginal)

     //   Do any additional setup after loading the view.
    }
    
    
    func getSettingDataResponse () {
        let phoneNumber : String = UserDefaults.standard.string(forKey: "mobileNumber")!
        
        let dicData = ["phone_number": phoneNumber]
        dashBoardCommonService.getSettingPageDetails(urlString: getSettingPageDetail.settingPageUserDetailURL(), dicData: dicData as NSDictionary) { (responseData, err) in
            
            DispatchQueue.main.async {
                print("The detail's of the Stting page is \(responseData)")
                
                self.userNameSetting = responseData.value(forKey: "user_name") as! NSArray
                self.userMobileSetting = responseData.value(forKey: "phone_number") as! NSArray
                self.userEmailSetting = responseData.value(forKey: "email_id") as! NSArray
                self.userReminderSetting = responseData.value(forKey: "remainder") as! NSArray
                self.userNotificationSetting = responseData.value(forKey: "notification") as! NSArray
                self.userLanguageSetting = responseData.value(forKey: "language") as! NSArray
                self.userCountrySetting = responseData.value(forKey: "country") as! NSArray
                
                let userName : String = self.userNameSetting[0] as! String
                UserDefaults.standard.set(userName, forKey: "userNameSetting")
                let userEmail : String = self.userEmailSetting[0] as! String
                UserDefaults.standard.set(userEmail, forKey: "userEmailSetting")
                let userMobile : String = self.userMobileSetting[0] as! String
                UserDefaults.standard.set(userMobile, forKey: "userMobileSetting")
                let userRemiander : String = self.userReminderSetting[0] as! String
                UserDefaults.standard.set(userRemiander, forKey: "userReminderSetting")
                let userNotification : String = self.userNotificationSetting[0] as! String
                UserDefaults.standard.set(userNotification, forKey: "userNotificationSetting")
                let userCountry : String = self.userCountrySetting[0] as! String
                UserDefaults.standard.set(userCountry, forKey: "userCountrySetting")
                let userlanguage : String = self.userLanguageSetting[0] as! String
                UserDefaults.standard.set(userlanguage, forKey: "userLanguageSetting")
            }
            
            
            
        }

    }
    
   
    
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//        
//        if scrollView == self.scrollView {
//            if yOffset >= scrollViewContentHeight - screenHeight {
//                scrollView.isScrollEnabled = false
//                xpressTableView?.isScrollEnabled = true
//            }
//        }
//        
//        if scrollView == self.xpressTableView {
//            if yOffset <= 0 {
//                self.scrollView.isScrollEnabled = true
//                self.xpressTableView?.isScrollEnabled = false
//            }
//        }
//    }
    
    // This method will call when clik on the trending button
    
    func dashboardXpressionCount() {
        
        let parameter = ["user_email": UserDefaults.standard.value(forKey: "emailAddress"), "PreviousCount" : 0 ]
        
         getDashBoardCountWebService.getPrivateData(urlString: dashboardScreenCount.getPrivateData(), dicData: parameter) { (response, error) in
            print("the dashboard count is \(response)")
            self.dashboardCountData = response["data"] as! [String : AnyObject]
            self.dashboardHeartButtonCount = self.dashboardCountData["TotalNumberofrecords"] as! Int
            print("The dashboard heart expression count is \(self.dashboardHeartButtonCount)")
            self.dashboardPrivateButtonCount = self.dashboardCountData["PrivateCount"] as! Int
            print("The dashboard private  expression count is \(self.dashboardPrivateButtonCount)")
            self.dashboardNotifiacationCount = self.dashboardCountData["PrivateFollowCount"] as! Int
            print("The dashboard notification  expression count is \(self.dashboardNotifiacationCount)")
            self.userVerifiedEmail = self.dashboardCountData["email_verified"] as! Int
            print("User email verification code 0 = Not verified and 1 = Verified    \(self.userVerifiedEmail)")
        }
        
    }
    
   @IBAction func xpressionHeartButtonAction (sender : AnyObject) {
    
    guard isHeartButtonTapped else {
        let  popController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPDashBoardHeartXpressionCountViewController") as! XPDashBoardHeartXpressionCountViewController
        popController.countExpression = self.dashboardHeartButtonCount
        isHeartButtonTapped = true
        popController.delegate = self
        self.addChildViewController(popController)
        popController.view.frame = self.view.frame
        self.view.addSubview(popController.view)
        popController.didMove(toParentViewController: self)
        return
    }
    
   
        
    }
    // This is the delegate function will check for heartbutton clicked or not
    func dashBoardHeartButtonCount(isTapped: Bool) {
         isHeartButtonTapped  = isTapped
    }
    
    func gotoSettingView(gesture: UIGestureRecognizer )
    {
        
        let settingView = storyboard?.instantiateViewController(withIdentifier: "XPSettingsViewController") as! XPSettingsViewController
       // settingView.checkAccess = "Not OK"
        //self.navigationController?.present(settingView, animated: true, completion: nil)
        self.navigationController?.pushViewController(settingView, animated: true)
        
        
    }
    func TreandingVideo(sender : UIButton)
    {
      
        setFlag = true
      
        self.getTrendingResponse()
//        DispatchQueue.main.async(execute: {
//            self.xpressTableView?.reloadData()
//        })
        
    }
    
    
    func RecentVideo (sender : UIButton) {
        
        setFlag = false
        
        
//        self.activityIndicator.startAnimating()
        self.getRecentResponse()
//        DispatchQueue.main.async(execute: {
//            self.xpressTableView?.reloadData()
//        })
    }
    
    func TreandingVideoAudioPlayButtonAction (sender: UIButton) {
        print("you click on the \(index) index")
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
        
        let cellIndexPath: Int = sender.tag
        
        let parameter = ["file_id" : trendingFeaturesId[cellIndexPath]]
        dashBoardCommonService.videoAndAudioPlay(urlString: audioVideoPlayURLString.getAudioVideoPlayUrl(), dicData: parameter as NSDictionary) { (responceData, errror) in
            
            
            DispatchQueue.main.async {
                print("\(responceData)")
                storyBoard.playUrlString = responceData as! String
                storyBoard.nextID = self.trendingFeaturesId[cellIndexPath] as! String
                let labelLikeCount: NSInteger = self.trendingLikeCount[cellIndexPath] as! NSInteger
                storyBoard.playLike = labelLikeCount
                let labelSmileyCount: NSInteger = self.trendingEmotionCount[cellIndexPath] as! NSInteger
                storyBoard.playSmiley = labelSmileyCount
                let labelPlayView: NSInteger = self.trendingViewCount[cellIndexPath] as! NSInteger
                storyBoard.playView = labelPlayView
                
                storyBoard.playTitle = self.trendingTitle[cellIndexPath] as! String
                
                print("the carousel video url path is \(storyBoard.playUrlString)")
                self.navigationController?.pushViewController(storyBoard, animated: true)
            }
            
            
        }
        
//        let urlPath: String  = trendingFileURLPath[cellIndexPath] as! String
        
//        var finalURlPath = urlPath.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
//        if (urlPath ==  "null") {
//            print("There is no play url path")
//        } else {
//            storyBoard.playUrlString = responceData as! String
//        }
        
        
        
        
        
    }
    
    /*
    func CarouselPlayVideoButtonAction(_ sender : UIButton)
    {
        
        print("you click on the \(sender.tag) index")
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
        let urlPath = icarouselFileURLPath[sender.tag] as! String
        var finalURlPath = urlPath.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        storyBoard.playUrlString = finalURlPath
        storyBoard.nextID = icarouselFeatureID[sender.tag] as! String
        let labelLikeCount: NSInteger = icarouselLikeCount[sender.tag] as! NSInteger
        storyBoard.playLike = labelLikeCount
        let labelSmileyCount: NSInteger = icarouselSmailyCount[sender.tag] as! NSInteger
        storyBoard.playSmiley = labelSmileyCount
        let labelPlayView: NSInteger = (Int)((icarouselViewCount[sender.tag] as? String)!)!
        storyBoard.playView = labelPlayView
        
        storyBoard.playTitle = icarouselTitle[sender.tag] as! String
        
        print("the carousel video url path is \(storyBoard.playUrlString)")
        
        self.navigationController?.pushViewController(storyBoard, animated: true)
    }
    */
    
    
       //MARK: icarosusel data source method
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return recordFeatureVideo.count
   }
    
    
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return (self.xpressTableView?.frame.size.width)!/2
        
    }
    
    //MARK: icarosusel data source method
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        
        
        
        var iCarData = recordFeatureVideo[index]
        
        var itemView =  UIImageView()
        
        
        
    itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: (self.xpressTableView?.frame.size.width)!/2 * 1.3 , height: 150))
        
        itemView.backgroundColor = UIColor.clear
        itemView.contentMode = .center
        var thumbnailUrl = iCarData["thumbnailPath"] as? String
        
        
        thumbnailUrl?.replace("/root/cpanel3-skel/public_html/Xpress", with: "http://103.235.104.118:3000")
        
       // thumbnailUrl?.replace( localPath, with: localUrl )
    
        itemView.getImageFromUrl(thumbnailUrl!)
        
        itemView.clipsToBounds = true
        itemView.layer.masksToBounds = true
        itemView.contentMode = .scaleAspectFill
        itemView.layer.cornerRadius = 3
        

        let headerView = UIView()
        
        headerView.frame = CGRect(x: itemView.frame.origin.x, y: itemView.frame.origin.y, width: itemView.frame.size.width, height: 30)
        
        headerView.backgroundColor = UIColor.white
        
        
        
        
        let headerUserProfile = UIImageView()
        
        headerUserProfile.frame = CGRect(x: headerView.frame.origin.x + 5, y: headerView.frame.origin.y + 5 , width: 15, height: 15)
        
        var userProfileUrl =  iCarData["profilePicture"] as! String
        
        
       userProfileUrl.replace("/root/cpanel3-skel/public_html/Xpress", with: "http://103.235.104.118:3000")
        //http://183.82.33.232:3000
        
       //  userProfileUrl.replace(localPath, with: localUrl)
        headerUserProfile.layer.cornerRadius = headerUserProfile.frame.size.width/2
        
        headerUserProfile.contentMode = .scaleAspectFill
        
        headerUserProfile.clipsToBounds = true
        
        headerUserProfile.getImageFromUrl(userProfileUrl)
        
        //headerTitleName
        
        
        let headerTitleName = UILabel()
        
        headerTitleName.frame = CGRect(x: headerUserProfile.frame.origin.x + headerUserProfile.frame.size.width , y: headerView.frame.origin.y + 5, width: 50, height: 20)
        
        
        headerTitleName.text = iCarData["username"] as? String
        
        headerTitleName.font = UIFont.xprezMediumFontOfsize(size: 12)
        
        headerTitleName.textColor = UIColor.lightGray
        
        headerTitleName.textAlignment = .center
        
      
        let headerUploadTimeImage = UIImageView()
        
        headerUploadTimeImage.frame = CGRect(x: headerView.frame.size.width - 50, y: headerView.frame.origin.y + 5, width: 15, height: 15)
        
        
        let uploadTimeImage = UIImage(named: "TimeImage")
        
        headerUploadTimeImage.image = uploadTimeImage
        
        
        
        let headerUploadTime = UILabel()
        
        headerUploadTime.frame = CGRect(x: headerUploadTimeImage.frame.origin.x + 17, y: headerView.frame.origin.y + 5, width: 30, height: 15)
        
        let createDate = iCarData["createdAt"] as! String
        
        headerUploadTime.font = UIFont.xprezMediumFontOfsize(size: 12)
        
        headerUploadTime.textColor = UIColor.lightGray
        
        
        headerUploadTime.text = getTheCarouselCreatedTime(createTime: createDate)
        
        //title
          let footerView = UIView()
        
        let carouselTitle = UILabel()
        
        carouselTitle.frame = CGRect(x: itemView.frame.origin.x + 5, y: headerView.frame.origin.x + 50, width: itemView.frame.size.width - 75, height: 40)
        
        carouselTitle.text = (iCarData["title"] as? String)?.uppercased()
         
        carouselTitle.numberOfLines = 2
        
        carouselTitle.font = UIFont.xprezMediumFontOfsize(size: 17)
        
        carouselTitle.textColor = UIColor.white
        
        carouselTitle.textAlignment = .left
        
        headerView.addSubview(carouselTitle)
        
        
        
      
        
        
        footerView.frame = CGRect(x: itemView.frame.origin.x, y: itemView.frame.size.height - 40, width: itemView.frame.size.width, height: 40)
        
        
        footerView.backgroundColor = UIColor.clear
        
        
        let carouselLikeButton = UIButton()
        
        
        carouselLikeButton.frame = CGRect(x: footerView.frame.origin.x + 5, y: footerView.frame.origin.y + 10, width: 15, height: 15)
        
        let likeImage = UIImage(named: "UploadHeart")
        carouselLikeButton.setBackgroundImage(likeImage, for: UIControlState.normal)
        
        
        let footerCarouselLike = UILabel()
        
        footerCarouselLike.frame = CGRect(x: carouselLikeButton.frame.origin.x + 20, y: footerView.frame.origin.y + 10, width: 15, height: 15)
        
        footerCarouselLike.text = String(iCarData["likeCount"] as! Int)
        
        footerCarouselLike.font = UIFont.xprezLightFontOfSize(size: 10)
        
        footerCarouselLike.textColor = UIColor.white
        
        //footerCarouselLike.backgroundColor = UIColor.red
        
        
        
        let carouselViewButton = UIButton()
        
        carouselViewButton.frame = CGRect(x: footerCarouselLike.frame.origin.x + 15, y: footerView.frame.origin.y + 10, width: 15, height: 15)
        
        let viewImage = UIImage(named: "UploadViews")
        
        carouselViewButton.setBackgroundImage(viewImage, for: UIControlState.normal)
        
       
       // carouselViewButton.backgroundColor = UIColor.red
        
        //view_count
        
        
        let footerCarouselView = UILabel()
        
        footerCarouselView.frame = CGRect(x: carouselViewButton.frame.origin.x + 20, y: footerView.frame.origin.y + 10, width: 20, height: 15)
        
        footerCarouselView.text =  iCarData["view_count"] as? String
        
        footerCarouselView.font = UIFont.xprezLightFontOfSize(size: 10)
        
        footerCarouselView.textColor = UIColor.white
        
        //footerCarouselView.backgroundColor = UIColor.white
        
        let carouselFireButton = UIButton()
        
        carouselFireButton.frame = CGRect(x: footerCarouselView.frame.origin.x + 20 , y: footerView.frame.origin.y + 10 , width: 15, height: 15)
        let fireImage = UIImage(named: "FireImage")
        carouselFireButton.setBackgroundImage(fireImage, for: UIControlState.normal)
        
       // carouselFireButton.backgroundColor = UIColor.clear
        
        let footerCarouselFire  = UILabel()
        
        footerCarouselFire.frame = CGRect(x: carouselFireButton.frame.origin.x + 20, y: footerView.frame.origin.y + 10, width: 15, height: 15)
        
        
        footerCarouselFire.font =  UIFont.xprezLightFontOfSize(size: 10)
        
        footerCarouselFire.text = String(iCarData["smailyCount"] as! Int)
        
       footerCarouselFire.textColor = UIColor.white
        
        let carouselPlayVideoButton = UIButton()
        
        carouselPlayVideoButton.frame = CGRect(x: footerView.frame.size.width - 40 , y: footerView.frame.origin.y, width: 30.0, height: 30.0)
        
        carouselPlayVideoButton.viewWithTag(index)
        let playButtonImage = UIImage(named: "UploadPlay")
        carouselPlayVideoButton.setBackgroundImage(playButtonImage, for: UIControlState.normal)
      
        
        headerView.addSubview(carouselPlayVideoButton)
        
        headerView.addSubview(footerCarouselFire)
        
        
        headerView.addSubview(carouselFireButton)
        
        headerView.addSubview( footerCarouselView)
        
        headerView.addSubview(carouselViewButton)
        
        
        headerView.addSubview(footerCarouselLike)
        
        headerView.addSubview(carouselLikeButton)
        
        headerView.addSubview(headerUploadTime)
        
        
        headerView.addSubview(headerUploadTimeImage)
        
        headerView.addSubview(headerTitleName)
        
        headerView.addSubview(headerUserProfile)
        
        
        itemView.insertSubview(footerView, aboveSubview: headerView)
        
        itemView.addSubview(headerView)

        
        //username
        
    
        
        
        
        return itemView
    }
    
    
    
    
    
    //MARK: icarousel delegate method
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int)
    {
        /*
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
 
  */
        
        print("you click on the \(index) index")
 
        let playData = recordFeatureVideo[index]
        
        let playTitle = playData["title"] as! String
        
        var playVideoPath = playData["fileuploadPath"] as! String
        
       // playVideoPath.replace(localPath, with: localUrl )
        
        let playFilemimeType = playData["filemimeType"] as! String
        
        let playID = playData["_id"] as! String
        
        let playLikeCount = playData["likeCount"] as! Int
        
        let playViewCount = playData["view_count"] as! Int
        
        let playSmiley = playData["smailyCount"] as! Int
        
        let checkUserLike = playData["liked"] as! Int
        
        
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
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch (option)
        {
            
        case .wrap:
            
            return  1.0
            
        case .spacing :
            
            
            return 0.6
            
        case .count :
            
            return 5
            
        default:
            
            return value;
            
            
        }


    }
    
    /*
     func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 3.3
        }
        return value
    }
    */
    
    // This method will convert the resonse service time in hh:mm formet.
    func getTheCarouselCreatedTime(createTime: String) -> String {
        let dateString = createTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "hh:mm"
        let newDate = dateFormatter.string(from: dateObj!)
        print(newDate)
        return newDate
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // This will return the dashboard heart, private upload and notification count
        getSettingDataResponse() //  This will return the detail of the user [will use in setting page]
        getUserProfile()
        dashboardXpressionCount()
        // This will create the number of circle animation and radius
        pulsrator.numPulse = 5
        pulsrator.radius = 120
        pulsrator.animationDuration = 6
        pulsrator.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0).cgColor
       pulsrator.start()
        
        if (UserDefaults.standard.bool(forKey: "isAppFirstTime")) {
            UserDefaults.standard.set(false, forKey: "isAppFirstTime")
            popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPDashboardTutorialViewController") as! XPDashboardTutorialViewController
            self.addChildViewController(popController)
            popController.view.frame = self.view.frame
            self.view.addSubview(popController.view)
            self.didMove(toParentViewController: self)
        }
        
        self.navigationItem.leftBarButtonItem?.badgeValue = String(self.dashboardHeartButtonCount)
        self.privateButton?.badgeOriginX = 10.0
        self.privateButton?.badgeOriginY = 10.0
        self.privateButton?.badgeValue = String(self.dashboardPrivateButtonCount)
        self.notificationButton?.badgeOriginX = 10.0
        self.notificationButton?.badgeOriginY = 10.0
        self.notificationButton?.badgeValue = String(self.dashboardNotifiacationCount)
        if (self.userVerifiedEmail == 0) {
            settingButton?.setBackgroundImage((UIImage(named: "setting_Warning.png")), for: .normal, barMetrics: .default)
            print("Email Not verified")
        } else {
            settingButton?.setBackgroundImage((UIImage(named: "")), for: .normal, barMetrics: .default)
            print("Email verified")
        }
        
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pulsrator.stop()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserProfile() {

    let parameter = [ "email_id" : userEmail]
        
        dashBoardCommonService.getUserProfileWebService(urlString: userPrifileURL.url(), dicData: parameter as NSDictionary, callback: {(userprofiledata , error) in
            let imageURL: String = userprofiledata.value(forKey: "profile_image") as! String
            print(imageURL)
            self.userProfileImageResponseURl = imageURL
            
           // self.userProfileImageResponseURl = imageURL.replacingOccurrences(of: localPath , with:localUrl )

            let url = NSURL(string: imageURL)
            let session = URLSession.shared
            
            let taskData = session.dataTask(with: url! as URL, completionHandler: {(data,response,error) -> Void  in
                
                if (data != nil)
                {
                    
                    DispatchQueue.main.async {
                        
                        self.userProfileImage?.image = UIImage(data: data!)
                        
                    }
                    
                    
                }
                
                
            })
            
            
            taskData.resume()
//            self.userProfileImage?.getImageFromUrl(newString)
//            print(newString)
//            self.userProfileImage?.getImageFromUrl(newString)
//            let url = NSURL(string : newString)
//            let imageData = NSData(contentsOf: (url as URL?)!)
//            self.userProfileImage?.image = UIImage(data: (imageData as Data?)!)
            
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
    
    // This will send the request to the web server with parameter and will return the carousel user data
    func getIcarouselFeaturesVideo ()
    {
        let parameter = ["video_type" : "video"]
        
           dashBoardCommonService.getIcarouselFeaturesVideo(urlString: icarouselFeatureVideoURL.url() , dicData: parameter as NSDictionary, callBack: {(icarouselVideoData , error) in
            print("You get the Value from features video data")
            
            
            self.recordFeatureVideo = icarouselVideoData
            
            print("mathan feature video", icarouselVideoData)
            
                     
            DispatchQueue.main.async {
              self.carousel?.reloadData()
                self.xpressTableView?.reloadData()
                
            }
            
            
        })
        
        
    }
    
    // This method will send the request and will return the Dashboard Treanding data response
    func getTrendingResponse () {
        self.activityIndicator.startAnimating()
        let requestParameter = ["user_email": UserDefaults.standard.value(forKey: "emailAddress") ,"emotion":"like","index":"0","limit":"30"]
        dashBoardCommonService.getTreandingVideoResponse(urlString: treandingVideoURL.url(), parameter: requestParameter as NSDictionary) { (treandingResponse, error) in
       //     print(treandingResponse)
            if (error == nil) {
                self.trendingLikeCount = treandingResponse.value(forKey: "likeCount") as! NSArray
                self.trendingEmotionCount = treandingResponse.value(forKey: "emotionCount") as! NSArray
                self.trendingViewCount = treandingResponse.value(forKey: "view_count") as! NSArray
                self.trendingTitle = treandingResponse.value(forKey: "title") as! NSArray
                self.trendingThumbnail = treandingResponse.value(forKey: "thumbtokenizedUrl") as! NSArray
                self.trendingFileURLPath = treandingResponse.value(forKey: "tokenizedUrl") as! NSArray
                self.trendingFeaturesId = treandingResponse.value(forKey: "_id") as! NSArray
                self.treadingFileType = treandingResponse.value(forKey: "filemimeType") as! NSArray
                self.treadingUserEmail = treandingResponse.value(forKey: "from_email") as! NSArray
                self.treadingUserName = treandingResponse.value(forKey: "from_user") as! NSArray
                self.dashboardUserfollowing = treandingResponse.value(forKey: "isuerfollowing") as! NSArray
                self.followingUserDP = treandingResponse.value(forKey: "thumbtokenizedUrl") as! NSArray
                self.followingUserID = treandingResponse.value(forKey: "user_id") as! NSArray
             
              //  XPDashboardTableViewCell
                DispatchQueue.main.async(execute: {
                   self.xpressTableView?.reloadData()
                    
                 
                })
                self.activityIndicator.stopAnimating()
              
                
            }
                
            
        }
    }
    
    // This method will send the request and will return the Dashboard Recent data response
    
    func getRecentResponse () {
        self.activityIndicator.startAnimating()
        let requestParameter = ["user_email": UserDefaults.standard.value(forKey: "emailAddress"),"emotion":"like","index":"0","limit":"30","language":"English","country":"India"]
        dashBoardCommonService.getRecentAudioVideoResponse(urlString: recentAudioVideoURL.url(), dictParameter: requestParameter as NSDictionary) { (recentResponse, error) in
         //   print(recentResponse)
            self.trendingLikeCount = recentResponse.value(forKey: "likeCount") as! NSArray
            self.trendingEmotionCount = recentResponse.value(forKey: "emotionCount") as! NSArray
            self.trendingViewCount = recentResponse.value(forKey: "view_count") as! NSArray
            self.trendingTitle = recentResponse.value(forKey: "title") as! NSArray
            self.trendingThumbnail = recentResponse.value(forKey: "thumbtokenizedUrl") as! NSArray
            self.trendingFileURLPath = recentResponse.value(forKey: "tokenizedUrl") as! NSArray
            self.trendingFeaturesId = recentResponse.value(forKey: "_id") as! NSArray
            self.treadingFileType = recentResponse.value(forKey: "filemimeType") as! NSArray
            self.treadingUserEmail = recentResponse.value(forKey: "from_email") as! NSArray
            self.treadingUserName = recentResponse.value(forKey: "from_user") as! NSArray
            self.dashboardUserfollowing = recentResponse.value(forKey: "isuerfollowing") as! NSArray
            self.followingUserDP = recentResponse.value(forKey: "thumbtokenizedUrl") as! NSArray
            self.followingUserID = recentResponse.value(forKey: "user_id") as! NSArray
            
            DispatchQueue.main.async(execute: {
                self.xpressTableView?.reloadData()
                
                
            })

           
            self.activityIndicator.stopAnimating()
            
        }
    
    }
    
    // This method will display the Originator [follow] user details.
    func followUserAction (sender : UIButton) {
        let followView = self.storyboard?.instantiateViewController(withIdentifier: "XPFolllowsViewController") as! XPFolllowsViewController
        
        let dicData = ["user_id": followingUserID[sender.tag], "index":"0","limit":"30","emotion": "like"]
        dashBoardCommonService.followUserResponse(urlString: followUserURLString.followUserDataDetailURL(), dicData: dicData as NSDictionary) { (dicData, error) in
            print(dicData)
            
            DispatchQueue.main.async {
                let followArrayData: NSArray = dicData.value(forKey: "Records") as! NSArray
                followView.recordFollow = followArrayData as! [[String : Any]]
                self.navigationController?.pushViewController(followView, animated: true)
            }
            
        }
        
        
        
        // to whom going to follow that user email id
//        followView.followersEmail = treadingUserEmail[sender.tag] as! String
//        
        // to whom going to follow that user user name
        followView.userName = treadingUserName[sender.tag] as! String
//        
        followView.followingUserId = followingUserID[sender.tag] as! String
//        
//        // to whom going to follow that user thumbnail Image
//        let thumbImageURLString = self.trendingThumbnail[sender.tag] as! String
//       // let finalThumbNailImageURL = thumbImageURLString.replacingOccurrences(of: localPath , with: localUrl )
//        
//        // To whom going to follow will check it is already follow or not (0 == not following & 1 = following)
//        followView.isUserFollowing = self.dashboardUserfollowing[sender.tag] as! Int
//        
//        // To whom going to follow that user profile image
        let followingUserProfileURLString = self.followingUserDP[sender.tag] as! String
//        let followingUserProfileURL = followingUserProfileURLString.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress", with: "http://103.235.104.118:3000")
//        
//        let userThumbNailImage = UIImageView()
//        userThumbNailImage.getImageFromUrl(thumbImageURLString)
//        followView.userPhoto = userThumbNailImage.image!
        
        let followingUserProfileImage = UIImageView ()
        followingUserProfileImage.getImageFromUrl(followingUserProfileURLString)
        followView.profileIconImage.image = followingUserProfileImage.image
        followView.userPhoto = followingUserProfileImage.image!
        print(followView.followersEmail)
        print(followView.userName)
        
        
        
    }

    
  /*  func getPulledRefreshedData() {
        if (setFlag == true) {
            self.getTrendingResponse()
            refershController.beginRefreshing()
            self.xpressTableView?.reloadData()
            refershController.endRefreshing()
            
            
        } else {
            self.getRecentResponse()
            refershController.beginRefreshing()
            self.xpressTableView?.reloadData()
            refershController.endRefreshing()
            
        }
        
        
    } */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// This method is tableview datasource method
extension XPHomeDashBoardViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return trendingTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "XPDashboardTableViewCell"
        let cell : XPDashboardTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPDashboardTableViewCell
        if  let thumbImageURLString = self.trendingThumbnail[indexPath.row] as? String {
            cell.thumbNailImage?.clipsToBounds = true
            cell.thumbNailImage?.layer.masksToBounds = true
            cell.thumbNailImage?.layer.cornerRadius = 1.0
            cell.thumbNailImage?.contentMode = .scaleAspectFill
            
            // let finalThumbNailImageURL = thumbImageURLString.replacingOccurrences(of: localPath, with: localUrl )
            
            cell.thumbNailImage?.image = nil
            
            cell.thumbNailImage?.getImageFromUrl(thumbImageURLString)
        } else {
            print("You have null value in thumbnail url")
        }
        
        if ((self.treadingFileType[indexPath.row] as? String) != nil) {
            if (self.treadingFileType[indexPath.row] as! String == "video/mp4") {
                cell.imgVA.image = UIImage(named: "SearchVideoOn")
            } else {
                cell.imgVA.image = UIImage(named: "privateAudio")
            }
        }
        
        if ((self.trendingTitle[indexPath.row] as? String) != nil) {
            cell.titleLabel?.text = self.trendingTitle[indexPath.row] as? String
        }
//        if (self.trendingLikeCount[indexPath.row] as! NSInteger == nul) {
//            
//        } else {
        
        if ((self.trendingLikeCount[indexPath.row] as? Int) != nil){
            let likeCount: NSInteger = self.trendingLikeCount[indexPath.row] as! NSInteger
            cell.likeCountLabel?.text = String(likeCount) + " " + "Likes"
        }
        
//        }
        
        if ((self.trendingEmotionCount[indexPath.row] as? Int) != nil){
            let emotionCount: NSInteger = self.trendingEmotionCount[indexPath.row] as! NSInteger
            cell.emotionCountLabel?.text = String(emotionCount) + " " + "React"
        }
        
        if ((self.trendingViewCount[indexPath.row] as? Int) != nil){
            let viewCountText: NSInteger = self.trendingViewCount[indexPath.row] as! NSInteger
            cell.ViewCountLabel?.text = String(viewCountText) + " " + "Views"
        }
        
        
        cell.playButton?.tag = indexPath.row
        cell.playButton?.addTarget(self, action: #selector(TreandingVideoAudioPlayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        
        if ((self.dashboardUserfollowing[indexPath.row] as? Int) != nil){
            cell.isUserFollowing = self.dashboardUserfollowing[indexPath.row] as! NSInteger
            if (cell.isUserFollowing == 0) {
                cell.followerUserImage?.image = UIImage(named: "DashboardFollowIcon")
            }else {
                cell.followerUserImage?.image = UIImage(named: "DashboardUnFollowIcon")
            }
        }
        
        cell.followUserButton?.tag = indexPath.row
        cell.followUserButton?.addTarget(self, action: #selector (followUserAction(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    // This method is tableview datasource method
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // This method is tableview datasource method
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cellIdentifierDashboard = "XPDashBoardProfileTableViewCell"
        let cellDashBoard : XPDashBoardProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierDashboard) as! XPDashBoardProfileTableViewCell
        if (userProfileImageResponseURl == "") {
            cellDashBoard.cellUserProfileImage?.backgroundColor = UIColor.purple
        } else {
            cellDashBoard.cellUserProfileImage?.getImageFromUrl(userProfileImageResponseURl)
        }
        
        
        // This will add the circle animation (pulsrator) in the tableview cell.
        cellDashBoard.pulseAnimationView.layer.addSublayer(pulsrator)
        cellDashBoard.cellUserProfileImage?.addGestureRecognizer(imageGesture)
        cellDashBoard.cellUserProfileImage?.isUserInteractionEnabled = true
        
        //cellDashBoard.pulseAnimationView.sendSubview(toBack: cellDashBoard.cellUserProfileImage!)
        //cellDashBoard.pulseAnimationView.sendSubview(toBack: cellDashBoard.cellCarousel!)
        
        
       //cellDashBoard.pulseAnimationView?.bringSubview(toFront: cellDashBoard.cellCarousel!)
        
        //cellDashBoard.pulseAnimationView.bringSubview(toFront: cellDashBoard.cellUserProfileImage!)
        
      
        // This will add the icarousel in tableviewcell.
        cellDashBoard.cellCarousel?.type = .coverFlow
        cellDashBoard.cellCarousel?.autoscroll = 0.25
        
        
        xpressTableView?.tableHeaderView = cellDashBoard
        
        let cellIdentifier = "XPDashboardHeaderTableViewCell"
        let cell : XPDashboardHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPDashboardHeaderTableViewCell
        
        
        
        if setFlag == true
        
        {
            cell.treadingButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
            cell.recentButton?.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            cell.recentViewLine?.isHidden = true
            cell.treadingViewLine?.isHidden = false
            
        }
        else
        {
            cell.treadingButton?.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            cell.recentButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
            cell.recentViewLine?.isHidden = false
            cell.treadingViewLine?.isHidden = true
            
            
        }
        
        
        cell.treadingButton?.addTarget(self, action: #selector(TreandingVideo(sender:)), for: UIControlEvents.touchUpInside)
        cell.recentButton?.addTarget(self, action: #selector(RecentVideo(sender:)), for: UIControlEvents.touchUpInside)
        
//        cell.delegate = self
        
        return cell.contentView
    }
    
    
    
}

// This method is tableview delegate method
extension XPHomeDashBoardViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
        
//        let cellIndexPath = sender.tag
        
        // This will send the parameter to the view count service and return the response
       let fileType: String = self.treadingFileType[indexPath.row] as! String
       let followFileType = fileType.replacingOccurrences(of: "/mp4", with: "")
        var  fileTypeData =  String()
        if (followFileType == "video"){
            fileTypeData = followFileType
        } else {
            fileTypeData = "audio"
        }
        print(followFileType)
        let requestParameter = ["id" : self.trendingFeaturesId[indexPath.row],"video_type": fileTypeData] as [String : Any]
        
        dashBoardCommonService.updateNumberOfViewOfCount(urlString: followUpdateCountURL.viewCount(), dicData: requestParameter as NSDictionary) { (updateCountresponse, error
            ) in
            print(updateCountresponse)
            if (error == nil) {
//                storyBoard.playView = labelPlayView + 1
            } else {
//                storyBoard.playView = labelPlayView
            }
        }
        
        let urlPath = trendingFileURLPath[indexPath.row] as! String
        
       // let finalURlPath = urlPath.replacingOccurrences(of: localPath, with: localUrl)
        
        storyBoard.playUrlString = urlPath
        storyBoard.nextID = trendingFeaturesId[indexPath.row] as! String
        let labelLikeCount: NSInteger = trendingLikeCount[indexPath.row] as! NSInteger
        storyBoard.playLike = labelLikeCount
        let labelSmileyCount: NSInteger = trendingEmotionCount[indexPath.row] as! NSInteger
        storyBoard.playSmiley = labelSmileyCount
        storyBoard.playTitle = trendingTitle[indexPath.row] as! String
        let labelPlayView: NSInteger = trendingViewCount[indexPath.row] as! NSInteger
        storyBoard.playView = labelPlayView + 1
        
        print("the carousel video url path is \(storyBoard.playUrlString)")
        self.navigationController?.pushViewController(storyBoard, animated: true)
        
    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        self.xpressBGView?.frame = CGRect(x: 0, y: -200, width: 375, height: 500)
//    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        self.xpressBGView?.frame = CGRect(x: 0, y: 0, width: 375, height: 500)
//    }
    
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    
//        self.xpressBGView?.frame = CGRect(x: 0, y: -200, width: 375, height: 500)
//    }
    
}

// This method is button delegate method
//extension XPHomeDashBoardViewController : treadingButtonDelegate
//{
//    func buttonSelectedState(cell: XPDashboardHeaderTableViewCell) {
//         buttonTrendingSelected = (cell.treadingButton?.isSelected)!
//         print(buttonTrendingSelected)
//         buttonRecentSelected = (cell.recentButton?.isSelected)!
//         print(buttonRecentSelected)
//        self.xpressTableView?.reloadData()
//    }
//}
