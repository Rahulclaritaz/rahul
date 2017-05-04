//
//  OTPVerificationViewController.swift
//  ixprez
//
//  Created by Quad on 4/27/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class OTPVerificationViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet var btnChangeEmail: UIButton!
    @IBOutlet var designView: UIView!
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var txtOTP: UITextField!
    
    let getOTPClass = WebService()
    let getOTPUrl = URLDirectory.OTPVerification()
    let getOTPResendUrl = URLDirectory.ResendOTP()
    

    @IBOutlet var otpScrollView: UIScrollView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        designView.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        
        
        btnChangeEmail.layer.cornerRadius = 20
        btnChangeEmail.layer.borderWidth = 3.0
        btnChangeEmail.layer.borderColor = UIColor.getLightBlueColor().cgColor
        
        
        btnDone.layer.cornerRadius =  20
        btnDone.backgroundColor = UIColor.getLightBlueColor()
        
        
        
        let tapKeyBoard : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard(rec:)))
        
        self.view.addGestureRecognizer(tapKeyBoard)
        
        
        print("contentoffset",otpScrollView.contentOffset)
        print("bounces",otpScrollView.bounces)
        
        
        
        self.focusTextFields()
        // Do any additional setup after loading the view.
    }
    
    
    func focusTextFields()
    {
        txtOTP.becomeFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
    txtOTP.resignFirstResponder()
    
    return true
    }
    func dismissKeyBoard(rec : UITapGestureRecognizer)
    {
        
        self.view.endEditing(true)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector( keyBoardWillHide(notification:)) , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
    }
    
    
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
        
        
      
        
        let dicOtpResend  = [ "email_id" : "mathan6@gmail.com" , "device_id" : "789654xxx"]
        getOTPClass.getResendOTPWebService(urlString: getOTPResendUrl.url(), dicData: dicOtpResend as NSDictionary)
        
    }
    
    @IBAction func doneOTPVerification(_ sender: Any)
    {
        if ( txtOTP.text?.isEmpty)!
        {
        
        txtOTP.textFieldBoarder(txtColor : UIColor.getLightBlueColor(), txtWidth : 1.0)
            
        }
        else
        {
        let dicData : [String:Any] = [ "email_id" : "mathan6@gmail.com" ,"device_id" :"789654xxx" , "otp" : txtOTP.text!]
    
        getOTPClass.getOTPWebService(urlString: getOTPUrl.url(), dicData: dicData as NSDictionary)
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
        
        self.present(gotoChangeEmailPage, animated: true, completion: nil)
        
        
    }
   

}
