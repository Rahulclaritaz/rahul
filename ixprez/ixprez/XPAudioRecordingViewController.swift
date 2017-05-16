//
//  XPAudioRecordingViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 13/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import AVFoundation

class XPAudioRecordingViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    
    var isAudioButtonSelected : Bool = false
    let commomWebService = XPWebService()
    let commonWebURL = URLDirectory.audioDataUpload()
    @IBOutlet weak var audioBGImage = UIImageView()
    @IBOutlet weak var audioBGBorderImage = UIImageView()
    @IBOutlet weak var audioBGAnimationOne = UIImageView()
    @IBOutlet weak var audioBGAnimationTwo = UIImageView()
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var countLabel = UILabel ()
    @IBOutlet weak var audioRecordButton: UIButton!
    var countTime = 40
    var audioTimer = Timer ()
    var audioPlayer : AVAudioPlayer!
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
       
        // Audio recording Setup
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Allow")
                    } else {
                        print("Dont Allow")
                    }
                }
            }
        } catch {
            print("failed to record!")
        }
        
        // Audio Settings
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
    }
    
   override func viewWillAppear(_ animated: Bool) {
    isAudioButtonSelected = false
    audioTimer.invalidate()
    countTime = 40
    countLabel?.text = "00:40"
    
    }
    
    // This method will pass the audio path in NSURL
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        print(soundURL)
        return soundURL as NSURL?
    }
    
    // This method will record the voice
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            finishRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    
    // This method will stop the recording the voice
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        if success {
            print(success)
        } else {
            audioRecorder = nil
            print("Somthing Wrong.")
        }
    }
    
    @IBAction func BackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // This is Audio button action method.
    @IBAction func audioButtonAction(_ sender: Any) {
        
        guard (isAudioButtonSelected) else {
            isAudioButtonSelected = true
            audioBGImage?.backgroundColor = UIColor.orange
            audioButton.setImage(UIImage(named: "MicrophonePlayingImage"), for: UIControlState.normal)
            isAudioButtonSelected = true
            audioTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("countDownTimer"), userInfo: nil, repeats: true)
            self.startRecording()
            return
        }
        audioTimer.invalidate()
        isAudioButtonSelected = false
        audioBGImage?.backgroundColor = UIColor.init(colorLiteralRed: 84.0/255.0, green: 198.0/255.0, blue: 231/255.0, alpha: 1.0)
        audioButton.setImage(UIImage(named: "MicrophoneImage"), for: UIControlState.normal)
        self.finishRecording(success: true)
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPAudioStopViewController")
        self.navigationController?.pushViewController(storyBoard!, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This method will check the timer
    func countDownTimer () {
        if (countTime > 0) {
            countTime -= 1
            countLabel?.text = String(countTime)
        } else {
            finishRecording(success: false)
        }
        
        
    }
    
    // This method will check before moving to next controller audio recording is stop or not if not then will stop and move.
   override func viewWillDisappear(_ animated: Bool) {
    if (audioRecorder.isRecording) {
        finishRecording(success: true)
        audioTimer.invalidate()
        }
    
    }
    
    // Audio recording delegate method
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
//    func uploadAudioDataToServerWebService() {
//        let parameter = ["fileupload":"" ,"from_email":"","to_email":"","title":"","tags":"","privacy":"","country":"","language":""]
//        
//        commomWebService.uploadTheAudioData(urlString: commonWebURL.url() , dictData: parameter, callBack: {})
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
