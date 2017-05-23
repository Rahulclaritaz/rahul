//
//  XPAudioStopViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 15/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPAudioStopViewController: UIViewController {
    
    var commonRequestWebService = XPWebService ()
    var commonWebUrl = URLDirectory.audioDataUpload ()
    let pulsrator = Pulsator()
   @IBOutlet weak var retryButton = UIButton()
   @IBOutlet weak var xpressButton = UIButton()
    @IBOutlet weak var audioBGImage = UIImageView()
    @IBOutlet weak var audioBGBorderImage = UIImageView()
    @IBOutlet weak var audioBGAnimationOne = UIImageView()
    @IBOutlet weak var audioBGAnimationTwo = UIImageView()
    @IBOutlet weak var pulseAnimationView: UIView!
    var titleLabel = String ()
    var audioRecordURLString = String ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = titleLabel
        
        // this will remove the back button from the navigation bar
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        retryButton?.layer.cornerRadius = 25.0
        xpressButton?.layer.cornerRadius = 25.0
        audioBGImage?.clipsToBounds = true
        audioBGImage?.layer.cornerRadius = (self.audioBGImage?.frame.size.width)!/2
        audioBGImage?.layer.masksToBounds = false
        audioBGBorderImage?.isHidden = true
        audioBGAnimationOne?.isHidden = true
        audioBGAnimationTwo?.isHidden = true
//        audioBGBorderImage?.clipsToBounds = true
//        audioBGBorderImage?.layer.cornerRadius = (self.audioBGBorderImage?.frame.size.width)!/2
//        audioBGBorderImage?.clipsToBounds = true
        //        audioBGAnimationOne?.clipsToBounds = true
        //        audioBGAnimationOne?.layer.cornerRadius = (self.audioBGAnimationOne?.frame.size.width)!/2
        //        audioBGAnimationOne?.clipsToBounds = true
//        audioBGAnimationTwo?.isHidden = true
//        audioBGAnimationTwo?.clipsToBounds = true
//        audioBGAnimationTwo?.layer.cornerRadius = (self.audioBGAnimationTwo?.frame.size.width)!/2
//        audioBGAnimationTwo?.clipsToBounds = true
        pulseAnimationView?.layer.addSublayer(pulsrator)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // This will create the number of circle animation and radius
        pulsrator.numPulse = 5
        pulsrator.radius = 120
        pulsrator.animationDuration = 5
        pulsrator.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0).cgColor
        pulsrator.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pulsrator.stop()
    }
    
    @IBAction func retryButtonAction (sender : Any) {
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func xpressButtonAction (sender : Any) {
        sendRequestToWebService()
//        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPHomeDashBoardViewController")
//        self.present(storyBoard!, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendRequestToWebService () {
        
        var parameter = ["fileupload": audioRecordURLString,"from_email" : "rahul2338.sharma@rediffmail.com","to_email" : "rahulchennai213@gmail.com","title":"Awesome","tags":"AudioDemoCheck","privacy":"Public","country":"INDIA","language":"ENGLISH"]
        
        commonRequestWebService.getAudioResponse(urlString: commonWebUrl.url() , dictData: parameter as NSDictionary, callBack: {(audioResponseData , error) in
        
            print(audioResponseData)
            print(error)
        
        })
        
//        commonRequestWebService.getAudioResponse(urlString: commonWebUrl.url(), dictData: parameter as NSDictionary, callBack: {(audioResponseData , error) in
//        print(audioResponseData)
//            print(error)
//        
//        })
        
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
