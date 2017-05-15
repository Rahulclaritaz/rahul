//
//  XPAudioRecordingViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 13/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPAudioRecordingViewController: UIViewController {
    
    var isAudioButtonSelected : Bool = false
    @IBOutlet weak var audioBGImage = UIImageView()
    @IBOutlet weak var audioBGBorderImage = UIImageView()
    @IBOutlet weak var audioBGAnimationOne = UIImageView()
    @IBOutlet weak var audioBGAnimationTwo = UIImageView()
    @IBOutlet weak var audioButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Cool"
        audioButton.setImage(UIImage(named: "MicrophoneImage"), for: UIControlState.normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
        

        // Do any additional setup after loading the view.
        
        
    }
    
   override func viewWillAppear(_ animated: Bool) {
    isAudioButtonSelected = false
    }
    
    @IBAction func BackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func audioButtonAction(_ sender: Any) {
        
        guard (isAudioButtonSelected) else {
            isAudioButtonSelected = true
            audioBGImage?.backgroundColor = UIColor.orange
            audioButton.setImage(UIImage(named: "MicrophonePlayingImage"), for: UIControlState.normal)
            isAudioButtonSelected = true
            return
        }
        isAudioButtonSelected = false
        audioBGImage?.backgroundColor = UIColor.init(colorLiteralRed: 84.0/255.0, green: 198.0/255.0, blue: 231/255.0, alpha: 1.0)
        audioButton.setImage(UIImage(named: "MicrophoneImage"), for: UIControlState.normal)
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPAudioStopViewController")
        self.navigationController?.pushViewController(storyBoard!, animated: true)
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
