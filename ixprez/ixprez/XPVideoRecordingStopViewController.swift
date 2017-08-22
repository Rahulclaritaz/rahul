//
//  XPVideoRecordingStopViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 20/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import AVFoundation

class XPVideoRecordingStopViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    var commonRequsetResponseService = XPWebService ()
    var commonWebURL = URLDirectory.videoDataUpload()
    @IBOutlet weak var retryButton = UIButton()
    @IBOutlet weak var xpressButton = UIButton()
    @IBOutlet weak var videoBGImage = UIImageView()
    @IBOutlet weak var countLabel = UILabel ()
    var thumbImageView = UIImage()
    var videoThumbnailImage = NSData ()
    var cameraSession = AVCaptureSession ()
    var deviceInput = AVCaptureDeviceInput ()
    var urlData = NSData ()
    var videoData = NSData()
    
    var countLabelString = String ()
    var titleLabel = String ()
    var registrationPage = RegistrationViewController ()
    var videoPage = XPVideoViewController ()
   @IBOutlet weak var bootomToolBarView = UIView ()
    var videoFileURLPath : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("The url path of the video file is \(videoFileURLPath)")
        self.title = UserDefaults.standard.value(forKey: "feelingsLabelValue") as! String
//        self.countLabel?.text = countLabelString
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        retryButton?.layer.cornerRadius = 25.0
        xpressButton?.layer.cornerRadius = 25.0
        videoBGImage?.clipsToBounds = true
        videoBGImage?.layer.cornerRadius = (videoBGImage?.frame.size.height)!/2
        videoBGImage?.layer.masksToBounds = false
        // this will create the thumbnail image for the video.
//        var err: NSError? = nil
//        let asset = AVURLAsset(url: videoFileURLPath as URL)
//        let imgGenerator = AVAssetImageGenerator(asset: asset)
//        //        let cgImage = imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil, error: &err)
//        do {
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
//            thumbImageView = UIImage(cgImage: cgImage)
//            //            thumbImageView = UIImageView(image: uiImage)
//        } catch {
//            
//        }
//        videoThumbnailImage = UIImagePNGRepresentation(thumbImageView)! as NSData
//        urlData = NSData(data: videoThumbnailImage as Data )
        
        setupCameraSession()
        cameraSession.startRunning()
        self.view.layer.addSublayer(previewLayer)
        self.view.addSubview(bootomToolBarView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height)
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
            
            let queue = DispatchQueue(label: "ixprez")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    // This method will cancel the record and return back to previous view controller.
    @IBAction func retryButtonAction (sender : Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // This method will send to the request parameter to the server and move to dashboard main view.
    @IBAction func xpressButtonAction (sender : Any) {
        
        uploadVideoToWebService()
//                let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPHomeDashBoardViewController")
//                self.present(storyBoard!, animated: true, completion: nil)
    }
    
    func uploadVideoToWebService () {
        
        do {
           videoData = try NSData(contentsOf: videoFileURLPath!)
        }
        
        catch {
            print(" video data have problem.")
        }
        
        
//         var videoData = try NSData(contentsOf: videoFileURLPath!)
        
//        var videoData = NSData(contentsOf: videoRecordURLString!)
        
        //        var parameter = ["fileupload": audioData,"from_email" : "jnjaga24@gmail.com","to_email" : "rahulchennai213@gmail.com","title":"Awesome","tags":"AudioDemoCheck","privacy":"Public","country":"INDIA","language":"ENGLISH"] as [String : Any]
        
        let myUrl = NSURL(string : commonWebURL.url())
        var requestUrl = URLRequest(url: myUrl! as URL)
        
        // Setting the Content - type in HTTP header
        let boundary = generateBoundaryString()
        requestUrl.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Add the parameter
        //        requestUrl.httpBody = createBodyWithParameters(parameters: parameter as! [String : Any], boundary: boundary) as Data
        var body = NSMutableData()
        
        // This is the From email parameter add in the web service.
        if (registrationPage.defaults.string(forKey: "emailAddress") == nil) {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"from_email\"\r\n\r\n")
            body.appendString("mathan6@gmail.com")
            body.appendString("\r\n")
        } else {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"from_email\"\r\n\r\n")
            body.appendString(registrationPage.defaults.string(forKey: "emailAddress")!)
            body.appendString("\r\n")
        }
        
        
        // This is the to email parameter add in the web service.
        if (videoPage.defaultValue.string(forKey: "toEmailAddress") == nil) {
            print("You don't have email because u select public")
        } else {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"to_email\"\r\n\r\n")
            body.appendString(videoPage.defaultValue.string(forKey: "toEmailAddress")!)
            body.appendString("\r\n")
        }
        
        
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"title\"\r\n\r\n")
        body.appendString(videoPage.defaultValue.string(forKey: "feelingsLabelValue")!)
        body.appendString("\r\n")
        
        
        if (videoPage.defaultValue.string(forKey: "moodLabelValue") == nil) {
            print("You don't have tags because u select private")
        } else {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"tags\"\r\n\r\n")
            body.appendString(videoPage.defaultValue.string(forKey: "moodLabelValue")!)
            body.appendString("\r\n")
        }
        
        
        // This is the Picker status value  parameter add in the web service.
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"privacy\"\r\n\r\n")
        body.appendString(videoPage.defaultValue.string(forKey: "pickerStatus")!)
        body.appendString("\r\n")
        
        // This is the country parameter add in the web service.
        if (registrationPage.defaults.string(forKey: "countryName") == nil) {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"country\"\r\n\r\n")
            body.appendString("India")
            body.appendString("\r\n")
            
        } else {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"country\"\r\n\r\n")
            body.appendString(registrationPage.defaults.string(forKey: "countryName")!)
            body.appendString("\r\n")
        }
        
        
        
        // This is the language parameter add in the web service.
        
        if (registrationPage.defaults.string(forKey: "languageName") == nil) {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"language\"\r\n\r\n")
            body.appendString("English")
            body.appendString("\r\n")
            
        } else {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"language\"\r\n\r\n")
            body.appendString(registrationPage.defaults.string(forKey: "languageName")!)
            body.appendString("\r\n")
        }
        
        // This is the recorded Video parameter add in the web service.
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"fileupload\"; filename=\"Documents/Movie.mp4\"\r\n")
        body.appendString("Content-Type: video/mp4\r\n\r\n")
        let urlData = NSData(data: videoData as Data)
        body.append(urlData as Data)
        body.appendString("\r\n")
        
        
        // This is the recorded Video parameter add in the web service.
        
//        var err: NSError? = nil
//        let asset = AVURLAsset(url: videoFileURLPath as URL)
//        let imgGenerator = AVAssetImageGenerator(asset: asset)
////        let cgImage = imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil, error: &err)
//        do {
//        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
//            thumbImageView = UIImage(cgImage: cgImage)
////            thumbImageView = UIImageView(image: uiImage)
//        } catch {
//            
//        }
//        
//        videoThumbnailImage = UIImagePNGRepresentation(thumbImageView)! as NSData
        // !! check the error before proceeding
//        let uiImage = UIImage(CGImage: cgImage)
//        let imageView = UIImageView(image: uiImage)
        // lay out this image view, or if it already exists, set its image property to uiImage
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"thumbnail\"; filename=\"s.jpg\"\r\n")
        body.appendString("Content-Type: image/png\r\n\r\n")
        body.append((urlData as NSData) as Data)
        body.appendString("\r\n")
        
        requestUrl.httpBody = body as Data
        
        requestUrl.httpMethod = "POST";
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: requestUrl , completionHandler:
        {
            
            (data,response,error) -> Void in
            
            if (data != nil && error == nil) {
                
                do {
                    
                    let jsonData : NSDictionary  = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    print(jsonData)
                    var jsonResponseStatus : String =  jsonData.value(forKey: "status") as! String
                    print(jsonResponseStatus)
                    
                    if (jsonResponseStatus == "Failed") {
                        
                        let alert = UIAlertController(title: nil, message:  "", preferredStyle: .actionSheet)
                        
                        let attributedString1 = NSAttributedString(string: "Video failed to uploaded to the server, Please upload again", attributes: [
                            NSFontAttributeName : UIFont.xprezMediumFontOfsize(size: 15)  , //your font here
                            NSForegroundColorAttributeName : UIColor.white
                            ])
                        
                        alert.setValue(attributedString1, forKey: "attributedMessage")
                        
                        let subView1 = alert.view.subviews.first! as UIView
                        let subView2 = subView1.subviews.first! as UIView
                        let view = subView2.subviews.first! as UIView
                        
                        
                        view.backgroundColor = UIColor(red: 255-255, green: 255-255, blue: 255-255, alpha: 0.8)
                        
                        alert.view.clipsToBounds = true
                        
                        DispatchQueue.main.async
                            {
                                
                                alert.show()
                        }

                        return
                    } else {
                        let alert = UIAlertController(title: nil, message:  "", preferredStyle: .actionSheet)
                        
                        let attributedString1 = NSAttributedString(string: "Video Successfully uploaded to the server", attributes: [
                            NSFontAttributeName : UIFont.xprezMediumFontOfsize(size: 15)  , //your font here
                            NSForegroundColorAttributeName : UIColor.white
                            ])
                        
                        alert.setValue(attributedString1, forKey: "attributedMessage")
                        
                        let subView1 = alert.view.subviews.first! as UIView
                        let subView2 = subView1.subviews.first! as UIView
                        let view = subView2.subviews.first! as UIView
                        
                        
                        view.backgroundColor = UIColor(red: 255-255, green: 255-255, blue: 255-255, alpha: 0.8)
                        
                        alert.view.clipsToBounds = true
                        
                        DispatchQueue.main.async
                            {
                                
                                alert.show()
                        }
 
                    }
                } catch {
                    
                }
                
            } else {
                return
            }
        })
        
        dataTask.resume()
        //        commonRequestWebService.getAudioResponse(urlString: commonWebUrl.url() , dictData: parameter as NSDictionary, callBack: {(audioResponseData , error) in
        //
        //            print(audioResponseData)
        //            print(error)
        //
        //        })
        
        
        
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
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
