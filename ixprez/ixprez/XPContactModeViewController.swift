//
//  XPContactModeViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 28/07/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit


class XPContactModeViewController: UIViewController {
    
  @IBOutlet weak  var audioButton = UIButton ()
  @IBOutlet weak  var videoButton = UIButton ()
    var contactUserEmail = String ()
    var contactUserName = String ()
    var nameAndNumber = String ()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        audioButton?.layer.cornerRadius = (audioButton?.frame.size.width)!/2
        audioButton?.layer.masksToBounds = true
        videoButton?.layer.cornerRadius = (videoButton?.frame.size.width)!/2
        videoButton?.layer.masksToBounds = true
        nameAndNumber = contactUserName+" - "+contactUserEmail
        print("The name and number of user is \(nameAndNumber)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func audioButtonAction(sender : UIButton) {
        print("You click on audio")
        
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio) == AVAuthorizationStatus.authorized {
            
            let audioViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPAudioViewController") as! XPAudioViewController
            audioViewController.emailAddressLabel.text = self.nameAndNumber
            audioViewController.selectContactAudio = true
            self.navigationController?.pushViewController(audioViewController, animated: true)
            self.view.removeFromSuperview()
            
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { (granted : Bool) in
                if granted {
                    let audioViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPAudioViewController") as! XPAudioViewController
                    audioViewController.emailAddressLabel.text = self.nameAndNumber
                    audioViewController.selectContactAudio = true
                    self.navigationController?.pushViewController(audioViewController, animated: true)
                    self.view.removeFromSuperview()
                    
                } else {
                    let alertController = UIAlertController(title: "Alert", message: "You Don't Have Audio Microphone Access Permission. Check Your Setting", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil);
                }
            })
        }
    }
    
    @IBAction func videoButtonAction(sender : UIButton) {
         print("You click on video")
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized {
            // Already Authorised
            let videoViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPCameraBaseViewController") as! XPCameraBaseViewController
            videoViewController.selectedUserEmail = self.nameAndNumber
            videoViewController.contactVideo = true
            self.navigationController?.pushViewController(videoViewController, animated: true)
            self.view.removeFromSuperview()
            
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted : Bool) in
                if granted == true {
                    // User Granted
                    
                    let videoViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPCameraBaseViewController") as! XPCameraBaseViewController
                    videoViewController.selectedUserEmail = self.nameAndNumber
                    videoViewController.contactVideo = true
                    self.navigationController?.pushViewController(videoViewController, animated: true)
                    self.view.removeFromSuperview()
                } else {
                    // User Rejected
                    let alertController = UIAlertController(title: "Alert", message: "You Don't Have Camera Permission. Check Your Setting", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil);
                }
            })
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
