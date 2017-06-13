//
//  XPMyUploadViewController.swift
//  ixprez
//
//  Created by Quad on 5/17/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPMyUploadViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

{
    
   
    @IBOutlet weak var myUploadCollectionView: UICollectionView!
    var isFromMenu : Bool!
    var screenSize : CGRect!
    
    var screenWidth : CGFloat!
    
    var screenHeight : CGFloat!
    
    var getUploadData = MyUploadWebServices()
    
    var getUploadURL = URLDirectory.MyUpload()
    
    var customAlertController : DOAlertController!
  
    var recordPublicUpload = [[String : Any]]()
    
    var recordPrivateUpload = [[String : Any]]()
    
    var flag : Bool!
    
    var flagDelete : Bool!
    
     let imageCatch =  NSCache<NSString,UIImage>()
    
     var activityIndicator = UIActivityIndicatorView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(isFromMenu)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target:nil, action:nil)
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
                flag = true
        
        flagDelete = true
        
        getMyUploadPublicList()
        setLoadingScreen()
        
    }
    
    
    func setLoadingScreen()
    {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        
        
        self.activityIndicator.center = self.view.center
        
        
        self.myUploadCollectionView.addSubview(self.activityIndicator)
        
    //self.activityIndicator.startAnimating()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        
        return 1
        
    }
    
    func  getMyUploadPublicList()
    {
   
        flag = true
        
        let  dicData = [ "user_email" : "mathan6@gmail.com"  , "index" : 1 , "limit" : "5"] as [String : Any]
        
        
        getUploadData.getPublicPrivateMyUploadWebService(urlString: getUploadURL.publicMyUpload(), dicData: dicData as NSDictionary, callback:{(dicc, err) in
            
            
            
            if err == nil
            {
            print(dicc)
            
              self.recordPublicUpload = dicc
            self.activityIndicator.stopAnimating()
            
            
            
            
            DispatchQueue.main.async
            {
                
                self.myUploadCollectionView.reloadData()
                
            }
            
            }
            
            else
            {
                
               self.activityIndicator.startAnimating()
                
                
            }
            })
        
    }
    
    @IBAction func backButtonAction (_ sender : Any) {
        
        guard (isFromMenu) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning()
          {
        super.didReceiveMemoryWarning()
        
 
           }
    
   
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (flag == true)
        {
       return  recordPublicUpload.count
        }
        if (flag == false)
        {
            return recordPrivateUpload.count
        }

        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
         let uploadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myuploadcell", for: indexPath) as! MyUploadCollectionViewCell
        

        
        uploadCell.layer.cornerRadius = 3.0
        
        uploadCell.layer.masksToBounds = true
        
        uploadCell.layer.borderWidth = 2.0
        
        uploadCell.layer.borderColor = UIColor.getXprezBlueColor().cgColor
        
        
         let noDataLabel: UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: myUploadCollectionView.bounds.size.width, height: myUploadCollectionView.bounds.size.height))
        
        
         uploadCell.imgUpload.image = nil
        
        
     if ( flag == true)
      {
    
           uploadCell.imgDelete.image = UIImage(named: "uploadUnDelete")
        
        
          let publicUploadData = recordPublicUpload[indexPath.item]
    
           guard (publicUploadData["msg"] as? String) != nil else
           {
            
            uploadCell.isHidden = false
            
           myUploadCollectionView.backgroundView?.isHidden = true
            
            uploadCell.deleteInfoView.isHidden = true
            uploadCell.infoViewDetails.isHidden = true
            
            
            uploadCell.lblUploadTitle.text = publicUploadData["title"] as? String
        
            let publicUploadExe = publicUploadData["filemimeType"] as! String
          

           
            
 
            if publicUploadExe == "video/mp4"
               {
 
                let img = UIImage(named: "privatePublicBigPlay")
 
               uploadCell.btnplayAudioVideo.setImage(img, for: .normal)
 
 
                //thumbnailPath
 
                var  publicUploadThum = publicUploadData["thumbnailPath"] as! String
             
               publicUploadThum.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
                
             
              
                uploadCell.imgUpload.getImageFromUrl(publicUploadThum)
            
                }
            
              else
            
               {
                let img = UIImage(named: "privateAudio")
                 uploadCell.imgUpload.image = nil
                 uploadCell.btnplayAudioVideo.setImage(img, for: .normal)
                 uploadCell.imgUpload.backgroundColor = UIColor.getLightBlueColor()
            
                
                }
        
            uploadCell.btnplayAudioVideo.tag =  indexPath.item
            uploadCell.btnplayAudioVideo.addTarget(self, action: #selector(myUplaodPlayVideoAudio(sender:)), for: .touchUpInside)
           uploadCell.btnDeleteVideo.tag = indexPath.item
            

           uploadCell.btnDeleteVideo.addTarget(self, action: #selector(deleteVideo(sender :)), for: .touchUpInside)
            
            
            


        return uploadCell
            
}
    
        
     
            uploadCell.isHidden = true
            noDataLabel.text             = "No data available"
            noDataLabel.textColor        = UIColor.black
            noDataLabel.textAlignment    = .center
            myUploadCollectionView.backgroundView = noDataLabel

            
}
        
if ( flag == false)
{
            
    
            uploadCell.imgDelete.image = UIImage(named: "uploadUnDelete")
    
    
            let privateUploadData = recordPrivateUpload[indexPath.item]
            
          // noDataLabel.removeFromSuperview()
    
             guard (privateUploadData["msg"] as? String) != nil else
              {
                
             uploadCell.isHidden = false
                
               myUploadCollectionView.backgroundView?.isHidden = true
                
                uploadCell.deleteInfoView.isHidden = true
                uploadCell.infoViewDetails.isHidden = true
                
                
                
                
            uploadCell.lblUploadTitle.text = privateUploadData["title"] as? String
            
            let privateUploadExe = privateUploadData["filemimeType"] as! String
            
              uploadCell.imgUpload.image = nil
                
            if privateUploadExe == "video/mp4"
               {
                
                let img = UIImage(named: "privatePublicBigPlay")
                
                uploadCell.btnplayAudioVideo.setImage(img, for: .normal)
                
                
                //thumbnailPath
                
                var  privateUploadThum = privateUploadData["thumbnailPath"] as! String
                
                privateUploadThum.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
                
                
                uploadCell.imgUpload.getImageFromUrl(privateUploadThum)
          
                
               }
                
            else
                
               {
                uploadCell.imgUpload.image = nil
                
                let img = UIImage(named: "privateAudio")
                
                
                uploadCell.btnplayAudioVideo.setImage(img, for: .normal)
                
                
                uploadCell.imgUpload.backgroundColor = UIColor.getLightBlueColor()
                
            
                }
            
                uploadCell.btnplayAudioVideo.tag =  indexPath.item
                
                uploadCell.btnplayAudioVideo.addTarget(self, action: #selector(myUplaodPlayVideoAudio(sender:)), for: .touchUpInside)
                
                
                
             
                
               uploadCell.btnDeleteVideo.tag = indexPath.item
                
               uploadCell.btnDeleteVideo.addTarget(self, action: #selector(deleteVideo(sender :)), for: .touchUpInside)
                
                
             return uploadCell
            
            
}
            

             uploadCell.isHidden = true
             noDataLabel.text             = "No data available"
             noDataLabel.textColor        = UIColor.black
             noDataLabel.textAlignment    = .center
             myUploadCollectionView.backgroundView = noDataLabel

            
}
        
        return uploadCell
        
        
}
    
    func infoUpload(sender : UIButton )
    {
        let indexPathValue = IndexPath(item: sender.tag, section: 0)
        
        
        //let myCell = myUploadCollectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPathValue) as! MyUploadCollectionViewCell
        let myCell = myUploadCollectionView.cellForItem(at: indexPathValue) as! MyUploadCollectionViewCell
        
        myCell.deleteInfoView.alpha = 1
        
        
       // myCell.infoViewDetails.isHidden = false
        
    
        if flag == true
        {
     
        let myUploadPublicInfo = recordPublicUpload[indexPathValue.item]
        
        
        let dateInfo = myUploadPublicInfo["updatedAt"] as! String
            
            
            let dataStringFormatter = DateFormatter()
            
            dataStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let date1 = dataStringFormatter.date(from: dateInfo)
            
            
            print("first formate date1",date1!)
            
            
            let dataStringFormatterTime = DateFormatter()
            
            dataStringFormatterTime.dateFormat = "hh:mm"
            
            let time1 : String = dataStringFormatterTime.string(from: date1!)
            
            print("time data",time1)
            
            
            let dataStringFormatterDay = DateFormatter()
            
            dataStringFormatterDay.dateFormat = "MMM d, YYYY"
            
            let day1 : String = dataStringFormatterDay.string(from: date1!)
            
            print("day data",day1)

            
            
        let privilegeInfo = myUploadPublicInfo["privacy"] as! String
            
        let likeInfo = myUploadPublicInfo["likeCount"] as! Int
            
            
            
            
            myCell.infoDate.text = day1
            
            myCell.infoTime.text = time1
            
            myCell.infoPrivilege.text = privilegeInfo
            
            myCell.infoLikeCount.text = String(likeInfo)
            
            
            
            print(myUploadPublicInfo)
            
            myCell.infoViewDetails.isHidden = false
            
            
        }
        
        if flag == false
        {
           
            let indexPathValue = IndexPath(item: sender.tag, section: 0)
            
            let myUploadPrivateInfo = recordPrivateUpload[indexPathValue.item]
            
            let dateInfo = myUploadPrivateInfo["updatedAt"] as! String
            
            let myDate = String()
            
            
            print ("hhhhhhhhh",myDate.getDatePart(dateString: dateInfo))
            
            
          
            let dataStringFormatter = DateFormatter()
            
            dataStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let date1 = dataStringFormatter.date(from: dateInfo)
            
            
            print("first formate date1",date1!)
            
            
            let dataStringFormatterTime = DateFormatter()
            
            dataStringFormatterTime.dateFormat = "hh:mm"
            
            let time1 : String = dataStringFormatterTime.string(from: date1!)
            
            print("time data",time1)
            
            
            let dataStringFormatterDay = DateFormatter()
            
            dataStringFormatterDay.dateFormat = "MMM d, YYYY"
            
            let day1 : String = dataStringFormatterDay.string(from: date1!)
            
            print("day data",day1)

            
            
            let privilegeInfo = myUploadPrivateInfo["privacy"] as! String
            
            let likeInfo = myUploadPrivateInfo["likeCount"] as! Int
            
            
            myCell.infoDate.text = time1
            
            myCell.infoTime.text = day1
            
            myCell.infoPrivilege.text = privilegeInfo
            
            myCell.infoLikeCount.text = String(likeInfo)
            
            
            
            print(myUploadPrivateInfo)
            
            
            myCell.infoViewDetails.isHidden = false
            
        }
        

        
        
    }
    

func deleteVideo(sender : UIButton)

{

//uploadDelete
  
        let indexValue = IndexPath(item: sender.tag, section: 0)
    
        
        let myCell = myUploadCollectionView.cellForItem(at: indexValue) as! MyUploadCollectionViewCell
    
         myCell.imgDelete.image = nil
    
    
        if flag == true
         {
            
          
            if (flagDelete == true)
            {
    
             myCell.imgDelete.image = UIImage(named: "uploadDelete")
            myCell.deleteInfoView.isHidden = false
                
                myCell.deleteInfoView.alpha = 0.5
                
            
            myCell.infoViewDetails.isHidden = true
                
  
            myCell.btnInfoDelete.tag = indexValue.item
            
            myCell.btnDeleteMyUpload.tag = indexValue.item
            
            myCell.btnDeleteMyUpload.addTarget(self, action: #selector(videoDelete(sender:)), for: .touchUpInside)
            myCell.btnInfoDelete.addTarget(self, action: #selector(infoUpload(sender:)), for: .touchUpInside)
                
                
                flagDelete = false
            }
            else
            {
                
                myCell.deleteInfoView.isHidden = true
                
                 myCell.imgDelete.image = UIImage(named: "uploadUnDelete")
                flagDelete = true
                
 
            }
        }
        
       if flag == false
       {
        
         myCell.imgDelete.image = nil
      
        if (flagDelete == true)
        {
            
            
            
            flagDelete = false
            
            
            myCell.imgDelete.image = UIImage(named: "uploadDelete")
            myCell.deleteInfoView.isHidden = false
            
            myCell.deleteInfoView.alpha = 0.5
            
            
            myCell.infoViewDetails.isHidden = true
            
            
            myCell.btnInfoDelete.tag = indexValue.item
            
            myCell.btnDeleteMyUpload.tag = indexValue.item
            
            myCell.btnDeleteMyUpload.addTarget(self, action: #selector(videoDelete(sender:)), for: .touchUpInside)
            myCell.btnInfoDelete.addTarget(self, action: #selector(infoUpload(sender:)), for: .touchUpInside)
        }
        else
        {
            
            myCell.deleteInfoView.isHidden = true
            
            myCell.imgDelete.image = UIImage(named: "uploadUnDelete")
            flagDelete = true
            
            
        }
        
        }
    
    }
    
    func videoDelete(sender: UIButton)
        
    {
        
     let indexPathValue = NSIndexPath(item: sender.tag, section: 0)
 

         if flag == true
          {
        
               let currentData = recordPublicUpload[indexPathValue.item]
        
               let infoId  = currentData["_id"] as! String
        
        
               let fileTypeData = currentData["filemimeType"] as! String
        
               let fileType : String!
        
    
        if  (fileTypeData == "video/mp4")
        {
            
            fileType = "video"
        }
        else
        {
            
            fileType = "audio"
        }
         
        
        getDeleteAction(infoId: infoId, fileType: fileType, indexPath: indexPathValue as IndexPath)
        
        
        }
        
        
        if flag == false
        
        {
            
            let currentData = recordPrivateUpload[indexPathValue.item]
        
            
            
            let infoId  = currentData["_id"] as! String
            
            let fileType : String!
            
            
            let fileTypeData = currentData["filemimeType"] as! String
       
            
            
            if  (fileTypeData == "video/mp4")
            {
                
                fileType = "video"
            }
            else
            {
                
                fileType = "audio"
            }
            

            
           
            
  getDeleteAction(infoId: infoId, fileType: fileType, indexPath: indexPathValue as IndexPath)
            
        }
 
    }
 
    
    func getDeleteAction(infoId : String ,fileType : String,indexPath : IndexPath)
    {
        let message = "Are You Sure You Want tp Delete This?"
        let cancelButtonTitle = "Cancel"
        let otherButtonTitle = "Delete"
        
            if flag == true
        {
        
        let dicData = ["file_type":fileType,"id": infoId]
        
        
        customAlertController = DOAlertController(title: nil, message: message, preferredStyle: .alert)
        
        changecustomAlertController()
        
         let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
            action in
            
        })
        
        let otherAction = DOAlertAction(title: otherButtonTitle, style: .destructive, handler:{
            
            action in
            
            self.getUploadData.getDeleteMyUploadWebService(urlString: self.getUploadURL.deleteMyUploadPublic(), dicData: dicData as NSDictionary, callback: { (dicc,error) in
           
                
                
                  self.recordPublicUpload.remove(at: indexPath.item)
                
                DispatchQueue.main.async
                {
            
        
                    
                   self.myUploadCollectionView.deleteItems(at: [indexPath])
                
                    self.myUploadCollectionView.reloadData()
                }
                
            })
            
                
           
            
        })
        
        
        customAlertController.addAction(cancelAction)
        
        customAlertController.addAction(otherAction)
        
        
        self.present(customAlertController, animated: true, completion: nil)
        
        }
        
        if flag == false
        {
                    let dicData = ["file_type":fileType,"id": infoId]
            
            
            customAlertController = DOAlertController(title: nil, message: message, preferredStyle: .alert)
            
            changecustomAlertController()
            
            
            // customAlertController.overlayColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:0.1)
            
            let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
                action in
                
                print("hi")
            })
            
            let otherAction = DOAlertAction(title: otherButtonTitle, style: .default, handler:{
                
                action in
                
                self.getUploadData.getDeleteMyUploadWebService(urlString: self.getUploadURL.deleteMyUploadPrivate(), dicData: dicData as NSDictionary, callback: { (dicc,error) in
                    
                    
                    
                 self.recordPrivateUpload.remove(at: indexPath.item)
                    DispatchQueue.main.async
                    {
                    
                        self.myUploadCollectionView.deleteItems(at: [indexPath])
                        
                        self.myUploadCollectionView.reloadData()
                    }
                    
                    
               
                })
                
                
                
                
                
            })
            
            
            customAlertController.addAction(cancelAction)
            
            customAlertController.addAction(otherAction)
            
            
            self.present(customAlertController, animated: true, completion: nil)
            
   
        }
        
        
    }
    
    func changecustomAlertController()
    {
        
        customAlertController.alertView.layer.cornerRadius = 6.0
        
        customAlertController.alertViewBgColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:0.7)
        
        customAlertController.titleFont = UIFont(name: "Mosk", size: 17.0)
        customAlertController.titleTextColor = UIColor.green
        
        customAlertController.messageFont = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.messageTextColor = UIColor.black
        
        customAlertController.alertView.sizeToFit()
        
        customAlertController.buttonFont[.cancel] = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.buttonBgColor[.cancel] = UIColor.getLightBlueColor()
        
        customAlertController.buttonFont[.default] = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.buttonBgColor[.default] = UIColor.getOrangeColor()
        
    }
    
    
    func myUplaodPlayVideoAudio( sender : UIButton)
 
    {
 
 
        if flag == true
        {
 
        let indexPathValue = IndexPath(item: sender.tag, section: 0)
 
 
        let myUploadPlayData = recordPublicUpload[indexPathValue.item]
        
        let playUploadTitle = myUploadPlayData["title"] as! String
        
        var playUploadVideoPath = myUploadPlayData["fileuploadPath"] as? String
            
        let playFilemimeType  = myUploadPlayData["filemimeType"] as! String
            
        let playID = myUploadPlayData["_id"] as! String
        
       playUploadVideoPath?.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
    
            let playUploadLikeCount = myUploadPlayData["likeCount"] as! Int
            let playUploadViewCount = myUploadPlayData["viewed"] as! Int
            let playUploadSmiley = myUploadPlayData["emotionCount"] as! Int
 
        
    
        let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController" ) as! XPMyUploadPlayViewController
        
        
        playViewController.playTitle = playUploadTitle
        
        playViewController.playUrlString = playUploadVideoPath!
        
        playViewController.playLike = playUploadLikeCount
        playViewController.playView = playUploadViewCount
        playViewController.playSmiley = playUploadSmiley
            
        playViewController.nextID = playID
            
        playViewController.nextFileType = playFilemimeType
            
            
        
        self.navigationController?.pushViewController(playViewController, animated: true)
        }
        
        if flag == false
        {
            let indexPathValue = IndexPath(item: sender.tag, section: 0)
            
            
            let myUploadPlayData = recordPrivateUpload[indexPathValue.item]
            
            let playUploadTitle = myUploadPlayData["title"] as! String
            
            var playUploadVideoPath = myUploadPlayData["fileuploadPath"] as? String
            
            playUploadVideoPath?.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
            
            
            let playFilemimeType  = myUploadPlayData["filemimeType"] as! String
            
            let playID = myUploadPlayData["_id"] as! String
            
            let playUploadLikeCount = myUploadPlayData["likeCount"] as! Int
            let playUploadViewCount = myUploadPlayData["viewed"] as! Int
            let playUploadSmiley = myUploadPlayData["emotionCount"] as! Int
            print(playUploadVideoPath!)
            
            
            let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController" ) as! XPMyUploadPlayViewController
            
            
            playViewController.playTitle = playUploadTitle
            
            playViewController.playUrlString = playUploadVideoPath!
            playViewController.playLike = playUploadLikeCount
            playViewController.playView = playUploadViewCount
            playViewController.playSmiley = playUploadSmiley
            
            playViewController.nextID = playID
            
            playViewController.nextFileType = playFilemimeType
            
            
            
            self.navigationController?.pushViewController(playViewController, animated: true)
 
        }

    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
      
        if indexPath.item % 2 == 0
        {
        
        let widthOfCell = UIScreen.main.bounds.width / 2 - 20
        
        
        let heightOfCell = widthOfCell * 1.15
        
        var returnCell = CGSize(width: widthOfCell, height: heightOfCell)
        
        returnCell.height += 5
        returnCell.width  += 5
        
        return returnCell
        }
        
        else
        {
            let widthOfCell = UIScreen.main.bounds.width / 2 - 20
            
            
            let heightOfCell = widthOfCell * 1
            
            var returnCell = CGSize(width: widthOfCell, height: heightOfCell)
            
          
            returnCell.height += 5
            returnCell.width  += 5
            
            return returnCell
        }
      //  CGFloat widthOfCell =(self.view.frame.size.width-30)/2;
       // CGFloat heightOfCell =widthOfCell * 1.33;
        
        
        //return CGSize(width: myUploadCollectionView.frame.size.width / 2 - 20, height: myUploadCollectionView.frame.size.width / 2 - 20 )
        
        
      //  return CGSize(width: widthOfCell, height: heightOfCell)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //let leftRightInset = collectionView.frame.size.width / 14.0
        return UIEdgeInsetsMake(10, 10, 10, 10)
      
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        
        var header :  HeaderMyuploadCollectionReusableView!
        
     
        if kind == UICollectionElementKindSectionHeader {
            header =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                withReuseIdentifier: "header", for: indexPath)
                as? HeaderMyuploadCollectionReusableView
            
            header.segmentPublicPrivateUpload.addTarget(self, action: #selector(loadData(sender :)), for: .valueChanged)

         
                       
        }
        return header!
        
        
        
    }
  
    func loadData(sender : UISegmentedControl)
    {
       
        
        if sender.selectedSegmentIndex == 0
        {
           getMyUploadPublicList()

            
            print ("publicvideo")
        }
        
        else if(sender.selectedSegmentIndex == 1)
        {
            
            print("private Video")
            
           getMyUploadPrivateList()
            
            
            
        }
        
        else
        {
            
            print("Video")
        }
        
        
        
    }

    func  getMyUploadPrivateList()
    {
        
        flag = false
        
        let  dicData = [ "user_email" : "mathan6@gmail.com" , "index" : 1 , "limit" : "5"] as [String : Any]
        
        getUploadData.getPublicPrivateMyUploadWebService(urlString: getUploadURL.privateMyUpload(), dicData: dicData as NSDictionary, callback:{(dicc, err) in
            
            
            if err == nil
            {
            print(dicc)
                
                self.activityIndicator.stopAnimating()
                
             self.recordPrivateUpload = dicc
          
            DispatchQueue.main.async {
        
                self.myUploadCollectionView.reloadData()
                
                
                
            }
            }
            else
            {
               self.activityIndicator.startAnimating()
                
            }
            
            
        })
        
        
        
    }
}





