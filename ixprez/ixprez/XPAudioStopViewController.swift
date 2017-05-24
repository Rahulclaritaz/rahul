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
    var titleLabel = String ()
    var audioRecordURLString = Data ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = titleLabel
        
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
    
    @IBAction func retryButtonAction (sender : Any) {
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBAction func xpressButtonAction (sender : Any) {
        sendRequestToWebService()
//        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPHomeDashBoardViewController")
//        self.present(storyBoard!, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendRequestToWebService () {
        
        var parameter = ["fileupload": audioRecordURLString,"from_email" : "jnjaga24@gmail.com","to_email" : "rahulchennai213@gmail.com","title":"Awesome","tags":"AudioDemoCheck","privacy":"Public","country":"INDIA","language":"ENGLISH"] as [String : Any]
        
        let myUrl = NSURL(string : commonWebUrl.url())
        var requestUrl = URLRequest(url: myUrl! as URL)
        requestUrl.httpMethod = "POST";
        let boundary = generateBoundaryString()
        
        requestUrl.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        requestUrl.httpBody = createBodyWithParameters(parameters: parameter as! [String : Any], boundary: boundary) as Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: requestUrl , completionHandler:
        {
            
            (data,response,error) -> Void in
            
            if (data != nil && error == nil) {
                
                do {
                    
                    let jsonData : NSDictionary  = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    print(jsonData)
                    var jsonResponseStatus : String =  jsonData.value(forKey: "status") as! String
                    
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
    
//        commonRequestWebService.getAudioResponse(urlString: commonWebUrl.url(), dictData: parameter as NSDictionary, callBack: {(audioResponseData , error) in
//        print(audioResponseData)
//            print(error)
//        
//        })
        
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
