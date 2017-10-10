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
    @IBOutlet var txtStringLabel : UILabel!
    var dataArrayValue = [String : AnyObject]()
    
    var authtoken : String = ""
    
    var parameter = [String : Any]()
    var userName : String = ""
    var emailId : String = ""
    var country : String = ""
    var language : String = ""
    var phoneNumber : String = ""
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromSettingPage  = Bool ()
    var mobileNumberSetting : String!
    var emailSettingPage : String!
    
    let getOTPClass = XPWebService()
    let getOTPVerification = URLDirectory.OTPVerification()
    let getOTPUrl       = URLDirectory.RegistrationData()
    let getOTPResendUrl = URLDirectory.ResendOTP()
    
    let userDefaultData = UserDefaults.standard

    var email : String!
    var phone : String!
    
    let userDefault = UserDefaults.standard
    var dictArrayValue = NSArray()
    var userNameSetting : String!
    var phoneNumberSetting : String!
    var countryNameSetting : String!
    var languageNameSetting : String!
    var reminderSetting : String!
    var notificationSetting : String!

    
    

    @IBOutlet var otpScrollView: UIScrollView!
    override func viewDidLoad()
    {
        
        email = userDefault.string(forKey: "emailAddress")
        phone = userDefault.string(forKey: "mobileNumber")
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        
        designView.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        guard isFromSettingPage else {
            txtStringLabel.text = String(format: "on your registered mobile number")
            lblOtpDescription.text = String(format: "%@ please Click resend if the Code failed to deliver", phone)
            return
        }
        txtStringLabel.text = String(format: "on your registered Email ID")
        
        lblOtpDescription.text = String(format: "%@ please Click resend if the code failed to deliver", email)
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
        
        
        guard isFromSettingPage else {
            let alertViewController = UIAlertController(title: "Conformation", message: "Is this your Phone Number \(self.userDefault.string(forKey: "mobileNumber"))!", preferredStyle: .alert)
            let alertOKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                PhoneAuthProvider.provider().verifyPhoneNumber(self.userDefault.string(forKey: "mobileNumber")!, completion: { (verificationID, error) in
                    
                    print("While regenerating the OTP, that time  verification Id is \(verificationID)")
                    if error != nil {
                        print("error \(error?.localizedDescription)")
                        self.alertViewControllerWithCancel(headerTile: "Error", bodyMessage: (error?.localizedDescription)!)
                    } else {
                        UserDefaults.standard.set(verificationID, forKey: "OTPVerificationID")
                    }
                })
            }
            
            let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
                print("You cancel the Action")
            }
            alertViewController.addAction(alertOKAction)
            alertViewController.addAction(alertCancelAction)
            present(alertViewController, animated: true, completion: nil)
            return
        }
        let param = ["email_id" : email,"device_id" : self.appDelegate.deviceUDID ]
        getOTPClass.getResendOTPWebService(urlString: getOTPResendUrl.url(), dicData: param as NSDictionary) { (responseData, error) in
            
            let responseCode : String = String(describing: responseData["code"])
            if (responseCode == "404") {
                let alertController = UIAlertController(title: "Alert!", message: "Oops! Something Went Wrong, Please Try again.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "", message:  "", preferredStyle: .actionSheet )
                
                let attributedString = NSAttributedString(string: "OTP Send to your Email id.", attributes: [
                    
                    NSFontAttributeName : UIFont.xprezBoldFontOfSize(size: 15) ,
                    
                    NSForegroundColorAttributeName : UIColor.white
                    
                    ])
                let subview1 = alert.view.subviews.first! as UIView
                let subview2 = subview1.subviews.first! as UIView
                let view = subview2.subviews.first! as UIView
                
                subview2.backgroundColor = UIColor.clear
                
                subview1.backgroundColor = UIColor.clear
                
                view.backgroundColor = UIColor(red:255-255, green:255-255, blue:255-255, alpha:0.8)
                
                view.layer.cornerRadius = 20.0
                
                alert.setValue(attributedString, forKey: "attributedTitle")
                
                
                UIView.animate(withDuration: 15.0, delay: 0, options: .curveEaseIn, animations: {
                    
                    DispatchQueue.main.async {
                        
                        alert.show()
                        
                    }
                    
                }, completion: nil)
            }
            
        }
        
        
        
    }
    
    @IBAction func doneOTPVerification(_ sender: Any)
    {
        if ( txtOTP.text?.isEmpty)!
        {
        
//        txtOTP.textFieldBoarder(txtColor : UIColor.getLightBlueColor(), txtWidth : 1.0)
            let alertController = UIAlertController(title: "Alert!", message: "OTP can Not be blank it will be 6 digit number.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)

            
        }
        else
        {
            guard isFromSettingPage else {
                let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "OTPVerificationID")! , verificationCode: txtOTP.text!)
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
                            self.parameter = ["user_name":self.userDefault.string(forKey: "userName"),"email_id": self.userDefault.string(forKey: "emailAddress") ,"phone_number":self.userDefault.string(forKey: "mobileNumber"),"country":self.userDefault.string(forKey: "countryName"),"language": self.userDefault.string(forKey: "languageName"),"device_id":self.appDelegate.deviceUDID,"notification":1,"remainder":1,"mobile_os":self.appDelegate.deviceOS,"mobile_version":self.appDelegate.deviceName,"mobile_modelname": self.appDelegate.deviceModel,"gcm_id": "DDD454564","country_code": self.userDefault.string(forKey: "countryCode") ,"is_edit":"0"] as [String : Any]
                            
                        } else {
                            self.parameter = ["user_name":self.userDefault.string(forKey: "userName"),"email_id": self.userDefault.string(forKey: "emailAddress") ,"phone_number":self.userDefault.string(forKey: "mobileNumber"),"country":self.userDefault.string(forKey: "countryName"),"language": self.userDefault.string(forKey: "languageName"),"device_id":self.appDelegate.deviceUDID,"notification":1,"remainder":1,"mobile_os":self.appDelegate.deviceOS,"mobile_version":self.appDelegate.deviceName,"mobile_modelname": self.appDelegate.deviceModel,"gcm_id":fcmToken, "country_code": self.userDefault.string(forKey: "countryCode") ,"is_edit":"0"] as [String : Any]
                        }
                        
                        
                        
                        //                    self.getOTPClass.getAddContact(urlString: self.getOTPUrl.url(), dicData: (self.parameter as NSDictionary) as! [String : Any], callback: {
                        //                        (dicc ,err) in
                        
                        self.getOTPClass.getaddDeviceWebService(urlString: self.getOTPUrl.url(), dicData: self.parameter as NSDictionary
                            , callBack: { (responseData, tokenString, err) in
                                let authToken : String = tokenString
                                
                                self.userDefault.setValue(authToken , forKey: "authToken")
                                DispatchQueue.main.async
                                    {
//                                        self.appDelegate.changeInitialViewController()
                                        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "WelcomePageViewController") as! WelcomePageViewController
                                       self.present(storyBoard, animated: true, completion: nil)
                                }
                        })
                        
                    }
                })
                return
            }
            let parameter = [ "email_id" : emailSettingPage,"device_id":appDelegate.deviceUDID,"otp":txtOTP.text ,"phone_number":mobileNumberSetting]
            getOTPClass.getOTPWebService(urlString: getOTPVerification.url(), dicData: parameter as NSDictionary, callBack: { (responseData, err) in
                print(responseData)
                if (responseData == "Failed") {
                    let alertController = UIAlertController(title: "Alert", message: "Oops! Wrong Password.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil);
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
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
        guard isFromSettingPage else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        let gotoChangeEmailPage = self.storyboard?.instantiateViewController(withIdentifier: "ChangeEmailViewController") as! ChangeEmailViewController
        
                gotoChangeEmailPage.userNameSetting = userNameSetting
                gotoChangeEmailPage.countryNameSetting = countryNameSetting
                gotoChangeEmailPage.languageNameSetting = languageNameSetting
                gotoChangeEmailPage.phoneNumberSetting = mobileNumberSetting
                gotoChangeEmailPage.reminderSetting = reminderSetting
                gotoChangeEmailPage.notificationSetting = notificationSetting
        gotoChangeEmailPage.isFromSettingPage = true
        self.navigationController?.pushViewController(gotoChangeEmailPage, animated: true)
        
        
    }
    
    // This textfield method will hide the keyboard when click on done button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   

}
