//
//  XPAudioStopViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 15/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPAudioStopViewController: UIViewController {
   @IBOutlet weak var retryButton = UIButton()
   @IBOutlet weak var xpressButton = UIButton()
    @IBOutlet weak var audioBGImage = UIImageView()
    @IBOutlet weak var audioBGBorderImage = UIImageView()
    @IBOutlet weak var audioBGAnimationOne = UIImageView()
    @IBOutlet weak var audioBGAnimationTwo = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Cool"
        retryButton?.layer.cornerRadius = 20.0
        xpressButton?.layer.cornerRadius = 20.0
        audioBGImage?.clipsToBounds = true
        audioBGImage?.layer.cornerRadius = (self.audioBGImage?.frame.size.width)!/2
        audioBGImage?.layer.masksToBounds = false
        audioBGBorderImage?.clipsToBounds = true
        audioBGBorderImage?.layer.cornerRadius = (self.audioBGBorderImage?.frame.size.width)!/2
        audioBGBorderImage?.clipsToBounds = true
        //        audioBGAnimationOne?.clipsToBounds = true
        //        audioBGAnimationOne?.layer.cornerRadius = (self.audioBGAnimationOne?.frame.size.width)!/2
        //        audioBGAnimationOne?.clipsToBounds = true
        audioBGAnimationTwo?.clipsToBounds = true
        audioBGAnimationTwo?.layer.cornerRadius = (self.audioBGAnimationTwo?.frame.size.width)!/2
        audioBGAnimationTwo?.clipsToBounds = true
        
    }
    
    @IBAction func retryButtonAction (sender : Any) {
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func xpressButtonAction (sender : Any) {
//        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPHomeDashBoardViewController")
//        self.present(storyBoard!, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
