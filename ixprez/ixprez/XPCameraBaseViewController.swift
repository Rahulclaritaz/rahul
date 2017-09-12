//
//  XPCameraBaseViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 27/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import AVFoundation



class XPCameraBaseViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {

    var  popController = XPVideoViewController()
    var cameraSession =  AVCaptureSession ()
    var imagePicker = UIImagePickerController ()
    var selectedUserEmail = String ()
    var selectedUserName = String ()
    var selectedNameAndNumber = String ()
    var contactVideo = Bool ()
    var contactUserEmail = Bool ()
    var emailAddressLabel = UILabel ()
    var nameAndNumber = String ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedUserEmail)
        self.title = "Xpress"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target:nil, action:nil)
        self.selectedNameAndNumber = selectedUserEmail
        setupCameraSession()
        cameraSession.startRunning()
        self.view.layer.addSublayer(previewLayer)
        
    }
    
    @IBAction func backButtonAction (_ sender : Any) {
        guard (contactVideo) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPVideoViewController") as! XPVideoViewController
        self.addChildViewController(popController)
//        popController.videoEmailDelegate = self
        popController.view.frame = self.view.frame
        popController.emailAddressLabel.text = selectedNameAndNumber
        popController.selectContactVideo = contactVideo
        self.view.addSubview(popController.view)
        self.didMove(toParentViewController: self)
        
    }
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height)
        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview?.videoGravity = AVLayerVideoGravityResize
        return preview!
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            
            let queue = DispatchQueue(label: "ixprez")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        popController.view.removeFromSuperview()
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

//extension XPCameraBaseViewController : videoViewEmailDelegate {
//    func passVideoEmail(email: String) {
//        self.contactUserEmail = true
//        self.emailAddressLabel.text = email
//    }
//}

extension XPCameraBaseViewController : contactEmailDelegate {
    func passEmailToAudioAndVideo(email: String, name: String) {
        self.contactUserEmail = true
        self.nameAndNumber = name+" - "+email
        self.emailAddressLabel.text = email
    }
}
