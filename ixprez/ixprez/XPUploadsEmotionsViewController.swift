
//  XPUploadsEmotionsViewController.swift
//  ixprez

//  Created by Quad on 5/23/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.


import UIKit
 


class XPUploadsEmotionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    var FileType = String()
    
    var ID = String()
  
    var customAlertController : DOAlertController!
    
    var recordEmotionCount = [[String :Any]]()
    
    
    var checkCurrentRecordEmotionCount = [[String:Any]]()
    

    var getEmotionUrl = URLDirectory.MyUpload()
    
    var getEmotionWebService = MyUploadWebServices()
    
    var flagTick : Bool!
    
    
    var isSele : Bool!
    
    var userEmail = String()
    
    var nsuerDefault = UserDefaults.standard
    
    var isPressButton0 : Bool!
    var isPressButton1 : Bool!
    var isPressButton2 : Bool!
    var isPressButton3 : Bool!
    
    var isReload : Bool!
    
    
    //OutLet
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        flagTick = true
     
        isReload = false
        
        isPressButton0 = false
        
        isPressButton1 = false
        
        isPressButton2 = false
        
        isPressButton3 = false
        
        
        super.viewDidLoad()
        print("Check Mathan")
        
        print(FileType)
        print("mathan id",ID)
       
         userEmail = nsuerDefault.string(forKey: "emailAddress")!
        
        getEmotionCount()
        
             }
    
    func getEmotionCount()
    {
        
        
        
        let dicValue = ["user_email":userEmail,"file_id":ID]
        
        
        if isReload == false
        {
        getEmotionWebService.getPublicPrivateMyUploadWebService(urlString: getEmotionUrl.uploadEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
            
            self.recordEmotionCount = dicc
            
            DispatchQueue.main.async
                {
                
              self.tableView.reloadData()
            }
           
                   })
            
            isReload = true
            
            
        }
        
        else
        {
            getEmotionWebService.getPublicPrivateMyUploadWebService(urlString: getEmotionUrl.uploadEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
                
                self.recordEmotionCount = dicc
                
                
                
            })
            
  
        }
        
    }

    
  
    override func viewWillAppear(_ animated: Bool) {
        
      //  getEmotionCount()


      
    }

   /* func getEmotionCount()
    {
      let dicValue = ["user_email":"mathan6@gmail.com","file_id":ID]
        
        
        
        getEmotionWebService.getPublicPrivateMyUploadWebService(urlString: getEmotionUrl.uploadEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
         
            
            
            
            self.recordEmotionCount = dicc
            
            DispatchQueue.main.async {
                
             self.tableView.reloadData()
                
            }
            
            
        })
   
        
        
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
    return recordEmotionCount.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "emotioncell", for: indexPath) as! UploadsEmotionsTableViewCell
        
       let emotionCount = recordEmotionCount[indexPath.row]
        
      cell.lblEmotionCount.layer.cornerRadius = cell.lblEmotionCount.frame.size.width/2
        
        cell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
        
        
        

        cell.imgTick.image = UIImage(named: "")
    
        let fullName    = emotionCount["emotion"] as! String
        let fullNameArr = fullName.components(separatedBy: "   ")
        
        let name    = fullNameArr[0]
        let surname = fullNameArr[1]
        
        
        cell.lblEmotionEmoji.text = name
     
        cell.btnEmotion.setTitle(surname, for: .normal)
        
        if ((emotionCount["isUserChecked"] as! Int ) == 1)
        {
            cell.imgTick.image = UIImage(named: "EmotionTick")
            
            cell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
            print("hi is userChecked")
            
            //isSele = false
            
            
        }
        else
        {
            cell.imgTick.image = nil
            
             cell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
            // isSele = true
         
            
        }

        
        cell.lblEmotionCount.layer.cornerRadius = cell.lblEmotionCount.frame.width/2
        
//        cell.lblEmotionCount.backgroundColor = UIColor.getOrangeColor()
        
        
        
        let lengthOfTitle =  cell.btnEmotion.titleLabel?.text?.lengthOfBytes(using: .utf32)
        
        print("length Of Title %d", CGFloat(lengthOfTitle!))
        
        cell.emotionWidth.constant  =  CGFloat(lengthOfTitle!)*2
        
        
        cell.btnEmotion.tag = indexPath.row
        
        cell.btnEmotion.addTarget(self, action: #selector(countEmotion(sender:)), for: .touchUpInside)
       
        return cell
        
        
    }
    //reportcell
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
   {
    
    let myCell = tableView.dequeueReusableCell(withIdentifier: "reportcell") as! MyUploadReportAbuseTableViewCell
    
    myCell.btnReport.addTarget(self, action: #selector(alertViewReport(sender:)), for: .touchUpInside)
    myCell.btnReport.layer.cornerRadius = 5.0
   
    return myCell.contentView
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
        
    }
    
    //isUserChecked
    
    func countEmotion(sender : UIButton)
    {
   
        
        switch sender.tag
        
        {
         
        case 0 :

       let indexPathData = IndexPath(row: sender.tag, section: 0)
        
        let myCell = tableView.cellForRow(at: indexPathData) as! UploadsEmotionsTableViewCell
        
        let emotionCount = recordEmotionCount[indexPathData.row]
        
        let userCheckedCount = emotionCount["isUserChecked"] as! Int
      
        print("user Checked Count" , userCheckedCount)
        
       
        
        if   userCheckedCount != 1
        {
            
            isSele = true
            
          
            
        }
            
        else
        {
            isSele = false
            
            
        }

        
        
           if (isSele == true)
          {
            
             if isPressButton0 == false
             {
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int + 1)
                
                myCell.imgTick.image = UIImage(named: "EmotionTick")
            
                getSaveEmotionCount(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                print("user Checked Count" , userCheckedCount)
               
                
              isPressButton0 = true
            }
            else
             {
                myCell.imgTick.image =  nil
                
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
                
                getSaveEmotionCount1(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                isPressButton0 = false
                
 
            }
         
        }
            else
        {
            
            
            if isPressButton0 == false
            {
               myCell.imgTick.image =  nil
            
                
               myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int - 1 )
            
               getSaveEmotionCount1(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                  print("user Checked Count" , userCheckedCount)
                
                            isPressButton0 = true
                
            
            
            }
            else
            {
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
                
                getSaveEmotionCount(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                myCell.imgTick.image = UIImage(named: "EmotionTick")
                
                isPressButton0 = false
            }
        
        }
            
            
        case 1 :
            
            
            let indexPathData = IndexPath(row: sender.tag, section: 0)
            
            let myCell = tableView.cellForRow(at: indexPathData) as! UploadsEmotionsTableViewCell
            
            let emotionCount = recordEmotionCount[indexPathData.row]
            
            let userCheckedCount = emotionCount["isUserChecked"] as! Int
            
            print("user Checked Count" , userCheckedCount)
            
            
            
            if   userCheckedCount != 1
            {
                
                isSele = true
                
                
                
            }
                
            else
            {
                isSele = false
                
                
            }
            
            
            
            if (isSele == true)
            {
                
                if isPressButton1 == false
                {
                    myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int + 1)
                    
                    myCell.imgTick.image = UIImage(named: "EmotionTick")
                    
                    getSaveEmotionCount(sender: (myCell.btnEmotion.titleLabel?.text)!)
                                    isPressButton1 = true
                }
                else
                {
                    myCell.imgTick.image =  nil
                    
                    myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
                    
                    getSaveEmotionCount1(sender: (myCell.btnEmotion.titleLabel?.text)!)
                    
                    isPressButton1 = false
                    
                    
                }
                
            }
            else
            {
                
                
                if isPressButton1 == false
                {
                    myCell.imgTick.image =  nil
                    
                    myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int - 1)
                    
                    getSaveEmotionCount1(sender: (myCell.btnEmotion.titleLabel?.text)!)
                    
                    isPressButton1 = true
                    
                    
                    
                }
                else
                {
                    myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
                    
                    getSaveEmotionCount(sender: (myCell.btnEmotion.titleLabel?.text)!)
                    
                    myCell.imgTick.image = UIImage(named: "EmotionTick")
                   
                    isPressButton1 = false
                }
                
            }

        
        
        
        case 2 :
            
           

        
        let indexPathData = IndexPath(row: sender.tag, section: 0)
        
        let myCell = tableView.cellForRow(at: indexPathData) as! UploadsEmotionsTableViewCell
        
        let emotionCount = recordEmotionCount[indexPathData.row]
        
        let userCheckedCount = emotionCount["isUserChecked"] as! Int
        
        print("user Checked Count" , userCheckedCount)
        
        
        
        if   userCheckedCount != 1
        {
            
            isSele = true
            
            
            
        }
            
        else
        {
            isSele = false
            
            
        }
        
        
        
        if (isSele == true)
        {
            
            if isPressButton2 == false
            {
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int + 1)
                
                myCell.imgTick.image = UIImage(named: "EmotionTick")
                
                getSaveEmotionCount(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                isPressButton2 = true
            }
            else
            {
                myCell.imgTick.image =  nil
                
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
                
                getSaveEmotionCount1(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                isPressButton2 = false
                
                
            }
            
        }
        else
        {
            
            
            if isPressButton2 == false
            {
                myCell.imgTick.image =  nil
                
                
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int - 1)
                
                getSaveEmotionCount1(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                isPressButton2 = true
                
                
                
            }
            else
            {
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
                
                getSaveEmotionCount(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                myCell.imgTick.image = UIImage(named: "EmotionTick")
                
                isPressButton2 = false
            }
            
        }

        
        case 3 :
        
         
            
        let indexPathData = IndexPath(row: sender.tag, section: 0)
        
        let myCell = tableView.cellForRow(at: indexPathData) as! UploadsEmotionsTableViewCell
        
        let emotionCount = recordEmotionCount[indexPathData.row]
        
        let userCheckedCount = emotionCount["isUserChecked"] as! Int
        
        print("user Checked Count" , userCheckedCount)
        
        
        
        if   userCheckedCount != 1
        {
            
            isSele = true
            
            
            
        }
            
        else
        {
            isSele = false
            
            
        }
        
        
        
        if (isSele == true)
        {
            
            if isPressButton3 == false
            {
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int + 1)
                
                myCell.imgTick.image = UIImage(named: "EmotionTick")
                
                getSaveEmotionCount(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                isPressButton3 = true
            }
            else
            {
                myCell.imgTick.image =  nil
                
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
                
                getSaveEmotionCount1(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                
                isPressButton3 = false
                
                
            }
            
        }
        else
        {
            
            
            if isPressButton3 == false
            {
                myCell.imgTick.image =  nil
                
                
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int - 1 )
                
                getSaveEmotionCount1(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                isPressButton3 = true
                
                
                
            }
            else
            {
                myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
                
                getSaveEmotionCount(sender: (myCell.btnEmotion.titleLabel?.text)!)
                
                myCell.imgTick.image = UIImage(named: "EmotionTick")
                
                
                isPressButton3 = false
            }
            
        }

        default :
        
        print("ok")
    }
    
    
    }
    
    func getSaveEmotionCount(sender : String)
        
    {
        print(sender)
        
        
        let dicValue = ["id":ID ,"user_email":userEmail,"emotion":sender,"status":"1"]
        
        
        getEmotionWebService.getReportMyUploadWebService(urlString: getEmotionUrl.saveEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
            
            print("mathan check",dicc)
            
        })
        
        
        
    }
    
    
    func getSaveEmotionCount1(sender : String)
        
    {
        print(sender)
        
        
        let dicValue = ["id":ID ,"user_email":userEmail,"emotion":sender,"status":"0"]
        
        
        getEmotionWebService.getReportMyUploadWebService(urlString: getEmotionUrl.saveEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
            
            print("mathan check",dicc)
            
            
            
        })
        
        
        
    }
    
    

    
    
    func alertViewReport(sender: UIButton)
        
    {
        
        self.tableView.removeFromSuperview()
        
      //  var textfield1 = UITextField()
        
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
            
           // textfield1 = textField!
            
           // textField?.delegate = self as! UITextFieldDelegate
            
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
                    print("mathan Check",textField.text!)
                    
                    let dicData = [ "user_email" :self.userEmail , "description"  : textField.text! , "file_id" : self.ID , "file_type" : self.FileType] as [String : Any]
                    
                    self.getEmotionWebService.getReportMyUploadWebService(urlString: self.getEmotionUrl.uploadReportAbuse(), dicData: dicData as NSDictionary, callback: {
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
    
        customAlertController.alertViewBgColor =  UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
        
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
