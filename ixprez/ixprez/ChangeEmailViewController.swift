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
    
    var userNameSetting : String!
    var phoneNumberSetting : String!
    var countryNameSetting : String!
    var languageNameSetting : String!
    var reminderSetting : String!
    var notificationSetting : String!
    var isFromSettingPage  = Bool ()
    
    
    @IBOutlet var txtReEnterEmail: UITextField!
    
    @IBOutlet var designView: UIView!
    
    @IBOutlet var changeEmailScrollView: UIScrollView!
    
    @IBOutlet weak var changeButton: UIButton!
    
    let getAddData = XPWebService()
    let getSettingPageModificationDetail = URLDirectory.getSettingPageModificationDetails ()
    
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
//                txtReEnterEmail.textFieldBoarder(txtColor: .getLightBlueColor(), txtWidth: 1.0)
                
                let alertController = UIAlertController(title: "Alert!", message: "Please Provide Valid Email ID.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                
            }
        
        else
            {
                guard isFromSettingPage else {
                    let fcmToken = UserDefaults.standard.string(forKey: "FCMToken")
                    let parameter = ["user_name":userName,"email_id":txtReEnterEmail.text,"phone_number":mobileNumber,"country":country,"language": language,"notification": "1" ,"remainder": "1"] as [String : Any]
                    
                    getAddData.getSettingPageModificationDetails(urlString: getSettingPageModificationDetail.settingPageModificationUserDetailURL(), dicData: parameter as NSDictionary, callBack: { (responseArray, err) in
                        let alert = UIAlertController(title: "", message:  "", preferredStyle: .actionSheet )
                        
                        let attributedString = NSAttributedString(string: "Saved", attributes: [
                            
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
                    })
                    self.navigationController?.popToRootViewController(animated: true)
                    return
                }
                
                let fcmToken = UserDefaults.standard.string(forKey: "FCMToken")
                let parameter = ["user_name":userNameSetting,"email_id":txtReEnterEmail.text,"phone_number":phoneNumberSetting,"country":countryNameSetting,"language": languageNameSetting,"notification": notificationSetting ,"remainder": reminderSetting]
                
                getAddData.getSettingPageModificationDetails(urlString: getSettingPageModificationDetail.settingPageModificationUserDetailURL(), dicData: parameter as NSDictionary, callBack: { (responseArray, err) in
                    let alert = UIAlertController(title: "", message:  "", preferredStyle: .actionSheet )
                    
                    let attributedString = NSAttributedString(string: "Saved", attributes: [
                        
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
                })
                self.navigationController?.popViewController(animated: true)
                
             }
    
          }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
 

  
}
