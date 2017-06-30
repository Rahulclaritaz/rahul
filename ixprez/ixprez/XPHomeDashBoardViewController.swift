//
//  XPHomeDashBoardViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 08/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPHomeDashBoardViewController: UIViewController ,iCarouselDataSource,iCarouselDelegate,SWRevealViewControllerDelegate,UIScrollViewDelegate {
    

    var items: [Int] = []
    var icarouselUserProfile = NSArray ()
    var icarouselUserName = NSArray ()
    var icarouselCreatedTime = NSArray ()
    var icarouselThumbnailImage = NSArray ()
    var icarouselTitle = NSArray ()
    var icarouselUpdateVideoTime = NSArray ()
    var icarouselLikeCount = NSArray ()
    var icarouselViewCount = NSArray ()
    var baseUrl = "http://183.82.33.232:3000/"
    var icarouselFeatureVideoCount = NSArray ()
    var icarouselFileURLPath = NSArray ()
    var icarouselFeatureID = NSArray ()
    var icarouselSmailyCount = NSArray ()
    var trendingLikeCount = NSArray ()
    var trendingEmotionCount = NSArray ()
    var trendingViewCount = NSArray ()
    var trendingTitle = NSArray ()
    var trendingThumbnail = NSArray ()
    var trendingFileURLPath = NSArray ()
    var trendingFeaturesId = NSArray ()
    var treadingFileType = NSArray ()
    var activityIndicator = UIActivityIndicatorView ()
    var buttonTrendingSelected = Bool ()
    var buttonRecentSelected = Bool ()
    var userProfileImageResponseURl = String ()
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
    let pulsrator = Pulsator()
    @IBOutlet weak var userProfileImage = UIImageView()
    @IBOutlet weak var userProfileBorder = UIImageView()
    @IBOutlet weak var userProfileAnimationOne = UIImageView()
    @IBOutlet weak var userProfileAnimationTwo = UIImageView()
    @IBOutlet weak var humburgerMenuIcon = UIBarButtonItem ()
    
    var imageGesture = UITapGestureRecognizer()
    
    
    var setFlag : Bool!
    
    @IBOutlet weak var pulseAnimationView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        getIcarouselFeaturesVideo()
        getTrendingResponse()
//        getRecentResponse()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageGesture = UITapGestureRecognizer(target: self, action: #selector(gotoSettingView(gesture:)))
            
            
        setFlag = true
        
        // It will set the image in the navigation bar.
//        xpressScrollView?.contentSize = CGSize(width: 375, height: scrollViewContentHeight)
//        xpressScrollView?.delegate = self
        xpressTableView?.delegate = self
//        xpressScrollView?.bounces = false
        xpressTableView?.bounces = false
//        xpressTableView?.isScrollEnabled = false
//        xpressScrollView?.contentSize = CGSize(width: self.view.frame.width, height: 870)
        carousel?.type = .rotary
        carousel?.autoscroll = 0.2
        let imageLogo = UIImage (named: "DashboardTitleImage")
        let imageView = UIImageView(image : imageLogo)
        self.navigationItem.titleView = imageView
        userEmail = "mathan6@gmail.com"
        
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
        
        
        getUserProfile()
      //  activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge, color: .darkGray, placeInTheCenterOf: self.xpressTableView!)
//        self.activityIndicator.startAnimating()
        self.xpressTableView?.reloadData()
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
        
    }
    
    
    func RecentVideo (sender : UIButton) {
        
        setFlag = false
        
//        self.activityIndicator.startAnimating()
        self.getRecentResponse()
    }
    
    func TreandingVideoAudioPlayButtonAction (sender: UIButton) {
        print("you click on the \(index) index")
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
        
        let cellIndexPath = sender.tag
        
        let urlPath = trendingFileURLPath[cellIndexPath] as! String
        
        var finalURlPath = urlPath.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        storyBoard.playUrlString = finalURlPath
        storyBoard.nextID = trendingFeaturesId[cellIndexPath] as! String
        let labelLikeCount: NSInteger = trendingLikeCount[cellIndexPath] as! NSInteger
        storyBoard.playLike = labelLikeCount
        let labelSmileyCount: NSInteger = trendingEmotionCount[cellIndexPath] as! NSInteger
        storyBoard.playSmiley = labelSmileyCount
        let labelPlayView: NSInteger = (Int)((trendingViewCount[cellIndexPath] as? String)!)!
        storyBoard.playView = labelPlayView
        
        storyBoard.playTitle = trendingTitle[cellIndexPath] as! String
        
        print("the carousel video url path is \(storyBoard.playUrlString)")
        self.navigationController?.pushViewController(storyBoard, animated: true)
        
        
    }
    
    
    //MARK: icarosusel data source method
    func numberOfPlaceholders(in carousel: iCarousel) -> Int {
                return icarouselUserName.count
    }
    //MARK: icarosusel data source method
    func numberOfItems(in carousel: iCarousel) -> Int {
        return icarouselUserName.count
//        return items.count
    }
    
    //MARK: icarosusel data source method
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 240, height: 150))
            itemView.backgroundColor = UIColor.clear
            itemView.contentMode = .center
            var thumbnailUrl = icarouselThumbnailImage[index] as? String
            var thumbnailFinalUrl = thumbnailUrl?.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress", with: "http://183.82.33.232:3000")
            itemView.getImageFromUrl(thumbnailFinalUrl!)
            itemView.clipsToBounds = true
           // itemView.layer.masksToBounds = true
           itemView.contentMode = .scaleAspectFill
            itemView.layer.cornerRadius = 0.3
            
            // This will create the headerview in icarousel.
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 30))
            headerView.backgroundColor = UIColor.white
            let headerUserProfile = UIImageView(frame: CGRect(x: 7, y: 4, width: 23, height: 23))
            
            // This will create the user profile  in icarousel.
            headerUserProfile.layer.cornerRadius = (headerUserProfile.frame.size.height)/2
            var profileUrl = icarouselUserProfile[index] as! String
            var profileFinalUrl = baseUrl + profileUrl
            headerUserProfile.getImageFromUrl(profileFinalUrl)
            headerUserProfile.clipsToBounds = true
            headerUserProfile.backgroundColor = UIColor.clear
            
            // This will create the header title in icarousel.
            let headerTitleName  = UILabel(frame: CGRect(x: 40, y: 6, width: 50, height: 20))
            headerTitleName.font = UIFont(name: "MOSK", size: 10.0)
            headerTitleName.text = icarouselUserName[index] as! String
            headerTitleName.textColor = UIColor.lightGray
            
            // This will create the upload time image in icarousel.
            var headerUploadTimeImage = UIImageView(frame: CGRect(x: 195, y: 9, width: 15, height: 15))
            let uploadTimeImage = UIImage(named: "TimeImage")
            headerUploadTimeImage.image = uploadTimeImage
            
            // This will create the upload time in icarousel.
            let headerUploadTime  = UILabel(frame: CGRect(x: 215, y: 9, width: 30, height: 15))
            headerUploadTime.font = UIFont(name: "MOSK", size: 10.0)
            let createTime = getTheCarouselCreatedTime(createTime: (icarouselCreatedTime[index] as? String)!)
            print(createTime)
            headerUploadTime.text = createTime
            
            headerUploadTime.textColor = UIColor.lightGray
            
            // This will add the subview in the header of icarousel
            headerView.addSubview(headerUploadTimeImage)
            headerView.addSubview(headerUploadTime)
            headerView.addSubview(headerTitleName)
            headerView.addSubview(headerUserProfile)
            itemView.addSubview(headerView)
            
            
            // This will create the Video Screen Title in icarousel.
            let videoScreenTitle = UILabel(frame: CGRect(x: 7, y: 75, width: 140, height: 50))
            videoScreenTitle.font = UIFont(name: "MOSK", size: 17.0)
            videoScreenTitle.lineBreakMode = NSLineBreakMode(rawValue: 2)!
            videoScreenTitle.textColor = UIColor.white
            videoScreenTitle.text = icarouselTitle[index] as? String
            videoScreenTitle.numberOfLines = 2
            videoScreenTitle.text = videoScreenTitle.text?.uppercased()
            itemView.addSubview(videoScreenTitle)
            
            // This will create the Footer view in icarousel.
            let footerView = UIView(frame: CGRect(x: 0, y: 120, width: 200, height: 30))
//            footerView.backgroundColor = UIColor.lightGray
            
            // This will create the Footer like Button in icarousel.
            let carouselLikeButton = UIButton(type: UIButtonType.custom) as UIButton
             carouselLikeButton.frame = CGRect(x: 7.0, y: 12.0, width: 12.0, height: 12.0)
            let likeImage = UIImage(named: "UploadHeart")
            carouselLikeButton.setBackgroundImage(likeImage, for: UIControlState.normal)
            carouselLikeButton.addTarget(self, action: "BtnTouched", for: .touchUpInside)
            
            
            // This will create the Footer like title in icarousel.
            let footerCarouselLike  = UILabel(frame: CGRect(x: 25.0, y: 10.0, width: 25.0, height: 15))
            footerCarouselLike.font = UIFont(name: "MOSK", size: 11.0)
            let likeText: NSInteger = icarouselLikeCount[index] as! NSInteger
            footerCarouselLike.text = String(likeText)
            footerCarouselLike.textColor = UIColor.white
            
            // This will create the Footer View Button in icarousel.
            let carouselViewButton = UIButton(type: UIButtonType.custom) as UIButton
            carouselViewButton.frame = CGRect(x: 50.0, y: 12.0, width: 12.0, height: 12.0)
            let viewImage = UIImage(named: "UploadViews")
            carouselViewButton.setBackgroundImage(viewImage, for: UIControlState.normal)
            carouselViewButton.addTarget(self, action: "BtnTouched", for: .touchUpInside)
            
            
            // This will create the Footer View title in icarousel.
            let footerCarouselView  = UILabel(frame: CGRect(x: 66.0, y: 10.0, width: 25.0, height: 15))
            footerCarouselView.font = UIFont(name: "MOSK", size: 11.0)
            footerCarouselView.text = icarouselViewCount[index] as? String
            footerCarouselView.textColor = UIColor.white
            
            
            // This will create the Footer View Button in icarousel.
            let carouselFireButton = UIButton(type: UIButtonType.custom) as UIButton
            carouselFireButton.frame = CGRect(x: 91.0, y: 12.0, width: 12.0, height: 12.0)
            let fireImage = UIImage(named: "FireImage")
            carouselFireButton.setBackgroundImage(fireImage, for: UIControlState.normal)
            carouselFireButton.addTarget(self, action: "BtnTouched", for: .touchUpInside)
            
            
            // This will create the Footer View title in icarousel.
            let footerCarouselFire  = UILabel(frame: CGRect(x: 108.0, y: 10.0, width: 25.0, height: 15))
            footerCarouselFire.font = UIFont(name: "MOSK", size: 11.0)
            let feturesCount: NSInteger = icarouselFeatureVideoCount[index] as! NSInteger
            footerCarouselFire.text = String(feturesCount)
            footerCarouselFire.textColor = UIColor.white
            
            
            // This will create the play button in icarousel
            let carouselPlayVideoButton = UIButton(type: UIButtonType.custom)
            carouselPlayVideoButton.frame = CGRect(x: 195.0, y: 115.0, width: 30.0, height: 30.0)
            let playButtonImage = UIImage(named: "UploadPlay")
            carouselPlayVideoButton.setBackgroundImage(playButtonImage, for: UIControlState.normal)
            carouselPlayVideoButton.addTarget(self, action: "CarouselPlayVideoButtonAction", for: UIControlEvents.touchUpInside)
            
            
            
            // This will add all the subview in view.
            footerView.addSubview(carouselFireButton)
            footerView.addSubview(footerCarouselFire)
            footerView.addSubview(carouselViewButton)
            footerView.addSubview(footerCarouselView)
            footerView.addSubview(footerCarouselLike)
            footerView.addSubview(carouselLikeButton)
            itemView.addSubview(footerView)
            itemView.addSubview(carouselPlayVideoButton)
            
            
            
            label = UILabel(frame: itemView.bounds)
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.font = label.font.withSize(50)
            label.tag = 1
            itemView.addSubview(label)
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
//        label.text = "\(items[index])"
        
        return itemView
    }
    
    //MARK: icarousel delegate method
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        print("you click on the \(index) index")
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController") as! XPMyUploadPlayViewController
        let urlPath = icarouselFileURLPath[index] as! String
        var finalURlPath = urlPath.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        storyBoard.playUrlString = finalURlPath
        storyBoard.nextID = icarouselFeatureID[index] as! String
        let labelLikeCount: NSInteger = icarouselLikeCount[index] as! NSInteger
        storyBoard.playLike = labelLikeCount
        let labelSmileyCount: NSInteger = icarouselSmailyCount[index] as! NSInteger
        storyBoard.playSmiley = labelSmileyCount
        let labelPlayView: NSInteger = (Int)((icarouselViewCount[index] as? String)!)!
        storyBoard.playView = labelPlayView
        
        storyBoard.playTitle = icarouselTitle[index] as! String
        
        print("the carousel video url path is \(storyBoard.playUrlString)")
        self.navigationController?.pushViewController(storyBoard, animated: true)
        
    }
    
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
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
        // This will create the number of circle animation and radius
        pulsrator.numPulse = 5
        pulsrator.radius = 120
        pulsrator.animationDuration = 6
        pulsrator.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0).cgColor
       pulsrator.start()
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
            
            self.userProfileImageResponseURl = imageURL.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress", with: "http://103.235.104.118:3000")

            let url = NSURL(string: self.userProfileImageResponseURl)
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
    func getIcarouselFeaturesVideo () {
        let parameter = ["video_type" : "video"]
        dashBoardCommonService.getIcarouselFeaturesVideo(urlString: icarouselFeatureVideoURL.url() , dicData: parameter as NSDictionary, callBack: {(icarouselVideoData , error) in
            print("You get the Value from features video data")
            print(icarouselVideoData)
            
            self.icarouselUserProfile = icarouselVideoData.value(forKey: "profilePicture") as! NSArray
            
            self.icarouselUserName = icarouselVideoData.value(forKey: "username") as! NSArray
            self.icarouselCreatedTime = icarouselVideoData.value(forKey: "createdAt") as! NSArray
            self.icarouselThumbnailImage = icarouselVideoData.value(forKey: "thumbnailPath") as! NSArray
             self.icarouselTitle = icarouselVideoData.value(forKey: "title") as! NSArray
            self.icarouselUpdateVideoTime = icarouselVideoData.value(forKey: "createdAt") as! NSArray
            self.icarouselLikeCount = icarouselVideoData.value(forKey: "likeCount") as! NSArray
             self.icarouselViewCount = icarouselVideoData.value(forKey: "view_count") as! NSArray
            self.icarouselFeatureVideoCount = icarouselVideoData.value(forKey: "featuredVideo") as! NSArray
//            self.items = [Int(icarouselVideoData.count)]
            self.icarouselFileURLPath = icarouselVideoData.value(forKey: "fileuploadPath") as! NSArray
            self.icarouselFeatureID = icarouselVideoData.value(forKey: "_id") as! NSArray
            self.icarouselSmailyCount = icarouselVideoData.value(forKey: "smailyCount") as! NSArray
            
            print(self.icarouselUserName)
            print(self.icarouselTitle)
            print(self.icarouselCreatedTime)
            print(self.icarouselLikeCount)
            print(self.icarouselViewCount)
            print(self.icarouselFeatureVideoCount)
            self.carousel?.reloadData()
            
        })
        
        
    }
    
    // This method will send the request and will return the Dashboard Treanding data response
    func getTrendingResponse () {
        self.activityIndicator.startAnimating()
        let requestParameter = ["user_email": "mathan6@gmail.com","emotion":"like","index":"1","limit":"20"]
        dashBoardCommonService.getTreandingVideoResponse(urlString: treandingVideoURL.url(), parameter: requestParameter as NSDictionary) { (treandingResponse, error) in
            print(treandingResponse)
            if (error == nil) {
                self.trendingLikeCount = treandingResponse.value(forKey: "likeCount") as! NSArray
                self.trendingEmotionCount = treandingResponse.value(forKey: "emotionCount") as! NSArray
                self.trendingViewCount = treandingResponse.value(forKey: "view_count") as! NSArray
                self.trendingTitle = treandingResponse.value(forKey: "title") as! NSArray
                self.trendingThumbnail = treandingResponse.value(forKey: "thumbnailPath") as! NSArray
                self.trendingFileURLPath = treandingResponse.value(forKey: "fileuploadPath") as! NSArray
                self.trendingFeaturesId = treandingResponse.value(forKey: "_id") as! NSArray
                self.treadingFileType = treandingResponse.value(forKey: "filemimeType") as! NSArray
                
                
                self.activityIndicator.stopAnimating()
              
                self.xpressTableView?.reloadData()
            }
                
            
        }
    }
    
    // This method will send the request and will return the Dashboard Recent data response
    
    func getRecentResponse () {
        self.activityIndicator.startAnimating()
        let requestParameter = ["user_email": "mathan6@gmail.com","emotion":"like","index":"1","limit":"10","language":"English","country":"India"]
        dashBoardCommonService.getRecentAudioVideoResponse(urlString: recentAudioVideoURL.url(), dictParameter: requestParameter as NSDictionary) { (recentResponse, error) in
            print(recentResponse)
            self.trendingLikeCount = recentResponse.value(forKey: "likeCount") as! NSArray
            self.trendingEmotionCount = recentResponse.value(forKey: "emotionCount") as! NSArray
            self.trendingViewCount = recentResponse.value(forKey: "view_count") as! NSArray
            self.trendingTitle = recentResponse.value(forKey: "title") as! NSArray
            self.trendingThumbnail = recentResponse.value(forKey: "thumbnailPath") as! NSArray
            self.trendingFileURLPath = recentResponse.value(forKey: "fileuploadPath") as! NSArray
            self.treadingFileType = recentResponse.value(forKey: "filemimeType") as! NSArray
            self.activityIndicator.stopAnimating()
            self.xpressTableView?.reloadData()
        }
    
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

extension XPHomeDashBoardViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "XPDashboardTableViewCell"
        let cell : XPDashboardTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPDashboardTableViewCell
        let thumbImageURLString = self.trendingThumbnail[indexPath.row] as! String
        cell.thumbNailImage?.clipsToBounds = true
        cell.thumbNailImage?.layer.masksToBounds = true
        cell.thumbNailImage?.layer.cornerRadius = 1.0
        cell.thumbNailImage?.contentMode = .scaleAspectFit
        let finalThumbNailImageURL = thumbImageURLString.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress", with: "http://103.235.104.118:3000")
        
        cell.thumbNailImage?.image = nil
        
        cell.thumbNailImage?.getImageFromUrl(finalThumbNailImageURL)
        if (self.treadingFileType[indexPath.row] as! String == "video/mp4") {
            cell.imgVA.image = UIImage(named: "SearchVideoOn")
        } else {
            cell.imgVA.image = UIImage(named: "privateAudio")
        }
        
        cell.titleLabel?.text = self.trendingTitle[indexPath.row] as? String
//        if (self.trendingLikeCount[indexPath.row] as! NSInteger == nul) {
//            
//        } else {
            let likeCount: NSInteger = self.trendingLikeCount[indexPath.row] as! NSInteger
            cell.likeCountLabel?.text = String(likeCount) + " " + "Likes"
//        }
        
        
        let emotionCount: NSInteger = self.trendingEmotionCount[indexPath.row] as! NSInteger
        cell.emotionCountLabel?.text = String(emotionCount) + " " + "React"
        let viewCountText: String = (trendingViewCount[indexPath.row] as? String)!
        cell.ViewCountLabel?.text = viewCountText + " " + "Views"
        cell.playButton?.tag = indexPath.row
        cell.playButton?.addTarget(self, action: #selector(TreandingVideoAudioPlayButtonAction(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
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
        
        
        
        xpressTableView?.tableHeaderView = cellDashBoard
        
        let cellIdentifier = "XPDashboardHeaderTableViewCell"
        let cell : XPDashboardHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPDashboardHeaderTableViewCell
        
        
        
        if setFlag == true
        
        {
            
            cell.recentViewLine?.isHidden = true
            cell.treadingViewLine?.isHidden = false
            
        }
        else
        {
            cell.recentViewLine?.isHidden = false
            cell.treadingViewLine?.isHidden = true
            
            
        }
        
        
        cell.treadingButton?.addTarget(self, action: #selector(TreandingVideo(sender:)), for: UIControlEvents.touchUpInside)
        cell.recentButton?.addTarget(self, action: #selector(RecentVideo(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.delegate = self
        
        return cell.contentView
    }
    
    
    
}

extension XPHomeDashBoardViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
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

extension XPHomeDashBoardViewController : treadingButtonDelegate
{
    func buttonSelectedState(cell: XPDashboardHeaderTableViewCell) {
         buttonTrendingSelected = (cell.treadingButton?.isSelected)!
         print(buttonTrendingSelected)
         buttonRecentSelected = (cell.recentButton?.isSelected)!
         print(buttonRecentSelected)
        self.xpressTableView?.reloadData()
    }
}
