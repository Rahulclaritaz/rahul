//
//  OTPVerificationViewController.swift
//  ixprez
//
//  Created by Quad on 4/27/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//
//Confirmation code has been send to mathan6@gmail.complease Click resend if the mail failed to deliver.

import UIKit

class OTPVerificationViewController: UIViewController,UITextFieldDelegate
{
    
    
    @IBOutlet weak var lblOtpDescription: UILabel!
    
    @IBOutlet var btnChangeEmail: UIButton!
    
    @IBOutlet var designView: UIView!
    
    @IBOutlet var btnDone: UIButton!
    
    @IBOutlet var txtOTP: UITextField!
    
    var userName : String = ""
    var emailId : String = ""
    var country : String = ""
    var language : String = ""
    var mobileNumber : String = ""
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let getOTPClass = XPWebService()
    let getOTPUrl = URLDirectory.OTPVerification()
    let getOTPResendUrl = URLDirectory.ResendOTP()
    
    let userDefaultData = UserDefaults.standard

    var email : String!
    
    let userDefault = UserDefaults.standard
    
    

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
        
        
      //status = OK
        
        
        let dicOtpResend  = [ "email_id" : self.emailId , "device_id" : appDelegate.deviceUDID]
        getOTPClass.getResendOTPWebService(urlString: getOTPResendUrl.url(), dicData: dicOtpResend as NSDictionary, callBack: {
            (dic ,err)  in
            
            print("resend ",dic)
            
            if (dic["status"] as! String == "OK")
            {
                
                let alert = UIAlertController(title: nil, message:  "", preferredStyle: .alert)
                
                
                
                let attributedString1 = NSAttributedString(string: "OTP Successfully Resend Please Check Your mail", attributes: [
                    NSFontAttributeName : UIFont.xprezMediumFontOfsize(size: 15)  , //your font here
                    NSForegroundColorAttributeName : UIColor.white
                    ])
                
                alert.setValue(attributedString1, forKey: "attributedMessage")
                
                
                alert.view.backgroundColor = UIColor.black.withAlphaComponent(1.0)
                
                alert.view.clipsToBounds = true

                DispatchQueue.main.async
                {
                    
                    alert.show()
                }
                
            }
            else
            {
                
            }
            
            
        })
        
    }
    
    @IBAction func doneOTPVerification(_ sender: Any)
    {
        if ( txtOTP.text?.isEmpty)!
        {
        
        txtOTP.textFieldBoarder(txtColor : UIColor.getLightBlueColor(), txtWidth : 1.0)
            
        }
        else
        {
        let dicData : [String:Any] = [ "email_id" :emailId ,"device_id" :appDelegate.deviceUDID , "otp" : txtOTP.text!]
    
            getOTPClass.getAddContact(urlString: getOTPUrl.url(), dicData: dicData as NSDictionary, callback: {
                (dicc , err ) in
                
              if ( (dicc["status"] as! String) == "OK" )
              {
                
                print(dicc)
                
                DispatchQueue.main.async {
                    
            
                
                self.appDelegate.changeInitialViewController()
                
                }
                
                }
                else
                {
                    
                  
                    let alert = UIAlertController(title: nil, message:  "", preferredStyle: .alert)
                    
                   
                    
                    let attributedString = NSAttributedString(string: "wrong OTPFailed", attributes: [
                        NSFontAttributeName : UIFont.xprezMediumFontOfsize(size: 15)  , //your font here
                        NSForegroundColorAttributeName : UIColor.white
                        ])
                    
                    
                    alert.view.backgroundColor = UIColor.black.withAlphaComponent(1.0)
                    
                    alert.view.clipsToBounds = true
                    
                    alert.setValue(attributedString, forKey: "attributedMessage")
                    
                    DispatchQueue.main.async
                        {
                            
                            alert.show()
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
     
        let gotoChangeEmailPage = self.storyboard?.instantiateViewController(withIdentifier: "ChangeEmailViewController") as! ChangeEmailViewController
        
        gotoChangeEmailPage.userName = userName
        gotoChangeEmailPage.country = country
        gotoChangeEmailPage.language = language
        gotoChangeEmailPage.mobileNumber = mobileNumber
        self.present(gotoChangeEmailPage, animated: true, completion: nil)
        
        
    }
    
    // This textfield method will hide the keyboard when click on done button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   

}
