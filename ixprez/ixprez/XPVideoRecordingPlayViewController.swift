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

enum CameraDirection {
    case front
    case back
}

class XPVideoRecordingPlayViewController: UIViewController,UINavigationControllerDelegate ,AVCaptureVideoDataOutputSampleBufferDelegate,RPPreviewViewControllerDelegate,AVCaptureFileOutputRecordingDelegate {
    @IBOutlet weak var videoButton = UIButton ()
   @IBOutlet weak var videoBGImage = UIImageView ()
    @IBOutlet weak var timerLabel = UILabel ()
    @IBOutlet weak var bottomView = UIView ()
    @IBOutlet weak var cameraSwitchButton = UIButton ()
    var currentDirection: CameraDirection = .front//or initial direction
    var count : Int = 40
    var videoTimer = Timer ()
    var isVideoButtonSelected: Bool = false
    var deviceInput = AVCaptureDeviceInput ()
    var deviceVideoFileOutput = AVCaptureMovieFileOutput()
    var cameraSession = AVCaptureSession()
    var imagePicker = UIImagePickerController ()
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoURLPath = NSURL()
    var titleString = String ()
    var usingFrontCamera = true
//    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserDefaults.standard.value(forKey: "feelingsLabelValue") as! String
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        videoBGImage?.clipsToBounds = true
        videoBGImage?.layer.cornerRadius = (videoBGImage?.frame.size.height)!/2
        videoBGImage?.layer.masksToBounds = true
        setupCameraSession()
        cameraSession.startRunning()
//        loadCamera()
//        previewLayer.frame = self.view.bounds
        self.view.layer.addSublayer(previewLayer)
        self.view.addSubview(bottomView!)
        
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        view.layer.addSublayer(previewLayer)
        cameraSession.removeOutput(deviceVideoFileOutput)
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
    
    // This will create the camera preview layer.
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height)
        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview?.videoGravity = AVLayerVideoGravityResize
        return preview!
    }()
    
    //Get the device (Front or Back)
    func getDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices: NSArray = AVCaptureDevice.devices() as! NSArray;
        for de in devices {
            let deviceConverted = de as! AVCaptureDevice
            if(deviceConverted.position == position){
                return deviceConverted
            }
        }
        return nil
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
        
        for device in videoDevices!{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.front {
                return device
            }
        }
        return nil
    }
    
    func getBackCamera() -> AVCaptureDevice{
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    }
    
    func loadCamera() {
        if(cameraSession == nil){
            cameraSession = AVCaptureSession()
            cameraSession.sessionPreset = AVCaptureSessionPresetPhoto
        }
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        captureDevice = (usingFrontCamera ? getFrontCamera() : getBackCamera())
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        for i : AVCaptureDeviceInput in (self.cameraSession.inputs as! [AVCaptureDeviceInput]){
            self.cameraSession.removeInput(i)
        }
        if error == nil && cameraSession.canAddInput(input) {
            cameraSession.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if cameraSession.canAddOutput(stillImageOutput) {
                cameraSession.addOutput(stillImageOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                //self.cameraPreviewSurface.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                
                DispatchQueue.main.async {
                    self.cameraSession.startRunning()
                }
                
                
            }
        }
        
        
        
    }
    
    func setupCameraSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
        
        
        do {
             deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let camera = getDevice(position: .front)
            let cameraBack = getDevice(position: .back)
            do {
                if currentDirection == .front {
                    deviceInput = try AVCaptureDeviceInput(device: camera)
                } else {
                    deviceInput = try AVCaptureDeviceInput(device: cameraBack)
                }
            } catch let error as NSError {
                print(error)
                //            input = nil
            }

            
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
    
    
    @IBAction func CameraSwitchButtonAction (sender: AnyObject) {
        usingFrontCamera = !usingFrontCamera
//        loadCamera()
        
        if (currentDirection == .front) {
            currentDirection = .back
        } else {
            currentDirection = .front
        }
        reloadCamera()
        setupCameraSession()
        self.view.layer.addSublayer(previewLayer)
        cameraSession.startRunning()
        self.view.addSubview(bottomView!)
    }
    
    func viewDidAppear(animated: Bool) {
        // normal code
        
        reloadCamera()
    }
    
    func reloadCamera() {
        cameraSession.stopRunning()
        previewLayer.removeFromSuperlayer()
        cameraSession.removeInput(deviceInput)
        let camera = getDevice(position: .front)
        let cameraBack = getDevice(position: .back)
        
        
        do {
            if currentDirection == .front {
                deviceInput = try AVCaptureDeviceInput(device: camera)
            } else {
                deviceInput = try AVCaptureDeviceInput(device: cameraBack)
            }
        } catch let error as NSError {
            print(error)
//            input = nil
        }
    /*    do {
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
    } */
        // camera loading code
//        cameraSession = AVCaptureSession()
//        cameraSession.sessionPreset = AVCaptureSessionPresetPhoto
//        var captureDevice:AVCaptureDevice! = nil
//        // var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//        if (camera == false) {
//            let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
//            
//            
//            for device in videoDevices!{
//                let device = device as! AVCaptureDevice
//                if device.position == AVCaptureDevicePosition.front {
//                    captureDevice = device
//                    break
//                }
//            }
//        } else {
//            var captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
//        }
//        
//        var error: NSError?
//        deviceInput = try AVCaptureDeviceInput(device: captureDevice)
//        let camera = getDevice(position: .front)
//        do {
//            deviceInput = try AVCaptureDeviceInput(device: camera)
//        } catch let error as NSError {
//            print(error)
//            //                deviceInput = nil
//        }
////        deviceInput = AVCaptureDeviceInput(device: captureDevice, error: &error)
//        
//        if error == nil && cameraSession!.canAddInput(input) {
//            cameraSession!.addInput(input)
//            
//          let  stillImageOutput = AVCaptureStillImageOutput()
//            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
//            if cameraSession.canAddOutput(stillImageOutput) {
//                cameraSession.addOutput(stillImageOutput)
//                
//                previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
//                previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
//                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//                previewLayer.addSublayer(previewLayer)
//                
//                cameraSession.startRunning()
//            }
//        }
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
           storyBoard.videoFileURLPath = videoURLPath
//        storyBoard.titleLabel = titleString
//        storyBoard.countLabelString = countStopValue as String
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
        var recordingDelegate:AVCaptureFileOutputRecordingDelegate? = self as! AVCaptureFileOutputRecordingDelegate
        
        
        self.cameraSession.addOutput(deviceVideoFileOutput)
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsURL.appendingPathComponent("sampleVideo.mp4")
        
        // Do recording and save the output to the `filePath`
        deviceVideoFileOutput.startRecording(toOutputFileURL: filePath, recordingDelegate: recordingDelegate)
        
//        let recorder = RPScreenRecorder.shared()
        
    /*    recorder.startRecording { [unowned self] (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(XPVideoRecordingPlayViewController.stopRecording))
            }
        } */
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
    
    public func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
        print("The start file output url is \(fileURL)")
        
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        
        videoURLPath = outputFileURL! as NSURL
        print("The finish file output url is \(outputFileURL)")
         print("The finish file1 output url is \(videoURLPath)")
        
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
