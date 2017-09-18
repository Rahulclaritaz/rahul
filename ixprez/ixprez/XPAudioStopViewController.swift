//
//  XPAudioStopViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 15/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPAudioStopViewController: UIViewController {
    
    var commonRequestWebService = XPWebService ()
    var commonWebUrl = URLDirectory.audioDataUpload ()
    let pulsrator = Pulsator()
   @IBOutlet weak var retryButton = UIButton()
   @IBOutlet weak var xpressButton = UIButton()
    @IBOutlet weak var audioBGImage = UIImageView()
    @IBOutlet weak var audioBGBorderImage = UIImageView()
    @IBOutlet weak var audioBGAnimationOne = UIImageView()
    @IBOutlet weak var audioBGAnimationTwo = UIImageView()
    @IBOutlet weak var pulseAnimationView: UIView!
    @IBOutlet weak var userProfileView = UIImageView ()
    let dashBoardCommonService = XPWebService()
    let userPrifileURL = URLDirectory.UserProfile()
    var userEmail = String ()
    var titleLabel = String ()
    var audioRecordURLString : URL?
    var audioData = NSData()
    var registrationPage = RegistrationViewController ()
    var audioPage = XPAudioViewController ()
    var unregisteredXprezUserEmail = String ()
    var isUnregisteredUser = Bool ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel = UserDefaults.standard.value(forKey: "feelingsLabelValue") as! String
        unregisteredXprezUserEmail = UserDefaults.standard.value(forKey: "inviteXprezUser") as! String
        self.title = titleLabel
        print(registrationPage.defaults.string(forKey: "emailAddress"))
         print(audioPage.defaultValue.string(forKey: "toEmailAddress"))
         print(audioPage.defaultValue.string(forKey: "feelingsLabelValue"))
         print(audioPage.defaultValue.string(forKey: "moodLabelValue"))
        print(audioPage.defaultValue.string(forKey: "pickerStatus"))
        print(audioPage.defaultValue.string(forKey: "countryName"))
        print(audioPage.defaultValue.string(forKey: "languageName"))
        userProfileView?.layer.cornerRadius = (userProfileView?.frame.size.width)!/2
        userProfileView?.layer.masksToBounds = true
        userEmail = UserDefaults.standard.value(forKey: "emailAddress") as! String
        self.getUserProfile()
        // this will remove the back button from the navigation bar
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        retryButton?.layer.cornerRadius = 25.0
        xpressButton?.layer.cornerRadius = 25.0
        audioBGImage?.clipsToBounds = true
        audioBGImage?.layer.cornerRadius = (self.audioBGImage?.frame.size.width)!/2
        audioBGImage?.layer.masksToBounds = false
        audioBGBorderImage?.isHidden = true
        audioBGAnimationOne?.isHidden = true
        audioBGAnimationTwo?.isHidden = true
        
        pulseAnimationView?.layer.addSublayer(pulsrator)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // This will create the number of circle animation and radius
        pulsrator.numPulse = 5
        pulsrator.radius = 120
        pulsrator.animationDuration = 5
        pulsrator.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0).cgColor
        pulsrator.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pulsrator.stop()
    }
    
    func getUserProfile() {
        
        let parameter = [ "email_id" : userEmail]
        
        dashBoardCommonService.getUserProfileWebService(urlString: userPrifileURL.url(), dicData: parameter as NSDictionary, callback: {(userprofiledata , error) in
            let imageURL: String = userprofiledata.value(forKey: "profile_image") as! String
            print(imageURL)
            
            let urlString = imageURL.replacingOccurrences(of: "/root/cpanel3-skel/public_html/Xpress", with: "http://103.235.104.118:3000")
            
            let url = NSURL(string: urlString)
            
            let session = URLSession.shared
            
            let taskData = session.dataTask(with: url! as URL, completionHandler: {(data,response,error) -> Void  in
                
                if (data != nil)
                {
                    
                    DispatchQueue.main.async {
                        
                        self.userProfileView?.image = UIImage(data: data!)
                        
                    }
                }
            })
            
            
            taskData.resume()
        })
        
        
        
    }
    
    @IBAction func retryButtonAction (sender : Any) {
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func xpressButtonAction (sender : Any) {
        sendRequestToWebService()
//        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPHomeDashBoardViewController")
//        self.present(storyBoard!, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendRequestToWebService ()
    {
   
    do
    {
     audioData = try NSData(contentsOf: audioRecordURLString!)
    }
    
    catch
    {
        print("your audio data have problem.")
    }
    
                
        let myUrl = NSURL(string : commonWebUrl.url())
        var requestUrl = URLRequest(url: myUrl! as URL)
        
        // Setting the Content - type in HTTP header
        let boundary = generateBoundaryString()
        requestUrl.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        // This will add the authentication token on the header of the API.
        let authtoken = UserDefaults.standard.value(forKey: "authToken")
        print("The authtoken is \(authtoken)")
        requestUrl.addValue(authtoken as! String, forHTTPHeaderField: "authtoken")
        
        // Add the parameter
         
        let body = NSMutableData()
        
        // This is the From email parameter add in the web service.
        if (registrationPage.defaults.string(forKey: "emailAddress") == nil) {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"from_email\"\r\n\r\n")
            body.appendString("rahul@claritaz.com")
            body.appendString("\r\n")
        } else {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"from_email\"\r\n\r\n")
            body.appendString(registrationPage.defaults.string(forKey: "emailAddress")!)
            body.appendString("\r\n")
        }
        
        
        // This is the to email parameter add in the web service.
        if (audioPage.defaultValue.string(forKey: "toEmailAddress") == nil)
        {
            print("You don't have email because u select public")
        } else
        {
            // Here will check register ixprez user or not. If not then will pass email id [Type in pop up] other wise will pass [ - phoneNumber] in to_email parameter.
            isUnregisteredUser = (UserDefaults.standard.value(forKey: "isUnregisterXprezUser") != nil)
            if (isUnregisteredUser) {
                UserDefaults.standard.set(false, forKey: "isUnregisterXprezUser")
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"to_email\"\r\n\r\n")
                body.appendString(audioPage.defaultValue.string(forKey: "inviteXprezUser")!)
                body.appendString("\r\n")
            } else {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"to_email\"\r\n\r\n")
                body.appendString(audioPage.defaultValue.string(forKey: "toEmailAddress")!)
                body.appendString("\r\n")
            }
            
        }
 
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"title\"\r\n\r\n")
            body.appendString(audioPage.defaultValue.string(forKey: "feelingsLabelValue")!)
            body.appendString("\r\n")
       
        if (audioPage.defaultValue.string(forKey: "moodLabelValue") == nil)
        {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"tags\"\r\n\r\n")
            body.appendString("hello")
            body.appendString("\r\n")
            print("You don't have tags because u select private")
        } else
        {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"tags\"\r\n\r\n")
            body.appendString(audioPage.defaultValue.string(forKey: "moodLabelValue")!)
            body.appendString("\r\n")
        }
        // This is the Picker status value  parameter add in the web service.
        
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"privacy\"\r\n\r\n")
        body.appendString(audioPage.defaultValue.string(forKey: "pickerStatus")!)
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
        
        // This is the recorded audio parameter add in the web service.
        body.appendString("--\(boundary)\r\n")
//        body.appendString("Content-Disposition: form-data; name=\"fileupload\"; filename=\"Documents/Movie.mp4\"\r\n")
//        body.appendString("Content-Type: video/mp4\r\n\r\n")
        body.appendString("Content-Disposition: form-data; name=\"fileupload\"; filename=\"MyAudioMemo.mp3\"\r\n")
        body.appendString("Content-Type: audio/mp3\r\n\r\n")
        //let urlData = NSData(data: audioData as Data)
        body.append(audioData as Data)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")

        requestUrl.httpBody = body as Data
        
        requestUrl.httpMethod = "POST"
        
           // let contentType = String(format: "multipart/form-data; boundary=%@", boundary)
            
           // requestUrl.setValue(contentType, forHTTPHeaderField: "Content-Type")
    
            let session = URLSession.shared
        let dataTask = session.dataTask(with: requestUrl , completionHandler:
        {
            
            (data,response,error) -> Void in
            
            if (data != nil && error == nil) {
                
                do {
                    
                    let jsonData : NSDictionary  = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    print("mathan check audio Video",jsonData)
                    let jsonResponseStatus : String =  jsonData.value(forKey: "status") as! String
                    print("mathan check audio Video",jsonResponseStatus)
                    
                    if (jsonResponseStatus == "Failed")
                        
                    {
                        let alert = UIAlertController(title: nil, message:  "", preferredStyle: .actionSheet)
                        
                        let attributedString1 = NSAttributedString(string: "Audio failed to uploaded to the server, Please upload again", attributes: [
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
                        
                        
                        
                        let attributedString1 = NSAttributedString(string: "Audio Successfully uploaded to the server", attributes: [
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
                } catch
                {
                    
                }
                
            }
            
            else {
                
                print("Data Nil")
                
                return
            }
        })
        
        dataTask.resume()
    }
    
    
        
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createBodyWithParameters(parameters : [String: Any]?, boundary: String) ->
        NSData{
            let body = NSMutableData ()
            
            if parameters != nil {
                for (key, value) in parameters! {
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                }
            }
            
            return body
            
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

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
