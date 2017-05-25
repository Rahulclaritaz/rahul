//
//  XPUploadsEmotionsViewController.swift
//  ixprez
//
//  Created by Quad on 5/23/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit


class XPUploadsEmotionsViewController: UIViewController,UITextFieldDelegate
{
    
    var getUploadWebService = MyUploadWebServices()
    var getUploadUrl = URLDirectory.MyUpload()
    
    var FileType = String()
    
    var ID = String()

    var countArray = [Int]()
    var emotionArray = [String]()
    
    
    @IBOutlet weak var subView: UIView!
    
    var customAlertController : DOAlertController!
    
    
    var recordEmotionCount = [[String :Any]]()
    
    var getEmotionUrl = URLDirectory.MyUpload()
    
    var getEmotionWebService = MyUploadWebServices()
    
    var flagTick : Bool!
    
    var likeCount : Int!
    var happyCount : Int!
    var sadCount : Int!
    var angryCount : Int!
    var surprisingCount : Int!
    
    var arrData = [Int]()
    
    
    @IBOutlet weak var imgTickLike: UIImageView!
    
    @IBOutlet weak var imgTickHappy: UIImageView!
    
    @IBOutlet weak var imgTickAngry: UIImageView!
    
    @IBOutlet weak var imgTickSad: UIImageView!
    
    @IBOutlet weak var imgTickSurprising: UIImageView!
    
    
    @IBOutlet weak var lblLikeCount: UILabel!
    
    
    @IBOutlet weak var lblHappyCount: UILabel!
    
    
    @IBOutlet weak var lblAngryCount: UILabel!
    
    @IBOutlet weak var lblSadCount: UILabel!
    
    @IBOutlet weak var lblSurprisingCount: UILabel!
    
    @IBOutlet weak var lblView1: UILabel!
    
    @IBOutlet weak var lblView2: UILabel!
    
    
    @IBOutlet weak var lblView3: UILabel!
    
    @IBOutlet weak var lblView4: UILabel!
    
    @IBOutlet weak var lblView5: UILabel!
    
    
    @IBOutlet weak var lblView6: UILabel!
    //OutLet
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
    super.viewDidLoad()

        
        print(countArray)
        print(emotionArray)
        
        flagTick = true
     
        setDesign(view: lblSurprisingCount)
        setDesign(view: lblHappyCount)
        setDesign(view: lblLikeCount)
        setDesign(view: lblSadCount)
        setDesign(view: lblAngryCount)
     
        lblLikeCount.text = "0"
        lblHappyCount.text = "0"
        lblAngryCount.text = "0"
        lblSurprisingCount.text = "0"
        lblSadCount.text = "0"
        
      

       getEmotionCount()
        
        

    }
    
    
    func setDesign(view : UIView)
        
    {
        view.backgroundColor = UIColor.getOrangeColor()
        view.layer.cornerRadius = view.frame.width/2
        view.clipsToBounds = true
 
    }

    
    func setBorder(view : UIView) -> UIView
    {
        let border = CALayer()
        let borderWidth : CGFloat = 1.0
        border.borderWidth = borderWidth
        border.borderColor =  UIColor.black.cgColor
        
        border.frame = CGRect(x: 0, y: CGFloat(view.frame.size.height - borderWidth), width: CGFloat(view.frame.size.width), height: CGFloat(view.frame.size.height - 15))
        
        view.layer.addSublayer(border)
        
        return view
        
    }
    
    
    func getEmotionCount()
    {
      let dicValue = ["user_email":"mathan6@gmail.com","file_id":ID]
        
        
        
        getEmotionWebService.getPublicPrivateMyUploadWebService(urlString: getEmotionUrl.uploadEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
         
            
            self.recordEmotionCount = dicc
          
            
            
            for details in self.recordEmotionCount
            {
                let myData = details["count"] as! Int
                
                self.arrData.append(myData)
          
            }
            

     
        })
        

  
    }
    
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func countEmotion(_ sender: UIButton)
    {
  
    
        switch sender.tag
        {
        
        case 1:
            
            if (sender.isSelected == false)
            {
            imgTickLike.image = UIImage(named: "check-mark-red-11.png")
            
              lblLikeCount.text = String(countArray[0] + 1)
            getSaveEmotionCount(sender: (sender.titleLabel?.text)!)
              sender.isSelected = true
            }
            else
            {
                imgTickLike.image = nil
                
                lblLikeCount.text = String(countArray[0])
               sender.isSelected = false
            }
            
            
        case 2:
            if (sender.isSelected == false )
            {
            imgTickHappy.image = UIImage(named: "check-mark-red-11.png")
               lblHappyCount.text = String(countArray[1] + 1)
                getSaveEmotionCount(sender: (sender.titleLabel?.text)!)
                
             sender.isSelected = true
            }
            else
            {
               imgTickHappy.image = nil
                lblHappyCount.text = String(countArray[1])
                
                sender.isSelected = false
            }

        case 3:
            if (sender.isSelected == false )
            {
                
            imgTickAngry.image = UIImage(named: "check-mark-red-11.png")
                getSaveEmotionCount(sender: (sender.titleLabel?.text)!)
                
                lblAngryCount.text = String(countArray[2] + 1)
                
                 sender.isSelected = true
            }
            else
              
            {
                imgTickAngry.image = nil
                lblAngryCount.text = String(countArray[2])

             sender.isSelected = false
            }

        case 4:
            
            if (sender.isSelected == false )
            {
            imgTickSad.image = UIImage(named: "check-mark-red-11.png")
                getSaveEmotionCount(sender: (sender.titleLabel?.text)!)
                lblSadCount.text = String(countArray[3] + 1)
                 sender.isSelected = true
                
            }
            else
            {
                
                imgTickSad.image = nil
                lblSadCount.text = String(countArray[3])
               sender.isSelected = false
            }

        case 5:
            if (sender.isSelected == false )
            {
           
                
            imgTickSurprising.image = UIImage(named: "check-mark-red-11.png")
                getSaveEmotionCount(sender: (sender.titleLabel?.text)!)
                 lblSurprisingCount.text = String(countArray[4] + 1)
                
                  sender.isSelected = true
                
            }
            else
            {
            imgTickSurprising.image = nil
                
                 lblSurprisingCount.text = String(countArray[4])
              sender.isSelected = false
                
            }

       break
        default:
            print("No")
     
        }
    
        
    }
    
    
    func getSaveEmotionCount(sender : String)
        
    {
        print(sender)
        
        
    let dicValue = ["id":ID ,"user_email":"mathan6@gmail.com","emotion":sender,"status":"1"]
        
        
        getEmotionWebService.getReportMyUploadWebService(urlString: getEmotionUrl.saveEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
            
            
           
            
        })
        
        
        
    }

    
    //
    //{"id":"5773af299b0022a13cc77e8d","user_email":"jayanthan123.s@quadrupleindia.com","emotion":"Sad","status":"1"}
    
    
    @IBAction func reportAbuse(_ sender: UIButton)
    
    {
    
    self.subView.removeFromSuperview()
        
        var textfield1 = UITextField()
        
        let title = "Report Abuse"
        //let message = "A message should be a short, complete sentence."
        let cancelButtonTitle = "DISCARD"
        let otherButtonTitle = "POST"
        
        customAlertController = DOAlertController(title: title, message: nil, preferredStyle: .alert)
        
        changecustomAlertController()
        
        // Add the text field for text entry.
        
        
        // alert.addTextField(configurationHandler: textFieldHandler)
    
        customAlertController.addTextFieldWithConfigurationHandler { textField in
            
         
            textField?.frame.size = CGSize(width: 240.0, height: 30.0)
            textField?.font = UIFont(name: "Mosk", size: 15.0)
            textField?.textColor = UIColor.blue
            textField?.keyboardAppearance = UIKeyboardAppearance.dark
            textField?.returnKeyType = UIReturnKeyType.send
          
             textfield1 = textField!
            
            textField?.delegate = self
            
            // If you need to customize the text field, you can do so here.
        }
        
        // Create the actions.
        let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .cancel) { action in
            NSLog("The \"Text Entry\" alert's cancel action occured.")
        }
        
           let otherAction = DOAlertAction(title: otherButtonTitle, style: .default) { action in
            NSLog("The \"Text Entry\" alert's other action occured.")
     
          
            let textFields = self.customAlertController.textFields as? Array<UITextField>
           
            
            if textFields != nil {
                for textField: UITextField in textFields! {
                    NSLog(textField.text!)
                    
            let dicData = [ "user_email" : "mathan6@gmail.com" , "description"  : textField.text! , "file_id" : self.ID , "file_type" : self.FileType] as [String : Any]
                    
                    self.getUploadWebService.getReportMyUploadWebService(urlString: self.getUploadUrl.uploadReportAbuse(), dicData: dicData as NSDictionary, callback: {
                        (dicc,erro) in
                        
                        print(dicc)
                        
                    
                    })
                    
                    
                }
            }
            
            
        }
        
        // Add the actions.
        customAlertController.addAction(cancelAction)
        customAlertController.addAction(otherAction)
        
        present(customAlertController, animated: true, completion: nil)

        
    }
    
    func changecustomAlertController()
    {
        
        customAlertController.alertView.layer.cornerRadius = 6.0
        
        customAlertController.alertViewBgColor = UIColor.lightGray
        
        customAlertController.titleFont = UIFont(name: "Mosk", size: 17.0)
        customAlertController.titleTextColor = UIColor.blue
        
        customAlertController.messageFont = UIFont(name: "Mosk", size: 12.0)
        
        
        customAlertController.messageTextColor = UIColor.white
        
        
        
        customAlertController.buttonFont[.cancel] = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.buttonBgColor[.cancel] = UIColor.black
        
        customAlertController.buttonFont[.default] = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.buttonBgColor[.default] = UIColor.getOrangeColor()
        
    }



}
