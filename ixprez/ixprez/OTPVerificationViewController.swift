//
//  OTPVerificationViewController.swift
//  ixprez
//
//  Created by Quad on 4/27/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//
//Confirmation code has been send to mathan6@gmail.complease Click resend if the mail failed to deliver.

import UIKit
import FirebaseAuth

class OTPVerificationViewController: UIViewController,UITextFieldDelegate
{
    
    
    @IBOutlet weak var lblOtpDescription: UILabel!
    
    @IBOutlet var btnChangeEmail: UIButton!
    
    @IBOutlet var designView: UIView!
    
    @IBOutlet var btnDone: UIButton!
    
    @IBOutlet var txtOTP: UITextField!
    var dataArrayValue = [String : AnyObject]()
    
    var authtoken : String = ""
    
    var parameter = [String : Any]()
    var userName : String = ""
    var emailId : String = ""
    var country : String = ""
    var language : String = ""
    var phoneNumber : String = ""
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let getOTPClass = XPWebService()
//    let getOTPUrl = URLDirectory.OTPVerification()
    let getOTPUrl       = URLDirectory.RegistrationData()
    let getOTPResendUrl = URLDirectory.ResendOTP()
    
    let userDefaultData = UserDefaults.standard

    var email : String!
    
    let userDefault = UserDefaults.standard
    var dictArrayValue = NSArray()

    
    

    @IBOutlet var otpScrollView: UIScrollView!
    override func viewDidLoad()
    {
        
        email = userDefault.string(forKey: "emailAddress")
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        
        designView.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        
        lblOtpDescription.text = String(format: "%@ please Click resend if the mail failed to deliver", email)
        
        
        lblOtpDescription.textAlignment = .center
  
        
        btnChangeEmail.layer.cornerRadius = 20
        
        btnChangeEmail.layer.borderWidth = 3.0
        
        btnChangeEmail.layer.borderColor = UIColor.getLightBlueColor().cgColor
        
        
        btnDone.layer.cornerRadius =  20
        btnDone.backgroundColor = UIColor.getLightBlueColor()
        
        
        
        let tapKeyBoard : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard(rec:)))
        
        self.view.addGestureRecognizer(tapKeyBoard)
        
   /*
 defaults.set(nameTextField?.text, forKey: "userName")
 defaults.set(emailTextField?.text, forKey: "emailAddress")
 
 defaults.set(countryTextField.text, forKey: "countryName")
 defaults.set(languageTextField.text, forKey: "languageName")
 defaults.set(mobileNumberTextField?.text, forKey: "mobileNumber")
 */
        
        emailId = userDefaultData.string(forKey: "emailAddress")!
        
        
        print("emil ",emailId)
        
 
        self.focusTextFields()
        // Do any additional setup after loading the view.
    }
    
    
    func focusTextFields()
    {
        txtOTP.becomeFirstResponder()
        
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//    txtOTP.resignFirstResponder()
//    
//    return true
//    }
    func dismissKeyBoard(rec : UITapGestureRecognizer)
    {
        
        self.view.endEditing(true)
        
    }
    
//    override func viewWillAppear(_ animated: Bool)
//    {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        
//        
//        NotificationCenter.default.addObserver(self, selector: #selector( keyBoardWillHide(notification:)) , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        
//        
//        
//    }
    
    
    func keyBoardWillShow(notification : NSNotification)
        
    {
      
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        
        let keyBoardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue
        
        let keyBoardSize = keyBoardInfo?.cgRectValue.size
        
        let contentInsert : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, (keyBoardSize?.height)!, 0.0)
        
        otpScrollView.contentInset = contentInsert
        
        otpScrollView.scrollIndicatorInsets = contentInsert
        
        otpScrollView.isScrollEnabled = false
        
    }
 
    func keyBoardWillHide(notification : NSNotification)
    {
        
        otpScrollView.contentInset = UIEdgeInsets.zero
        otpScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        otpScrollView.isScrollEnabled = true
        
        if(txtOTP.text?.isEmpty)!
        {
            DispatchQueue.main.async
                {
             self.txtOTP.becomeFirstResponder()
            }
           
        }
        
        
    }
    
    
    
    @IBAction func reSendOTP(_ sender: Any)
    {
        
        PhoneAuthProvider.provider().verifyPhoneNumber(userDefault.string(forKey: "mobileNumber")!, completion: { (verificationID, error) in
            
            if error != nil {
                print("error \(error?.localizedDescription)")
                self.alertViewControllerWithCancel(headerTile: "Error", bodyMessage: (error?.localizedDescription)!)
            } else {
                self.alertViewControlerWithOkAndCancel(headerTitle: "Conformation", bodyMessage: "Is this your Phone Number \(self.userDefault.string(forKey: "mobileNumber"))!")
                
            }
        })
//        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVID")! , verificationCode: txtOTP.text!)
//        Auth.auth().signIn(with: credential, completion: { (user, error) in
//            if error != nil {
//                print("error : \(error?.localizedDescription)")
//                self.alertViewControllerWithCancel(headerTile: "Error", bodyMessage: (error?.localizedDescription)!)
//                
//            } else {
//                print("phone number : \(user?.phoneNumber)")
//                self.phoneNumber = (user?.phoneNumber)!
//                self.alertViewControlerWithOkAndCancel(headerTitle: "Conformation", bodyMessage: "Is this your \( self.phoneNumber ) phone number")
//                
//            }
//        })
        
      //status = OK
        
        
    /*    let dicOtpResend  = [ "email_id" : self.emailId , "device_id" : appDelegate.deviceUDID]
        getOTPClass.getResendOTPWebService(urlString: getOTPResendUrl.url(), dicData: dicOtpResend as NSDictionary, callBack: {
            (dic ,err)  in
            
            print("resend ",dic)
            
            if (dic["status"] as! String == "OK")
            {
                
                let alert = UIAlertController(title: nil, message:  "", preferredStyle: .actionSheet)
                
                
                
                let attributedString1 = NSAttributedString(string: "OTP Successfully Resend Please Check Your mail", attributes: [
                    NSFontAttributeName : UIFont.xprezMediumFontOfsize(size: 15)  , //your font here
                    NSForegroundColorAttributeName : UIColor.white
                    ])
                
                alert.setValue(attributedString1, forKey: "attributedMessage")
                
                /*
 let subview =(alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
 
 subview.backgroundColor = UIColor(red: (145/255.0), green: (200/255.0), blue: (0/255.0), alpha: 1.0)
 
 alert.view.tintColor = UIColor.black
 */
                
 
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
            else
            {
                
            }
            
            
        }) */
        
    }
    
    @IBAction func doneOTPVerification(_ sender: Any)
    {
        if ( txtOTP.text?.isEmpty)!
        {
        
        txtOTP.textFieldBoarder(txtColor : UIColor.getLightBlueColor(), txtWidth : 1.0)
            
        }
        else
        {
            let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVID")! , verificationCode: txtOTP.text!)
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if error != nil {
                    print("error : \(error?.localizedDescription)")
                    self.alertViewControllerWithCancel(headerTile: "Error", bodyMessage: (error?.localizedDescription)!)
                    
                } else {
                    print("phone number : \(user?.phoneNumber)")
                    let userInfo = user?.providerData[0]
                    print("Provided Id : \(user?.providerID)")
                    
                    let fcmToken = self.userDefault.string(forKey: "FCMToken")
                    if (fcmToken == nil) {
                        self.parameter = ["user_name":self.userDefault.string(forKey: "userName"),"email_id": self.userDefault.string(forKey: "emailAddress") ,"phone_number":self.userDefault.string(forKey: "mobileNumber"),"country":self.userDefault.string(forKey: "countryName"),"language": self.userDefault.string(forKey: "languageName"),"device_id":self.appDelegate.deviceUDID,"notification":1,"remainder":1,"mobile_os":self.appDelegate.deviceOS,"mobile_version":self.appDelegate.deviceName,"mobile_modelname": self.appDelegate.deviceModel,"gcm_id": "DDD454564" ,"is_edit":"0"] as [String : Any]
                        
                    } else {
                        self.parameter = ["user_name":self.userDefault.string(forKey: "userName"),"email_id": self.userDefault.string(forKey: "emailAddress") ,"phone_number":self.userDefault.string(forKey: "mobileNumber"),"country":self.userDefault.string(forKey: "countryName"),"language": self.userDefault.string(forKey: "languageName"),"device_id":self.appDelegate.deviceUDID,"notification":1,"remainder":1,"mobile_os":self.appDelegate.deviceOS,"mobile_version":self.appDelegate.deviceName,"mobile_modelname": self.appDelegate.deviceModel,"gcm_id":fcmToken ,"is_edit":"0"] as [String : Any]
                    }
                    
                    
                    
//                    self.getOTPClass.getAddContact(urlString: self.getOTPUrl.url(), dicData: (self.parameter as NSDictionary) as! [String : Any], callback: {
//                        (dicc ,err) in
                    
                    self.getOTPClass.getaddDeviceWebService(urlString: self.getOTPUrl.url(), dicData: self.parameter as NSDictionary
                        , callBack: { (responseData, tokenString, err) in
                            let authToken : String = tokenString
                            
                            self.userDefault.setValue(authToken , forKey: "authToken")
                            DispatchQueue.main.async
                            {
                                    self.appDelegate.changeInitialViewController()
                            }
                    })
                    
                }
            })
            
    }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changeEmailView(_ sender: Any)
    {
     self.dismiss(animated: true, completion: nil)
//        let gotoChangeEmailPage = self.storyboard?.instantiateViewController(withIdentifier: "ChangeEmailViewController") as! ChangeEmailViewController
//        
//        gotoChangeEmailPage.userName = userName
//        gotoChangeEmailPage.country = country
//        gotoChangeEmailPage.language = language
//        gotoChangeEmailPage.mobileNumber = mobileNumber
//        self.present(gotoChangeEmailPage, animated: true, completion: nil)
        
        
    }
    
    // This textfield method will hide the keyboard when click on done button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   

}
