//
//  XPPriavtePlayVideoAudioViewController.swift
//  ixprez
//
//  Created by Quad on 5/11/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import AVKit

import AVFoundation

protocol sectionData
{
    
    func sectionnumber( no : Int )

}

class XPPriavtePlayVideoAudioViewController: UIViewController,AVPlayerViewControllerDelegate,UINavigationControllerDelegate {
    
    var getPrivateUrl = URLDirectory.PrivateData()
    
    var getPrivateWebservic = PrivateWebService()
    
    var idValue = String()
    
    var typeVideo = String()
    
    var fromEmail = String()
    
    var sectionNo = Int()
        var delegate : sectionData?
        var customAlertController : DOAlertController!
    
    
    

    var privatePlayer = AVPlayer()
    
    var privatePlayerController = AVPlayerViewController()
    
    
    var naviBar : UINavigationBar = UINavigationBar()
    
    var privateUrlString = String()
    
    var privateTitle = String()
    
  
    
    @IBOutlet weak var subView: UIView!
    
 
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print(sectionNo)
        
      
        
     subView.isHidden = true
        
       self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.naviBar.barTintColor = UIColor.getXprezBlueColor()
    
        
        self.navigationItem.title = privateTitle
     
        playVideoAudio()
        
        

    }
    
    @IBAction func backButton (_ sender : Any) {
        privatePlayer.pause()
        privatePlayerController.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        privatePlayerController.showsPlaybackControls = true
        
        super.touchesBegan(touches, with: event)
        
        
    }
    

    
    func playVideoAudio()
    {
        let url = URL(string: privateUrlString)
        
        let playerItem = AVPlayerItem(url: url!)
        
        privatePlayer = AVPlayer(playerItem: playerItem)
        
        
        privatePlayerController.view.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64)
        
        
        privatePlayerController.view.sizeToFit()
        
        
        privatePlayerController.showsPlaybackControls = false
        
        
        privatePlayer.isClosedCaptionDisplayEnabled = true
        
        privatePlayerController.player = privatePlayer
        
        privatePlayerController.view.autoresizingMask = ([.flexibleWidth , .flexibleHeight])
        
        
        
        self.view.addSubview(privatePlayerController.view)
        
        
        
        privatePlayer.play()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.privatePlayer.currentItem)
        
   
    }
    
    func playerDidFinishPlaying(){
        print("Video Finished playing in style")
        print("Video Finished")
        
        subView.isHidden = false
        
        self.view.bringSubview(toFront: subView)
        

        
    }
    
    
    @IBAction func playVideoOnceAgain(_ sender: Any) {
        subView.isHidden = true
        playVideoAudio()
        
    }
    
    
    @IBAction func acceptVideoAfterplay(_ sender: Any)
    {
        
        
        let title = self.fromEmail
        let message = "It’s your turn to xpress! Want to replay right now and xpress yourself back to them ? Do it"
        let cancelButtonTitle = "Cancel"
        let otherButtonTitle = "Xpress It"
        
        
        
        customAlertController = DOAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.changecustomAlertController()
        
        // customAlertController.overlayColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:0.1)
        
        let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
            action in
            
            print("hi")
        })
        
        let otherAction = DOAlertAction(title: otherButtonTitle, style: .default, handler:{
            
            action in
            
         
            
            let dicValue = [ "id" : self.idValue , "video_type" : self.typeVideo , "feedback" : "1"]
            
            
            self.getPrivateWebservic.getPrivateAcceptRejectWebService(urlString: self.getPrivateUrl.privateAcceptRejectAudioVideo(), dicData: dicValue as NSDictionary, callback:{
                
                (dicc,err)  in
                
                
                if ((dicc["status"] as! String).isEqual("OK"))
                    
                {
                    
                    DispatchQueue.main.async {
                        
                        self.delegate?.sectionnumber(no: self.sectionNo)
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    
                }
                
                
            })

            
        })
        
        
        customAlertController.addAction(cancelAction)
        
        customAlertController.addAction(otherAction)
        
        
        self.present(customAlertController, animated: true, completion: nil)
        
        

        
        
    }
    
    
    @IBAction func rejectVideoAfterPlay(_ sender: Any)
    {
        
        let title = self.fromEmail
        let message = "wanted to Xpress this to you badly . Are you sure you want to reject it?"
        let cancelButtonTitle = "Cancel"
        let otherButtonTitle = "Confirm Rejection"
        
        
        
        customAlertController = DOAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.changecustomAlertController()
        
        // customAlertController.overlayColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:0.1)
        
        let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
            action in
            
            print("hi")
        })
        
        let otherAction = DOAlertAction(title: otherButtonTitle, style: .default, handler:{
            
            action in
            
            
            let dicValue = [ "id" : self.idValue , "video_type" : self.typeVideo , "feedback" : "0"]
            
            
            self.getPrivateWebservic.getPrivateAcceptRejectWebService(urlString: self.getPrivateUrl.privateAcceptRejectAudioVideo(), dicData: dicValue as NSDictionary, callback:{
                
                (dicc,err)  in
                
                
                if ((dicc["status"] as! String).isEqual("OK"))
                    
                {
                    
                    DispatchQueue.main.async {
                        
                        
                        self.delegate?.sectionnumber(no: self.sectionNo)
                        self.navigationController?.popViewController(animated: true)
                       
                    }
                    
                }
                
                
            })

            
            
            
        })
        
        
        customAlertController.addAction(cancelAction)
        
        customAlertController.addAction(otherAction)
        
        
        self.present(customAlertController, animated: true, completion: nil)
        
}
    
    
    
    func changecustomAlertController()
    {
        
        customAlertController.alertView.layer.cornerRadius = 6.0
        
        customAlertController.alertViewBgColor = UIColor(red:255-255, green:255-255, blue:255-255, alpha:0.7)
        
        customAlertController.titleFont = UIFont(name: "Mosk", size: 17.0)
        customAlertController.titleTextColor = UIColor.green
        
        customAlertController.messageFont = UIFont(name: "Mosk", size: 12.0)
        
        
        customAlertController.messageTextColor = UIColor.white
        
        customAlertController.buttonFont[.cancel] = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.buttonBgColor[.cancel] = UIColor.getLightBlueColor()
        
        customAlertController.buttonFont[.default] = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.buttonBgColor[.default] = UIColor.getOrangeColor()
    
    }

    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
