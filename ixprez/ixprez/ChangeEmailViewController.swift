//
//  ChangeEmailViewController.swift
//  ixprez
//
//  Created by Quad on 4/27/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit


class ChangeEmailViewController: UIViewController,UITextFieldDelegate
{
 
    var userName : String!
    
    
    var mobileNumber : String!
    
    var country : String!
    
    var language : String!
    
    @IBOutlet var txtReEnterEmail: UITextField!
    
    @IBOutlet var designView: UIView!
    
    @IBOutlet var changeEmailScrollView: UIScrollView!
    
    @IBOutlet weak var changeButton: UIButton!
    
    let getAddData = XPWebService()
    
    let getAddDataUrl = URLDirectory.RegistrationData()
    
    let getKeyData = UserDefaults.standard

    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
   
    override func viewDidLoad()
    {
        super.viewDidLoad()

        /*
 defaults.set(nameTextField?.text, forKey: "userName")
 defaults.set(emailTextField?.text, forKey: "emailAddress")
 
 defaults.set(countryTextField.text, forKey: "countryName")
 defaults.set(languageTextField.text, forKey: "languageName")
 defaults.set(mobileNumberTextField?.text, forKey: "mobileNumber")
 
 */
        userName = getKeyData.string(forKey: "userName")
               mobileNumber = getKeyData.string(forKey: "mobileNumber")
        country = getKeyData.string(forKey: "countryName")
        language = getKeyData.string(forKey: "languageName")
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        
        designView.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        
         changeButton.layer.cornerRadius = 20.0
        let  gesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard(notification:)))
        
        self.view.addGestureRecognizer(gesture)
        
     
        self.focusTextField()
    }
  
    
    func focusTextField()
    {
      txtReEnterEmail.becomeFirstResponder()
        
    }
    func dismissKeyBoard(notification :UIGestureRecognizer)
    {
        self.view.endEditing(true)
        
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    
        txtReEnterEmail.resignFirstResponder()
    
       return true
   }
       override func viewWillAppear(_ animated: Bool)
    {
    
        NotificationCenter.default.addObserver(
        self,
         selector:#selector(keyBoardWillShow(notification:)),
        name: NSNotification.Name.UIKeyboardWillShow,
         object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide ,
            object: nil)
    
   }
    
 
    
  
    func keyBoardWillShow(notification : NSNotification)
    {
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        let keyBoardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyBoardSize = keyBoardInfo.cgRectValue.size
        let contentInsert = UIEdgeInsetsMake(0, 0, keyBoardSize.height, 0)
        changeEmailScrollView.contentInset = contentInsert
        changeEmailScrollView.scrollIndicatorInsets = contentInsert
        changeEmailScrollView.isScrollEnabled = false
    }
 
 
    func keyBoardWillHide(notification : NSNotification)
    {
        changeEmailScrollView.contentInset = UIEdgeInsets.zero
        changeEmailScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        changeEmailScrollView.isScrollEnabled = true
        
         if (txtReEnterEmail.text?.isEmpty)!
         {
            DispatchQueue.main.async
            {
                self.txtReEnterEmail.becomeFirstResponder()
            }
            
          txtReEnterEmail.becomeFirstResponder()
        }
        
    }
    @IBAction func saveChangeEmailData(_ sender: Any)
    {
      
       UserDefaults.standard.set(txtReEnterEmail.text, forKey: "emailAddress")
            if  (txtReEnterEmail.text?.isValidEmail() != true)
            {
                txtReEnterEmail.textFieldBoarder(txtColor: .getLightBlueColor(), txtWidth: 1.0)
                
            }
        
        else
            {
                
        let dicData : NSDictionary = ["user_name" : userName , "email_id" : txtReEnterEmail.text!, "phone_number" : mobileNumber ,"country" : country , "language":language,"device_id":appdelegate.deviceUDID,
                "notification":"1","remainder":"1","mobile_os":appdelegate.deviceOS, "mobile_version":appdelegate.deviceName,"mobile_modelname":appdelegate.deviceModel,"gcm_id":"DDD454564" ]

    
                getAddData.getAddContact(urlString: getAddDataUrl.url(), dicData: dicData as! [String : Any], callback:
                    { (dicc ,err) in
                        
                    if (dicc["status"] as! String == "OK")
                    {
                        DispatchQueue.main.async {
                         
                     let otpView = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationViewController") as! OTPVerificationViewController
                        
                        self.present(otpView, animated: true, completion: nil)
                        }
                        
                        
                        }
                        
                })
                
      
                
                
                
    }
    
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
 

  
}
