//
//  XPUploadsEmotionsViewController.swift
//  ixprez
//
//  Created by Quad on 5/23/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

//http://103.235.104.118:3000/commandService/emotionCount

//{"user_email":"jayanthan.s@quadrupleindia.com","file_id":"5773af299b0022a13cc77e8d"}

class XPUploadsEmotionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    var recordEmotionCount = [[String :Any]]()
    
    var arrEmotion = ["Like","Happy","Angry","Sad","Surprising"]
    
    var getEmotionUrl = URLDirectory.MyUpload()
    
    var getEmotionWebService = MyUploadWebServices()
    
    var flagTick : Bool!
    
    
    //OutLet
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        flagTick = true
     
        super.viewDidLoad()

       getEmotionCount()
        
        // Do any additional setup after loading the view.
    }

    func getEmotionCount()
    {
      let dicValue = ["user_email":"jayanthan.s@quadrupleindia.com","file_id":"5773af299b0022a13cc77e8d"]
        
        
        
        getEmotionWebService.getPublicPrivateMyUploadWebService(urlString: getEmotionUrl.uploadEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,eror) in
         
            
            
            
            self.recordEmotionCount = dicc
            
            DispatchQueue.main.async {
                
             self.tableView.reloadData()
                
            }
            
            
        })
        
        
        
      /*  getEmotionWebService.getMyUploadEmotionCount(urlString: getEmotionUrl.uploadEmotionCount(), dicData: dicValue as NSDictionary, callback: { (dicc,error) in
            print(dicc)
            
            self.recordEmotionCount = dicc
            
        })*/
        
        
        
    }
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
        
            
        cell.btnEmotion.setTitle(arrEmotion[indexPath.row], for: .normal)
    
        cell.lblEmotionCount.text = String(emotionCount["count"] as! Int)

        cell.imgTick.image = UIImage(named: "")
    
        let fullName    = emotionCount["emotion"] as! String
        let fullNameArr = fullName.components(separatedBy: "   ")
        
        let name    = fullNameArr[0]
        let surname = fullNameArr[1]
        
        
        cell.lblEmotionEmoji.text = name
        
        cell.btnEmotion.titleLabel?.text =  surname
  
        
        cell.lblEmotionCount.layer.cornerRadius = cell.lblEmotionCount.frame.width/2
        
        cell.lblEmotionCount.backgroundColor = UIColor.getOrangeColor()
        
        cell.btnEmotion.addTarget(self, action: #selector(countEmotion(sender:)), for: .touchUpInside)
       
        return cell
        
        
    }
    //reportcell
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
   {
    
    let myCell = tableView.dequeueReusableCell(withIdentifier: "reportcell") as! MyUploadReportAbuseTableViewCell
    
    myCell.btnReport.addTarget(self, action: #selector(alertView(sender:)), for: .touchUpInside)
   
    return myCell.contentView
    
    }
    
    func alertView(sender : UIButton)
    {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
        
    }
    
    
    func countEmotion(sender : UIButton)
    {
        let indexPathData = IndexPath(row: sender.tag, section: 0)
        
        let myCell = tableView.cellForRow(at: indexPathData) as! UploadsEmotionsTableViewCell
        
        let emotionCount = recordEmotionCount[indexPathData.row]
        
        
        if sender.isSelected == false
        {
     
            myCell.imgTick.image = UIImage(named: "check-mark-red-11.png")
            
            myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int + 1)
            
            sender.isSelected = true
            
        }
       else
        {
            
            myCell.imgTick.image =  nil
            
            myCell.lblEmotionCount.text = String(emotionCount["count"] as! Int)
            
            sender.isSelected = false
            
        }
        
    }



}
