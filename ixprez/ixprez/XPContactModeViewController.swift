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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        audioButton?.layer.cornerRadius = (audioButton?.frame.size.width)!/2
        audioButton?.layer.masksToBounds = true
        videoButton?.layer.cornerRadius = (videoButton?.frame.size.width)!/2
        videoButton?.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func audioButtonAction(sender : UIButton) {
        print("You click on audio")
    let audioViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPAudioViewController") as! XPAudioViewController
        audioViewController.emailAddressLabel.text = contactUserEmail
        audioViewController.selectContactAudio = true
        self.navigationController?.pushViewController(audioViewController, animated: true)
        self.view.removeFromSuperview()

        
        
    }
    
    @IBAction func videoButtonAction(sender : UIButton) {
         print("You click on video")
        let videoViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPCameraBaseViewController") as! XPCameraBaseViewController
        videoViewController.selectedUserEmail = contactUserEmail
        videoViewController.contactVideo = true
        self.navigationController?.pushViewController(videoViewController, animated: true)
        self.view.removeFromSuperview()

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
