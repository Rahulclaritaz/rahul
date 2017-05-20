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
    
    var screenSize : CGRect!
    var screenWidth : CGFloat!
    var screenHeight : CGFloat!
    var getUploadData = MyUploadWebServices()
    var getUploadURL = URLDirectory.MyUpload()
    
    
    var recordPublicUpload = [[String : Any]]()
    
    var recordPrivateUpload = [[String : Any]]()
    
    var flag : Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target:nil, action:nil)
        
        
        flag = true
        
        getMyUploadPublicList()
        
    }
    
    
    func  getMyUploadPublicList()
    {
        
        flag = true
        
        let  dicData = [ "user_email" : "mathan6@gmail.com"  , "index" : 1 , "limit" : "5"] as [String : Any]
        
        
        
        getUploadData.getPublicPrivateMyUploadWebService(urlString: getUploadURL.publicMyUpload(), dicData: dicData as NSDictionary, callback:{(dicc, err) in
            
            
            print(dicc)
            
              self.recordPublicUpload = dicc
            
            
            DispatchQueue.main.async {
           
                
                self.myUploadCollectionView.reloadData()
                
            }
            
            
            })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        /*
 
 NSDictionary *dicData =@{@"user_email":saveEmail,@"index":@1,@"limit":@15};
 
 
 NSURL *url = [[NSURL alloc]initWithString:@"http://103.235.104.118:3000/queryService/myUploads"];
         
         */
        
      /*
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
       // var width = UIScreen.main.bounds.width
        
        var width = myUploadCollectionView.frame.size.width
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        width = width - 10
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        myUploadCollectionView.collectionViewLayout = layout
        */
        
           }
    
   
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (flag == true)
        {
       return  recordPublicUpload.count
        }
        if ( flag == false)
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
        
        
         let noDataLabel: UILabel = UILabel(frame:CGRect(x: 0, y: 0, width: myUploadCollectionView.bounds.size.width, height: myUploadCollectionView.bounds.size.height))
        
        
     if ( flag == true)
      {
        
          let publicUploadData = recordPublicUpload[indexPath.item]
       
    
           guard (publicUploadData["msg"] as? String) != nil else
           {
            
            
            uploadCell.isHidden = false
            
            myUploadCollectionView.backgroundView?.isHidden = true
            
            uploadCell.deleteInfoView.isHidden = true
            
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
                

              uploadCell.btnplayAudioVideo.setImage(img, for: .normal)
                
                
                uploadCell.imgUpload.backgroundColor = UIColor.getLightBlueColor()
            
                
                }
        
            uploadCell.btnplayAudioVideo.tag =  indexPath.item
        
            uploadCell.btnplayAudioVideo.addTarget(self, action: #selector(myUplaodPlayVideoAudio(sender:)), for: .touchUpInside)
     
            
            uploadCell.btnDeleteVideo.tag = indexPath.row
            
            
            
            uploadCell.btnDeleteVideo.addTarget(self, action: #selector(deleteVideo(sender :)), for: .touchUpInside)
            
         //   uploadCell.btnInfoDelete.addTarget(self, action: #selector(infoUpload(sender:)), for: .touchUpInside)
            

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
            
    
            
            let privateUploadData = recordPrivateUpload[indexPath.item]
            
          // noDataLabel.removeFromSuperview()
    
             guard (privateUploadData["msg"] as? String) != nil else
              {
                
             uploadCell.isHidden = false
                
               myUploadCollectionView.backgroundView?.isHidden = true
                
                uploadCell.deleteInfoView.isHidden = true
            
                
                
            uploadCell.lblUploadTitle.text = privateUploadData["title"] as? String
            
            let privateUploadExe = privateUploadData["filemimeType"] as! String
            
            
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
                let img = UIImage(named: "privateAudio")
                
                
                uploadCell.btnplayAudioVideo.setImage(img, for: .normal)
                
                
                uploadCell.imgUpload.backgroundColor = UIColor.getLightBlueColor()
                
            
                }
            
                uploadCell.btnplayAudioVideo.tag =  indexPath.item
                
                uploadCell.btnplayAudioVideo.addTarget(self, action: #selector(myUplaodPlayVideoAudio(sender:)), for: .touchUpInside)
                
                
                
                uploadCell.btnDeleteVideo.tag = indexPath.row
                
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
        
        
        let myCell = myUploadCollectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPathValue) as! MyUploadCollectionViewCell
        
        
        
        
        if flag == true
        {
     
        let myUploadPublicInfo = recordPublicUpload[indexPathValue.item]
        
        
        let dateInfo = myUploadPublicInfo["updatedAt "] as! String
            
            
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
            
            
            let dateInfo = myUploadPrivateInfo["updatedAt "] as! String
            
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
        
        let indexValue = IndexPath(item: sender.tag, section: 0)
    
        
        let myCell = myUploadCollectionView.dequeueReusableCell(withReuseIdentifier: "myuploadcell", for: indexValue) as! MyUploadCollectionViewCell

 
    myCell.deleteInfoView.isHidden = false
    
    myCell.btnInfoDelete.tag = indexValue.section
    
    myCell.btnInfoDelete.addTarget(self, action: #selector(infoUpload(sender:)), for: .touchUpInside)
    
        myCell.btnDeleteVideo.addTarget(self, action: #selector(videoDelete(sender:)), for: .touchUpInside)
    

    
 
        
        
    }
    
    func videoDelete(sender: UIButton)
        
    {
        
     let indexPathValue = NSIndexPath(item: sender.tag, section: 0)
 

    if flag == true
    {
        
    let currentData = recordPublicUpload[indexPathValue.section]
        
    let infoId  = currentData["_id"] as! String
        
        
     let fileType = currentData["filemimeType"] as! String
        
        
 

    let dicData = ["_id":infoId,"file_type": fileType]
        
 
 
   getUploadData.getDeleteMyUploadWebService(urlString: getUploadURL.deleteMyUpload(), dicData: dicData as NSDictionary, callback: { (dicc,error) in
 
 
   DispatchQueue.main.async {
    
    
 self.myUploadCollectionView.reloadData()
     }
 
 
 
 })
        
        
        }
        
        
        if flag == false
        
        {
            
            let currentData = recordPrivateUpload[indexPathValue.section]
        
            
            
            let infoId  = currentData["_id"] as! String
            
            let fileType = currentData["filemimeType"] as! String
            
            let dicData = ["_id":infoId,"file_type": fileType]
            

            getUploadData.getDeleteMyUploadWebService(urlString: getUploadURL.deleteMyUpload(), dicData: dicData as NSDictionary, callback: { (dicc,error) in
                
                
                DispatchQueue.main.async {
                    
                    
                    
                    self.recordPrivateUpload.remove(at: indexPathValue.section)
                    
                    self.myUploadCollectionView.deleteItems(at: [indexPathValue as IndexPath])
                    
                    
                    self.myUploadCollectionView.reloadData()
                }
                
                
                
            })
            

            
        }
 
    }
 
    func myUplaodPlayVideoAudio( sender : UIButton)
 
    {
 
 
        if flag == true
        {
 
        let indexPathValue = IndexPath(item: sender.tag, section: 0)
 
 
       let myUploadPlayData = recordPublicUpload[indexPathValue.item]
        
        let playUploadTitle = myUploadPlayData["title"] as! String
        
        var playUploadVideoPath = myUploadPlayData["fileuploadPath"] as? String
        
       playUploadVideoPath?.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
    
        
        print(playUploadVideoPath!)
        
    
        let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController" ) as! XPMyUploadPlayViewController
        
        
        playViewController.playTitle = playUploadTitle
        
        playViewController.playUrlString = playUploadVideoPath!
        
  
        
        self.navigationController?.pushViewController(playViewController, animated: true)
        }
        
        if flag == false
        {
            let indexPathValue = IndexPath(item: sender.tag, section: 0)
            
            
            let myUploadPlayData = recordPrivateUpload[indexPathValue.item]
            
            let playUploadTitle = myUploadPlayData["title"] as! String
            
            var playUploadVideoPath = myUploadPlayData["fileuploadPath"] as? String
            
            playUploadVideoPath?.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
            
            
            
            print(playUploadVideoPath!)
            
            
            let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPMyUploadPlayViewController" ) as! XPMyUploadPlayViewController
            
            
            playViewController.playTitle = playUploadTitle
            
            playViewController.playUrlString = playUploadVideoPath!
            
            
            
            self.navigationController?.pushViewController(playViewController, animated: true)
 
        }

    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let widthOfCell = UIScreen.main.bounds.width / 2 - 20
        
        
        let heightOfCell = widthOfCell * 1.15
        
        var returnCell = CGSize(width: widthOfCell, height: heightOfCell)
        
        returnCell.height += 5
        returnCell.width  += 5
        
        return returnCell
        
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
        
        
        
    }

    func  getMyUploadPrivateList()
    {
        
        flag = false
        
        let  dicData = [ "user_email" : "mathan6@gmail.com" , "index" : 1 , "limit" : "5"] as [String : Any]
        
        getUploadData.getPublicPrivateMyUploadWebService(urlString: getUploadURL.privateMyUpload(), dicData: dicData as NSDictionary, callback:{(dicc, err) in
            
            print(dicc)
             self.recordPrivateUpload = dicc
          
            DispatchQueue.main.async {
        
                self.myUploadCollectionView.reloadData()
                
                
                
            }
            
            
            
        })
        
        
        
    }
}





