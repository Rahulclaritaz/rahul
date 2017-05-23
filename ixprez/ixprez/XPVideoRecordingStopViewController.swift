//
//  XPVideoRecordingStopViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 20/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPVideoRecordingStopViewController: UIViewController {
    var commonRequsetResponseService = XPWebService ()
    var commonWebURL = URLDirectory.videoDataUpload()
    @IBOutlet weak var retryButton = UIButton()
    @IBOutlet weak var xpressButton = UIButton()
    @IBOutlet weak var videoBGImage = UIImageView()
    @IBOutlet weak var countLabel = UILabel ()
    var countLabelString = String ()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Cool"
        self.countLabel?.text = countLabelString
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        retryButton?.layer.cornerRadius = 25.0
        xpressButton?.layer.cornerRadius = 25.0
        videoBGImage?.clipsToBounds = true
        videoBGImage?.layer.cornerRadius = (videoBGImage?.frame.size.height)!/2
        videoBGImage?.layer.masksToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func retryButtonAction (sender : Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func xpressButtonAction (sender : Any) {
        uploadVideoToWebService()
//                let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPHomeDashBoardViewController")
//                self.present(storyBoard!, animated: true, completion: nil)
    }
    
    func uploadVideoToWebService () {
        
        var parameter = ["fileupload": "","from_email" : "","to_email" : "","title":"","tags":"","privacy":"","country":"","language":"","thumbnail":""]
        commonRequsetResponseService.getVideoResponse(urlString: commonWebURL.url(), dictData: parameter as NSDictionary, callBack: {(videoResponseData , error) in
        
            
            print(videoResponseData)
            print(error)
        
        
        })
        
        
        
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
