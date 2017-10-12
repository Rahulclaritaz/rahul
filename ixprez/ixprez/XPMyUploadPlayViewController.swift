//
//  XPMyUploadPlayViewController.swift
//  ixprez
//
//  Created by Quad on 5/19/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation



class XPMyUploadPlayViewController: UIViewController,AVPlayerViewControllerDelegate,UINavigationControllerDelegate
    
{
    
    
    // Outlet Reference
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var imgEmotion: UIImageView!
    
    @IBOutlet weak var imgHeart: UIImageView!
    
    @IBOutlet weak var btnPlay: UIButton!

    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var lblViewCount: UILabel!

    @IBOutlet weak var lblSmiley: UILabel!
    @IBOutlet weak var backgroundImage : UIImageView!
    @IBOutlet weak var profileBackgroundImage : UIImageView!
    var backgroundUserImageString : String!
    
    
    var setImage : Bool!
    
    
    var nextCountArray = [Int]()
    var nextEmotionArray = [String]()
 
    
    //Pass global Reference from previous view
    
    var playTitle  : String!
   
    var playUrlString = String()
    
    var playLike = Int()
    
    var playView = Int()
    
    var playSmiley = Int()
    
    var checkLike = Int()
    
    var isSelect : Bool!
    
    var pressButton : Bool!
    
    // goto Next View
    
    var nextFileType = String()
    
    var nextID = String()
  
    
    // end
    
    var player = AVPlayer()
    
    var playerController = AVPlayerViewController()
    
    var naviBar : UINavigationBar = UINavigationBar()
    
    
    var nsuerDefault = UserDefaults.standard
    
    var userEmail = String()
    
    
    var getEmotionUrl = URLDirectory.MyUpload()
    
    var getEmotionWebService = MyUploadWebServices()
    
    var recordEmotionCountData = [[String :Any]]()
    
    var swipeGesture = UISwipeGestureRecognizer()
    
    var tapGesture = UITapGestureRecognizer()
    
    let transitionView = CATransition()
    
    
    var isTuch : Bool!
    var isEmotionUploadViewOpen : Bool!
    
    
    
    override func awakeFromNib() {
        
        
        
         userEmail = nsuerDefault.string(forKey: "emailAddress")!
        
        
        print("mathan saveEmail",userEmail)
        
    }
    
    
    override func viewDidLoad()
    {
        
        
        super.viewDidLoad()
        
        
        
        print("mathan check this one",checkLike)
       isEmotionUploadViewOpen = false
       isTuch = true
        
       setImage = false
        
        pressButton = true
        
       
        print("myPlay")
        print(playUrlString)
        self.navigationItem.title = playTitle
        backgroundImage.isHidden = true
        profileBackgroundImage.isHidden = true
//        self.backgroundImage.getImageFromUrl(backgroundUserImageString)
//        profileBackgroundImage.layer.cornerRadius = profileBackgroundImage.frame.size.width/2
//        profileBackgroundImage.clipsToBounds = true
//        profileBackgroundImage.getImageFromUrl(backgroundUserImageString)
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        naviBar.tintColor = UIColor.getXprezBlueColor()
        
        if checkLike == 1
        {
             lblLikeCount.text = String(format: "%d Likes",playLike )
             imgHeart.image = UIImage(named: "UploadUnHeart")
            
             isSelect = true
            
        }
    
        else
        {
           lblLikeCount.text = String(format: "%d Likes",playLike)
           imgHeart.image = UIImage(named: "UploadHeart")
            
            isSelect = false
            
            
        }
        lblViewCount.text = String(format: "%d Views", playView)
        
        lblSmiley.text = String(format: "%d Reactions", playSmiley)

        swipeGesture  = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)) )
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handeltap(sender:)))
        
        swipeGesture.direction = .down
        
      self.view.addGestureRecognizer(tapGesture)
        
       self.view.addGestureRecognizer(swipeGesture)
        
    
         playVideoAudio()
        

    }
    
    @IBAction func  backButton (_ sender : Any) {
        player.pause()
        playerController.dismiss(animated: true, completion: nil)
       self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // getEmotionCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        player.pause()
//        playerController.dismiss(animated: true, completion: nil)
    }
    
 
    func handeltap(sender: UITapGestureRecognizer)
    {
        guard isEmotionUploadViewOpen else {
            print("Emotion upload view not open")
            return
        }
        removeChildView()
        isEmotionUploadViewOpen = false
        
    }
    
    func handleSwipes(sender : UISwipeGestureRecognizer)
    {
        
        guard isEmotionUploadViewOpen else {
            print("Emotion upload view not open")
            return
        }
        removeChildView()
        isEmotionUploadViewOpen = false
        
    }
    
    func removeChildView()
    {
        var emotionView = self.storyboard?.instantiateViewController(withIdentifier: "XPUploadsEmotionsViewController") as! XPUploadsEmotionsViewController
        
        emotionView = childViewControllers.last as! XPUploadsEmotionsViewController
        
         transitionView.duration = 5.5
        
        transitionView.type = kCATransitionReveal
        
        transitionView.subtype = kCATransitionFromBottom
        
        emotionView.view.layer.add(transitionView, forKey: nil)
        
        
        self.willMove(toParentViewController: nil)
        
        emotionView.view.removeFromSuperview()
        
        emotionView.removeFromParentViewController()
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
         super.touchesBegan(touches, with: event)
        
      
        
         if (isTuch == true)
         {
            
            
            playerController.showsPlaybackControls = true
            
            DispatchQueue.main.async {
                
                self.view.sendSubview(toBack: self.bottomView)
                
                
            }
            
            
            isTuch = false
          
         }
        else
         {
            playerController.showsPlaybackControls = false
            
            DispatchQueue.main.async {
                
                self.view.bringSubview(toFront: self.bottomView)
                
            }
            
            
            isTuch = true
            
            
         }
 
    }
 
    func  playVideoAudio()
    {
//      let urlString =  "https://s3.amazonaws.com/kargopolov/kukushka.mp3"
//        let urlForPlay = "http://183.82.33.232:8095/ExpressApp2/sample.mp4"
    
       let urlData = URL(string: playUrlString)
        
       let playerItemData = AVPlayerItem(url: urlData!)
   
        player = AVPlayer(playerItem: playerItemData)
        
        
        playerController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        
        
        playerController.view.sizeToFit()
        
        playerController.view.autoresizingMask = ([.flexibleWidth,.flexibleHeight])
        
        playerController.showsPlaybackControls = false
    
//        playerController.contentOverlayView?.addSubview(backgroundImage)
//        playerController.contentOverlayView?.addSubview(profileBackgroundImage)
//        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        backgroundImage.addSubview(blurEffectView)
        
        playerController.player = player
        
        
        self.view.addSubview(playerController.view)
        
        
        //bottomView.bringSubview(toFront: playerController.view)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        
        
      
        self.view.bringSubview(toFront: bottomView)
        player.play()
    }
    
    
    
    @IBAction func playVideoAudio(_ sender: UIButton)
    {
//      playerController.contentOverlayView?.removeFromSuperview()
        playVideoAudio()
        
    }
    
    func playerDidFinishPlaying()
    {
        
        playerController.showsPlaybackControls = true
        
       self.view.bringSubview(toFront: btnPlay)
        
       //self.view.bringSubview(toFront: bottomView)
        
        self.view.sendSubview(toBack: bottomView)
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
   
    }
  
    @IBAction func emotionLike(_ sender: UIButton)
    {
 
        
       if isSelect == false
        {
            if (pressButton == true)
            {
            
            imgHeart.image = UIImage(named: "UploadUnHeart")
        
            imgHeart.contentMode = .scaleAspectFit
    
            setImage = true
  
            lblLikeCount.text =  String(format: "%d Likes",playLike + 1 )
        
            getSaveEmotionCount(sender: lblLikeCount.text!)
      
            print(self.nextEmotionArray)
            
            pressButton = false
                
            }
            else
            {
                
            setImage = false
                
            lblLikeCount.text =  String(format: "%d Likes",playLike)
                
            imgHeart.image = UIImage(named: "UploadHeart")
                
            getSaveEmotionCount1(sender: lblLikeCount.text!)
                
            sender.isSelected = false
                
            pressButton = true
                
                
            }
        }
        
       else
        
        
        {
            if pressButton == true
            {
            setImage = false
            
            lblLikeCount.text =  String(format: "%d Likes",playLike - 1)
            
            
            imgHeart.image = UIImage(named: "UploadHeart")
            
            getSaveEmotionCount1(sender: lblLikeCount.text!)
            
            sender.isSelected = false
                
                pressButton = false
                
            }
            else
            {
                imgHeart.image = UIImage(named: "UploadUnHeart")
                
                imgHeart.contentMode = .scaleAspectFit
                
                
                setImage = true
                
                lblLikeCount.text =  String(format: "%d Likes",playLike  )
                
                getSaveEmotionCount(sender: lblLikeCount.text!)
                
                print(self.nextEmotionArray)
                
                pressButton = true
 
            }
            
        }
        
        
      
        
    }
    func getSaveEmotionCount(sender : String)
        
    {
        print(sender)
        
        
        let dicValue = ["id":nextID ,"user_email":userEmail,"emotion":"Like","status":"1"]
        
        
        getEmotionWebService.getReportMyUploadWebService(urlString: getEmotionUrl.saveEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
            
            
            print(dicc)
            
            
            
        })
        
        
        
    }
    func getSaveEmotionCount1(sender : String)
        
    {
        print(sender)
        
        
        let dicValue = ["id":nextID ,"user_email":userEmail,"emotion":"Like","status":"0"]
        
        
        getEmotionWebService.getReportMyUploadWebService(urlString: getEmotionUrl.saveEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
            
            
            print(dicc)
            
            
            
        })
        
        
        
    }

    
    
    
    @IBAction func emotionUpload(_ sender: UIButton)
    {
        
       
   
        let emotionView = self.storyboard?.instantiateViewController(withIdentifier: "XPUploadsEmotionsViewController") as! XPUploadsEmotionsViewController
        
         isEmotionUploadViewOpen = true
        emotionView.ID = nextID
        
        emotionView.FileType = nextFileType
        
       // emotionView.recordEmotionCount = recordEmotionCountData
        
        
        transitionView.duration = 0.5
        
        transitionView.type = kCATransitionPush
        
        transitionView.subtype = kCATransitionFromTop
        
        
        self.addChildViewController(emotionView)
       
        emotionView.view.frame = self.view.bounds
        
        emotionView.view.layer.add(transitionView, forKey: nil)
        
        self.view.addSubview(emotionView.view)
        
        
        emotionView.didMove(toParentViewController: self)
        
 
        
    
    
    }
    

    
    
    
}


    
    

