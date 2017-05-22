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
    
    let visualizerAnimationDuration = 0.01
    let pulsrator = Pulsator()
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
    @IBOutlet weak var pulseAnimationView: UIView!
    var countTime = 40
    var audioTimer = Timer ()
    var audioPlayer : AVAudioPlayer!
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    var visualizerTimer: Timer! = Timer ()
    var lowPassResults1:Double! = 0.0
    var lowPassResult: Double! = 0.0
    var audioVisualizer: ATAudioVisualizer!
    @IBOutlet weak var visualizerView: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Cool"
        audioButton.setImage(UIImage(named: "MicrophoneImage"), for: UIControlState.normal)
        self.navigationController?.navigationBar.tintColor = UIColor.white
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
        self.initObservers()
//        self.initAudioPlayer()
        self.initAudioVisualizer()
       
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
    
    func initObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        
    }
    
    func initAudioPlayer() {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "Boys Edit Final", ofType: "mp3")!)
        let error: NSError?
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
        }
        catch let error {
            print(error)
        }
        audioPlayer.isMeteringEnabled = true
        self.audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
    }
    
    
    func initAudioVisualizer() {
        var frame = visualizerView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        let visualizerColor = UIColor(red: 255.0 / 255.0, green: 84.0 / 255.0, blue: 116.0 / 255.0, alpha: 1.0)
        self.audioVisualizer = ATAudioVisualizer(barsNumber: 11, frame: frame, andColor: visualizerColor)
        visualizerView.addSubview(audioVisualizer)
    }
    
    func didEnterBackground()
    {
        self.stopAudioVisualizer()
    }
    
    func didEnterForeground()
    {
        if (isAudioButtonSelected)
        {
            self.startAudioVisualizer()
        }
    }
    
    func startAudioVisualizer() {
        
        if visualizerTimer != nil
        {
            visualizerTimer.invalidate()
            visualizerTimer = nil
            
        }
        visualizerTimer = Timer.scheduledTimer(timeInterval: visualizerAnimationDuration, target: self, selector: #selector(visualizerTimerChanged), userInfo: nil, repeats: true)
        
    }
    
    
    func visualizerTimerChanged(_ timer:CADisplayLink)
    {
        audioRecorder.updateMeters()
        let ALPHA: Double = 1.05
        let averagePower: Double =  Double(audioRecorder.averagePower(forChannel: 0))
        let averagePowerForChannel: Double = pow(10, (0.05 * averagePower))
        lowPassResult = ALPHA * averagePowerForChannel + (1.0 - ALPHA) * lowPassResult
        let averagePowerForChannel1: Double = pow(10, (0.05 * Double(audioRecorder.averagePower(forChannel: 1))))
        lowPassResults1 = ALPHA * averagePowerForChannel1 + (1.0 - ALPHA) * lowPassResults1
        audioVisualizer.animate(withChannel0Level: self._normalizedPowerLevelFromDecibels(audioRecorder.averagePower(forChannel: 0)), andChannel1Level: self._normalizedPowerLevelFromDecibels(audioRecorder.averagePower(forChannel: 1)))
//        self.updateLabels()
        
    }
    
//    func updateLabels() {
//        self.currentTimeLabel.text! = self.convertSeconds(Float(audioPlayer.currentTime))
//        self.remainingTimeLabel.text! = self.convertSeconds(Float(audioPlayer.duration) - Float(audioPlayer.currentTime))
//    }
    
    
//    func convertSeconds(_ secs: Float) -> String {
//        var currentSecs = secs
//        if currentSecs < 0.1 {
//            currentSecs = 0
//        }
//        var totalSeconds = Int(secs)
//        if currentSecs > 0.45 {
//            totalSeconds += 1
//        }
//        let seconds = totalSeconds % 60
//        let minutes = (totalSeconds / 60) % 60
//        let hours = totalSeconds / 3600
//        if hours > 0 {
//            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//        }
//        return String(format: "%02d:%02d", minutes, seconds)
//    }
    
    func _normalizedPowerLevelFromDecibels(_ decibels: Float) -> Float {
        if decibels < -60.0 || decibels == 0.0 {
            return 0.0
        }
        return powf((powf(10.0, 0.05 * decibels) - powf(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 2.0)
    }
    
    func stopAudioVisualizer()
    {
        if visualizerTimer != nil
        {
            visualizerTimer.invalidate()
            visualizerTimer = nil
            
        }
        audioVisualizer.stop()
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
//        playPauseButton.setImage(UIImage(named: "play_")!, for: UIControlState())
//        playPauseButton.setImage(UIImage(named: "play")!, for: .highlighted)
//        playPauseButton.isSelected = false
//        self.currentTimeLabel.text! = "00:00"
//        self.remainingTimeLabel.text! = self.convertSeconds(Float(audioPlayer.duration))
//        self.stopAudioVisualizer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("audioPlayerDecodeErrorDidOccur")
//        playPauseButton.setImage(UIImage(named: "play_")!, for: UIControlState())
//        playPauseButton.setImage(UIImage(named: "play")!, for: .highlighted)
//        playPauseButton.isSelected = false
//        self.currentTimeLabel.text! = "00:00"
//        self.remainingTimeLabel.text! = "00:00"
//        self.stopAudioVisualizer()
    }

    
    
   override func viewWillAppear(_ animated: Bool) {
    isAudioButtonSelected = false
    audioTimer.invalidate()
    countTime = 40
    countLabel?.text = "00:40"
    
    // This will create the number of circle animation and radius
    pulsrator.numPulse = 5
    pulsrator.radius = 120
    pulsrator.animationDuration = 5
    pulsrator.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0).cgColor
    pulsrator.start()
    self.stopAudioVisualizer()
    
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
//            isAudioButtonSelected = true
            audioTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("countDownTimer"), userInfo: nil, repeats: true)
             self.startAudioVisualizer()
            self.startRecording()
            return
        }
        audioTimer.invalidate()
        isAudioButtonSelected = false
        audioBGImage?.backgroundColor = UIColor.init(colorLiteralRed: 84.0/255.0, green: 198.0/255.0, blue: 231/255.0, alpha: 1.0)
        audioButton.setImage(UIImage(named: "MicrophoneImage"), for: UIControlState.normal)
        self.stopAudioVisualizer()
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
            countLabel?.text = "00:" + String(countTime)
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
    pulsrator.stop()
    
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
