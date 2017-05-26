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
    
    @IBOutlet weak var btnPlay: UIButton!

    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var lblLikeCount: UILabel!
    
    @IBOutlet weak var lblViewCount: UILabel!

    @IBOutlet weak var lblSmiley: UILabel!
    
    var nextFileType = String()
    
    var nextID = String()
    
    var nextCountArray = [Int]()
    var nextEmotionArray = [String]()
    
    
    var playTitle  : String!
   
    var playUrlString = String()
    
    var playLike = Int()
    
    var playView = Int()
    
    var playSmiley = Int()
    
  
    var player = AVPlayer()
    
    var playerController = AVPlayerViewController()
    
    var naviBar : UINavigationBar = UINavigationBar()
    
     var getEmotionUrl = URLDirectory.MyUpload()
    
    var getEmotionWebService = MyUploadWebServices()
        var recordEmotionCount = [[String :Any]]()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

       getEmotionCount()
        print("myPlay")
        print(playUrlString)
        self.navigationItem.title = playTitle
        
        naviBar.tintColor = UIColor.getXprezBlueColor()
  
        
        lblLikeCount.text = String(format: "%d Likes",playLike)
        
        lblViewCount.text = String(format: "%d Views", playView)
        
        lblSmiley.text = String(format: "%d Reactions", playSmiley)
            
       
         playVideoAudio()
        

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
         if touches.first != nil
         {
           playerController.showsPlaybackControls = true
        
         }
       
           super.touchesBegan(touches, with: event)
        
    }

    
    
    func  playVideoAudio()
    {
    
    let urlData = URL(string: playUrlString)
        
        
        
       let playerItemData = AVPlayerItem(url: urlData!)
   
        player = AVPlayer(playerItem: playerItemData)
        
        
        playerController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 109)
        
        
        playerController.view.sizeToFit()
        
        playerController.view.autoresizingMask = ([.flexibleWidth,.flexibleHeight])
        
        playerController.showsPlaybackControls = false
    
        
        playerController.player = player
        
        
        self.view.addSubview(playerController.view)
        
        
        //bottomView.bringSubview(toFront: playerController.view)
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        
        
      
        self.view.bringSubview(toFront: bottomView)
        player.play()
        
        
        
    }
    
   
    
    @IBAction func playVideoAudio(_ sender: UIButton)
    {
        
        playVideoAudio()
        
    }
    
    func playerDidFinishPlaying(){
        print("Video Finished playing in style")
        print("Video Finished")
        
       // bottomView.isHidden = false
        //playerController.view.bringSubview(toFront: bottomView)
        playerController.showsPlaybackControls = false
        self.view.bringSubview(toFront: btnPlay)
        
        
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()

        
    }
    

    @IBAction func emotionLike(_ sender: UIButton)
    {
    
      
        
    }
    
    
    @IBAction func emotionUpload(_ sender: UIButton)
    {
       
        
        
        let emotionView = self.storyboard?.instantiateViewController(withIdentifier: "XPUploadsEmotionsViewController") as! XPUploadsEmotionsViewController
        
        emotionView.ID = nextID
        emotionView.FileType = nextFileType
        emotionView.countArray = nextCountArray
        emotionView.emotionArray = nextEmotionArray
        self.addChildViewController(emotionView)
        emotionView.view.frame = self.view.bounds
        
        self.view.addSubview(emotionView.view)
        
        emotionView.didMove(toParentViewController: self)
        
       
    
    
    
    }
    
func getEmotionCount()
{
    let dicValue = ["user_email":"mathan6@gmail.com","file_id":nextID]
    
    
    
    getEmotionWebService.getPublicPrivateMyUploadWebService(urlString: getEmotionUrl.uploadEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
        
        
        self.recordEmotionCount = dicc
        
        
        
        for details in self.recordEmotionCount
        {
            let myData = details["count"] as! Int
            let myData2 = details["emotion"] as! String
            
            self.nextCountArray.append(myData)
            
            self.nextEmotionArray.append(myData2)
            
            
            
        }
    })
}
    
    
}


    
    

