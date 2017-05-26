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
    var titleLabel = String ()
    var registrationPage = RegistrationViewController ()
    var videoPage = XPVideoViewController ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = titleLabel
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
        body.appendString("Content-Disposition: form-data; name=\"fileupload\"; filename=\"sampleVideo.mp4\"\r\n")
        body.appendString("Content-Type: video/mp4\r\n\r\n")
//        var urlData = NSData(data: videoData as! Data)
//        body.append(urlData as Data)
        body.appendString("\r\n")
        
        
        // This is the recorded Video parameter add in the web service.
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"thumbnail\"; filename=\"s.jpg\"\r\n")
        body.appendString("Content-Type: image/png\r\n\r\n")
//        var urlData = NSData(data:  as! Data)
//        body.append(urlData as Data)
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
                        return
                    } else {
                        
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
