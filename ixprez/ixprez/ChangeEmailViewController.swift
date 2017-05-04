//
//  ChangeEmailViewController.swift
//  ixprez
//
//  Created by Quad on 4/27/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit




class ChangeEmailViewController: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet var txtReEnterEmail: UITextField!
    
    @IBOutlet var designView: UIView!
    
    @IBOutlet var changeEmailScrollView: UIScrollView!
    
    let getAddData = WebService()
    
    let getAddDataUrl = URLDirectory.RegistrationData()
    
    
   
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        
        designView.backgroundColor = UIColor(patternImage: UIImage(named: "bg_reg.png")!)
        
      
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
      
  
            if  (txtReEnterEmail.text?.isValidEmail() != true)
            {
                txtReEnterEmail.textFieldBoarder(txtColor: .getLightBlueColor(), txtWidth: 1.0)
                
            }
        
        else
            {
                
        let dicData : NSDictionary = ["user_name" : "mathan" , "email_id" : "mathan6@gmail.com", "phone_number" : "9994029677" ,"country" : "india" , "language":"english","device_id":"789654xxx",
                "notification":"1","remainder":"1","mobile_os":"ios", "mobile_version":"ios6","mobile_modelname":"K3ds3","gcm_id":"DDD454564" ]

        let jsonData = try? JSONSerialization.data(withJSONObject: dicData, options: .prettyPrinted)
        
        let urlString = NSURL(string: getAddDataUrl.url() )
        
        var request = URLRequest(url: urlString as! URL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data,response,error) -> Void in
            
            if(data != nil && error == nil)
            {
                do
                {
                    
                    let myData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    
                    print(myData)
                    
                    
                }
                catch
                {
                    
                    
                }
                
                
            }
 
        })
        
        dataTask.resume()
        
        
        }
        
        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
 

  
}
