//
//  XPVideoRecordingPlayViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 20/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import AVFoundation
import ReplayKit

class XPVideoRecordingPlayViewController: UIViewController,UINavigationControllerDelegate ,AVCaptureVideoDataOutputSampleBufferDelegate,RPPreviewViewControllerDelegate {
    @IBOutlet weak var videoButton = UIButton ()
   @IBOutlet weak var videoBGImage = UIImageView ()
    @IBOutlet weak var timerLabel = UILabel ()
    var count : Int = 40
    var videoTimer = Timer ()
    var isVideoButtonSelected: Bool = false
    let cameraSession = AVCaptureSession()
    var imagePicker = UIImagePickerController ()
    var titleString = String ()
//    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        videoBGImage?.clipsToBounds = true
        videoBGImage?.layer.cornerRadius = (videoBGImage?.frame.size.height)!/2
        videoBGImage?.layer.masksToBounds = true
        setupCameraSession()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.layer.addSublayer(previewLayer)
        count = 40
        timerLabel?.text = "00:40"
        cameraSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraSession.stopRunning()
    }
    
//    lazy var cameraSession: AVCaptureSession = {
//        let s = AVCaptureSession()
//        s.sessionPreset = AVCaptureSessionPresetHigh
//        return s
//    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height - 250)
        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview?.videoGravity = AVLayerVideoGravityResize
        return preview!
    }()
    
    func setupCameraSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            cameraSession.beginConfiguration()
            
            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
            }
            
            cameraSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "com.invasivecode.videoQueue")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    @IBAction func recordVideo(sender: AnyObject) {
        guard isVideoButtonSelected else {
            
            videoBGImage?.backgroundColor = UIColor.orange
            videoButton?.setImage(UIImage(named: "MicrophonePlayingImage"), for: UIControlState.normal)
            isVideoButtonSelected = true
            videoTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("countDownTimer"), userInfo: nil, repeats: true)
            self.startRecording()
            return
        }
        videoTimer.invalidate()
         isVideoButtonSelected = false
        videoBGImage?.backgroundColor = UIColor.init(colorLiteralRed: 84.0/255.0, green: 198.0/255.0, blue: 231/255.0, alpha: 1.0)
        videoButton?.setImage(UIImage(named: "VideoCameraIcon"), for: UIControlState.normal)
        self.stopRecording()
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPVideoRecordingStopViewController") as! XPVideoRecordingStopViewController
        let countStopValue : String = (timerLabel?.text)!
        storyBoard.titleLabel = titleString
        storyBoard.countLabelString = countStopValue as String
        self.navigationController?.pushViewController(storyBoard, animated: true)
//        self.addChildViewController(storyBoard)
//        self.view.frame = self.view.frame
//        self.view.addSubview(storyBoard.view)
//        self.didMove(toParentViewController: storyBoard)

    }
    
    // This will count the Time
    func countDownTimer () {
        if (count > 0) {
            count -= 1
          timerLabel?.text = "00:" + String(count)
        } else  {
//            timerLabel?.text = String(timer)
            stopRecording()
        }
    }
    
    func startRecording() {
        
        let recorder = RPScreenRecorder.shared()
        
        recorder.startRecording { [unowned self] (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(XPVideoRecordingPlayViewController.stopRecording))
            }
        }
    }
    
    func stopRecording() {
        let recorder = RPScreenRecorder.shared()
        
        recorder.stopRecording { [unowned self] (preview, error) in
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: "startRecording")
            
            if let unwrappedPreview = preview {
//                unwrappedPreview.previewControllerDelegate = self as! RPPreviewViewControllerDelegate
//                self.present(unwrappedPreview, animated: true, completion: nil)
            }
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
