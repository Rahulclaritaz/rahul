
//  IXPrivateViewController.swift
//  ixprez

//  Created by Quad on 5/8/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.


import UIKit
import AVKit
import AVFoundation

class IXPrivateViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,sectionData
{
    //Declaration 
    
    
    var getEmotionUrl = URLDirectory.MyUpload()
    
    var getEmotionWebService = MyUploadWebServices()
    
    var typeCon: ContactType?
    
    var isFromMenu = Bool()
    var recordPrivateData = [[String : Any]]()

    var getPrivateWebData = PrivateWebService()
    
    var getPrivateURL = URLDirectory.PrivateData()
    
    var customAlertController : DOAlertController!
    
    var imgGesture : UIGestureRecognizer!
   
    let avplayer = AVPlayerViewController()
    
    var player = AVPlayer()
    
    var privateType : String!
    
    var privateIdValue : String!
    
    var privatefromEmail : String!
    
    var privateIndexPathLength : Int!
    
    var userEmail : String!
    
    var nsuerDefault = UserDefaults.standard
    
   @IBOutlet weak var  myImage = UIImageView()
    
    var addContactList = [ContactList]()
    
    var checkAcceptUser : Bool!
    
    var showAddContact : Bool!
    
    var userID: String!
    
    
    
    lazy var refershController : UIRefreshControl = {
        
      let refersh = UIRefreshControl()
        
        refersh.addTarget(self, action: #selector(getPrivateData), for: .valueChanged)
    
    return refersh
        
    }()
    
    
    @IBOutlet weak var privateTableView: UITableView!
    
    override func awakeFromNib() {
        
        
    }
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
         getContact()
        
        checkAcceptUser = false
        showAddContact = false
        
        
         userEmail = nsuerDefault.string(forKey: "emailAddress")
        
         
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
            
            
        }
        else
        {
            
            print("NO Internet Connection")
            
            let alertData = UIAlertController(title: "No Internet Connection ", message: "Make sure Your device is connected to the internet", preferredStyle: .alert)
            
            alertData.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alertData, animated: true, completion: nil)
            
            
        }

        
        getBackgroundView()

       
        
        print(userEmail)
        
        
       //self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style: .plain, target:nil, action:nil)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        privateTableView.dataSource = self
        privateTableView.delegate = self
        
        privateTableView.addSubview(refershController)
        
        privateTableView.sendSubview(toBack: refershController)
        
        self.view.backgroundColor = UIColor.getViewColor()
        
        privateTableView.backgroundColor = UIColor.clear
        
//        self.getPrivateData()
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        self.getPrivateData()

        
    }
    
    
    func getBackgroundView()
    {
        
        myImage?.frame = CGRect(x: 0, y: 0, width: privateTableView.frame.size.width, height: privateTableView.frame.size.height)
        
        myImage?.image = UIImage(named: "SearchCaughtUPBGImage")
        
        myImage?.contentMode = .scaleAspectFit
  
    }
    
    
    @IBAction func  backButtonAction( _sender : Any) {
        
        guard (isFromMenu) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }

    
    func getPrivateData( )
    {
        
        
        let privateDic : NSDictionary = ["index":0,"user_id": userEmail,"limit":30 ]
        
        getPrivateWebData.getPrivateDataWebService(urlString: getPrivateURL.privateDataUrl(), dicData: privateDic, callback:
            {
                (dicc,responseCode,erro) in
                
                print("check private web service data",dicc)
                
                let jsonScrollData : Int = dicc["last"] as! Int
                let jsonArrayValue : NSArray = dicc["Records"] as! NSArray
                
                self.recordPrivateData = jsonArrayValue as! [[String : Any]]
                self.refershController.beginRefreshing()
                DispatchQueue.main.async{
                    
                    
                    
                    self.privateTableView.reloadData()
                    
                    self.refershController.endRefreshing()
                    
                }
                
        })
        
        
        
    }


func getRefersh( action : UIRefreshControl)
{
  
    refershController.beginRefreshing()
    
    
}
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 6
        
    }
 
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)

    {
        
        view.tintColor = UIColor.getXprezBlueColor()
    }
   func numberOfSections(in tableView: UITableView) -> Int
   {
    
    
    return recordPrivateData.count
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int

    {
    
        return  1
        
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let privateData = recordPrivateData[indexPath.section]
        
        let privatecell = tableView.dequeueReusableCell(withIdentifier: "privatecell", for: indexPath) as! PrivateAudioVideoTableViewCell
        
     
        
        
        guard let getData = privateData["msg"] as? String else
        {
            myImage?.isHidden = true
            privatecell.isHidden = false
            privatecell.lblPrivateName.text = privateData["UpName"] as? String
            
            privatecell.lblPrivateName.textColor = UIColor.getLightBlueColor()
            
            privatecell.lblPrivateTitle.text = privateData["title"] as? String
            
            
            let checkIsContact = privateData["from_email"] as! String
            let username =  privateData["title"] as? String
       
            let string1 : String = privateData["createdAt"] as! String
        
            let dataStringFormatter = DateFormatter()
            
            dataStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let date1 = dataStringFormatter.date(from: string1)
            
            
            print("first formate date1",date1!)
            
            
            let dataStringFormatterTime = DateFormatter()
            
            dataStringFormatterTime.dateFormat = "hh:mm"
            
            let time1 : String = dataStringFormatterTime.string(from: date1!)
            
            print("time data",time1)
            
            
            let dataStringFormatterDay = DateFormatter()
            
            dataStringFormatterDay.dateFormat = "MMM d, YYYY"
            
            let day1 : String = dataStringFormatterDay.string(from: date1!)
            
            print("day data",day1)
            
            
            privatecell.lblPrivateTime.text = time1
            
            privatecell.lblPrivateDate.text =  day1
            
            privatecell.layer.cornerRadius = 5.0
            
            
            privatecell.layer.masksToBounds = true
            
            privatecell.imgPrivateVideoAudio.layer.cornerRadius = 5.0
            
            
            privatecell.backgroundColor = UIColor.getPrivateCellColor()
            
            
            let privatefilemimeType = privateData["filemimeType"] as? String
            
            
            if privatefilemimeType == "video/mp4"
            {
                let btnplayVideo = UIImage(named: "privateplay")
                
                //privatecell.btnPrivatePlay.setImage(btnplayVideo, for: .normal)
                
                privatecell.imgAV.image = btnplayVideo
                
               
                var privatethumbnailPath = privateData["thumbnailPath"] as? String
                
                
                privatethumbnailPath?.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
                
                print("privatethumbnailPath",privatethumbnailPath!)
                
                privatecell.imgPrivateVideoAudio.getImageFromUrl(privatethumbnailPath!)
                
            
                
            }
            else
            {
                
                let btnplayaudio = UIImage(named: "privateAudio" )
                
               // privatecell.btnPrivatePlay.setImage( btnplayaudio , for:UIControlState.normal)
                
                 privatecell.imgAV.image = btnplayaudio
                
                privatecell.imgPrivateVideoAudio.backgroundColor = UIColor.getLightBlueColor()
                
            }
            
            
            privatecell.btnPrivatePlay.tag = indexPath.section
            
            privatecell.btnPrivatePlay.addTarget(self, action: #selector(playVideoAudio(passUrl:)), for: .touchUpInside)
            
            
            if deviceEmailID.contains(checkIsContact)
            {
                privatecell.contentView.backgroundColor = UIColor.clear
                
            }
            else
            {
                
                if checkAcceptUser == false
                {
                    privatecell.contentView.backgroundColor = UIColor.red
                    
                }
                else
                    
                {
                    
                    if !deviceEmailID.contains(checkIsContact)
                    {
                        createAddressBookContactWithFirstName(username!, lastName: "", email:  checkIsContact , phone: "", image: UIImage(named: "bg_reg.png" ))
                        
                         privatecell.contentView.backgroundColor = UIColor.clear
                        
                        getContact()
                        
                    }
                    else
                    {
                        
                        privatecell.contentView.backgroundColor = UIColor.clear
                        
                    }
                    
                    
                    
                }
                
            }

            
        
        return privatecell
            

  }
        
        if ( getData.isEqual("No Records"))
        {
            privatecell.isHidden = true
            myImage?.isHidden = false
            
           // let noDataLabel: UILabel     = UILabel(frame:CGRect(x: 0, y: 0, width: privateTableView.bounds.size.width, height: privateTableView.bounds.size.height))
            //noDataLabel.text             = "No data available"
          // noDataLabel.textColor        = UIColor.black
           // noDataLabel.textAlignment    = .center
           // noDataLabel.textColor  = UIColor.white
           // noDataLabel.font = UIFont(name: "Mosk", size: 20)
            privateTableView.backgroundView = myImage
            
            privateTableView.separatorStyle = .none
            
        }
        
        
    return  privatecell
        
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
       
   
       var  privateDataDic = self.recordPrivateData[indexPath.section]
    
        self.privateType = privateDataDic["filemimeType"] as? String
    
        self.privateIdValue = privateDataDic["_id"] as? String
        
        self.privatefromEmail = privateDataDic["from_email"] as? String
        
        privateIndexPathLength = indexPath.section
        
        
        print("check mathan email_id",self.privatefromEmail)
        
        
        print(privateIndexPathLength)
        
        
      
        if  self.privateType == "video/mp4"
        {
            
            self.privateType = "video"
        }
            
        else
        {
            self.privateType = "audio"
        }

       
        
        let blockAction = UITableViewRowAction(style: .normal, title: "   ", handler:
        {
            (action,index) in
          
        
            if deviceEmailID.contains(self.privatefromEmail)
            {
                self.showAddContact = true
            }
            else
            {
                self.showAddContact = false
            }
            print("block")
        
            self.getBlockAction()
            
            
            
        })
        
    blockAction.backgroundColor = UIColor(patternImage: UIImage(named: "privateBlock")!)
        
       // blockAction.backgroundColor = UIColor.red
        
        
        
        let rejectAction = UITableViewRowAction(style: .normal, title: "   ", handler: {
            (action,index) in
            print("reject")
            
           self.getRejectAction()
            
        })
        
      rejectAction.backgroundColor = UIColor(patternImage: UIImage(named: "privateReject")!)
       
      //  rejectAction.backgroundColor = UIColor.green
        
        
        let acceptAction = UITableViewRowAction(style: .normal, title: "   ", handler: {
            (action,index) in
         
            print("accept")
            
            
            self.getAcceptAction()
            
     
            
        })
        
       acceptAction.backgroundColor = UIColor(patternImage: UIImage(named: "privateAccept")!)
        
        
   // acceptAction.backgroundColor = UIColor.blue
        
    return [blockAction ,rejectAction ,acceptAction]
        
    }
    
    func playVideoAudio(passUrl : UIButton)
    {
       // let indexPath = Int(passUrl.tag)
        
        
       // let currentCell = privateTableView.cellForRow(at: indexPath) as! PrivateAudioVideoTableViewCell
        
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:[Sender tag]];
        

        let indexPathValue = NSIndexPath(row: 0, section: passUrl.tag)
        
        var playPrivateData = recordPrivateData[indexPathValue.section]
        
        var playVideoPath = playPrivateData["tokenizedUrl"] as? String
        
        let playVideoTitle = playPrivateData["title"] as? String
        
        let playVideoFromEmail = playPrivateData["from_email"] as? String
        
        
        let playId = playPrivateData["_id"] as? String
        
         let playType = playPrivateData["filemimeType"] as? String
        
        let playTypeValue : String?
   
        if  playType == "video/mp4"
        {
            
            playTypeValue = "video"
        }
            
        else
        {
            playTypeValue = "audio"
        }
        
        
        //http://192.168.1.20:3000
        
//        playVideoPath?.replace("/root/cpanel3-skel/public_html/Xpress/", with: "http://103.235.104.118:3000/")
        
        
       // playVideoPath?.replace("/var/www/html/xpresslive/Xpress/", with: "http://192.168.1.20:3000/")
        
        
        print(playVideoPath!)
        
        
        
        let playViewController = self.storyboard?.instantiateViewController(withIdentifier: "XPPriavtePlayVideoAudioViewController") as! XPPriavtePlayVideoAudioViewController
        
        playViewController.privateUrlString = playVideoPath!
        
        playViewController.privateTitle = playVideoTitle!
        
        playViewController.idValue = playId!
        
        playViewController.typeVideo = playTypeValue!
        
        playViewController.fromEmail = playVideoFromEmail!
        
        playViewController.sectionNo = passUrl.tag
        
        playViewController.delegate = self
        
       
    
    self.navigationController?.pushViewController(playViewController, animated: true)
      

        
        
        
    }
    
    
    func sectionnumber( no : Int )
    
    {
        
        // remove the data from array
    
        recordPrivateData.remove(at: no)
      
        // remove the section from tableview
        
        self.privateTableView.beginUpdates()
        privateTableView.deleteSections([no], with: .automatic)
        self.privateTableView.endUpdates()
        
        
        
        
    }
    
    func getBlockAction()
    {
        
        if showAddContact == false
        {
        
        let title = self.privatefromEmail
        let message = "can’t Express themselves to you anymore. Sure you want ro proceed?"
        let cancelButtonTitle = "Cancel"
        let otherButtonTitle = "Reject & Block"
        let otherButtonTitle1 = "Add Contact"
        let otherBottonTitle2 = "Report SPAM"
       
        print(self.privatefromEmail)
        print(self.privateIdValue)
        print(self.privateType)
        
        customAlertController = DOAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.changecustomAlertController()
        
        // customAlertController.overlayColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:0.1)
        
        let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
            action in
            
            print("hi")
        })
        
        let otherAction = DOAlertAction(title: otherButtonTitle, style: .default, handler:{
            
            action in
            
            
            
            let dicValue = [ "user_email" : self.userEmail , "blocked_email": self.privatefromEmail ]
            
            
            self.getPrivateWebData.getPrivateAcceptRejectWebService(urlString: self.getPrivateURL.privateBlockAudioVideo(), dicData: dicValue as NSDictionary, callback: {
                
                (dicc, erro) in
                
                
                
                
                
                DispatchQueue.main.async {
                    
                    self.privateTableView.beginUpdates()
                    // Remove item from the array
                    self.recordPrivateData.remove(at: self.privateIndexPathLength)
                  
                
                    // Delete the row from the table view
                 
                    self.privateTableView.deleteSections([self.privateIndexPathLength], with: .fade)
                    
                    self.privateTableView.endUpdates()
                    
                }

                
                if ((dicc["status"] as! String).isEqual("OK"))
                    
                {
                    let dicValue = [ "id" : self.privateIdValue , "video_type" : self.privateType , "feedback" : "0"]
                
                    
                    self.getPrivateWebData.getPrivateAcceptRejectWebService(urlString: self.getPrivateURL.privateAcceptRejectAudioVideo(), dicData: dicValue as NSDictionary, callback:{
                        
                        (dicc,err)  in
                        
                    })
 
                    
              
                    
                }
                
                
            })
            
            
            
        })
        
        let otherAction1 = DOAlertAction(title: otherButtonTitle1, style: .default, handler: { action in
            
            self.checkAcceptUser = true
            
            DispatchQueue.main.async {
                
                /* for  i  in 0...self.recordPrivateData.count
                 {
                 let indexPath = IndexPath(row: 0, section: i)
                 
                 self.privateTableView.rectForRow(at: indexPath)
                 }*/
                
                self.privateTableView.reloadData()
                
                
            }
            
            print("add")
        })
        
        let otherAction2 = DOAlertAction(title: otherBottonTitle2, style: .default, handler: { action in
            
            
            self.dismiss(animated:true, completion: {
                
                () -> Void in
                
                
                
                let title = "Report Abuse"
                //let message = "A message should be a short, complete sentence."
                let cancelButtonTitle = "DISCARD"
                let otherButtonTitle = "POST"
                
                self.customAlertController = DOAlertController(title: title, message: nil, preferredStyle: .alert)
                
                self.changecustomAlertController()
                
                // Add the text field for text entry.
                
                
                // alert.addTextField(configurationHandler: textFieldHandler)
                
                self.customAlertController.addTextFieldWithConfigurationHandler { textField in
                    
                    
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
                            
                            let dicData = [ "user_email" :self.privatefromEmail , "description"  : textField.text! , "file_id" : self.privateIdValue , "file_type" : self.privateType] as [String : Any]
                            
                            self.getEmotionWebService.getReportMyUploadWebService(urlString: self.getEmotionUrl.uploadReportAbuse(), dicData: dicData as NSDictionary, callback: {
                                (dicc,erro) in
                                
                                print(dicc)
                                
                                
                            })
                            
                            
                        }
                    }
                    
                    
                }
                
                // Add the actions.
                self.customAlertController.addAction(cancelAction)
                self.customAlertController.addAction(otherAction)
                
                self.present(self.customAlertController , animated: true, completion: nil)

                
                
                
            })
            
            
            
            

            
        })
        
        
        
        customAlertController.addAction(otherAction1)
        
        customAlertController.addAction(otherAction2)
        
        

        
        customAlertController.addAction(cancelAction)
        
        customAlertController.addAction(otherAction)
        
        
        self.present(customAlertController, animated: true, completion: nil)
        
        }
        else
        {
          
            let title = self.privatefromEmail
            let message = "can’t Express themselves to you anymore. Sure you want ro proceed?"
            let cancelButtonTitle = "Cancel"
            let otherButtonTitle = "Reject & Block"
            
            print(self.privatefromEmail)
            print(self.privateIdValue)
            print(self.privateType)
            
            customAlertController = DOAlertController(title: title, message: message, preferredStyle: .alert)
            
            self.changecustomAlertController()
            
            // customAlertController.overlayColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:0.1)
            
            let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
                action in
                
                print("hi")
            })
            
            let otherAction = DOAlertAction(title: otherButtonTitle, style: .default, handler:{
                
                action in
                
                
                
                let dicValue = [ "user_email" : self.userEmail , "blocked_email": self.privatefromEmail ]
                
                
                self.getPrivateWebData.getPrivateAcceptRejectWebService(urlString: self.getPrivateURL.privateBlockAudioVideo(), dicData: dicValue as NSDictionary, callback: {
                    
                    (dicc, erro) in
                    
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        self.privateTableView.beginUpdates()
                        // Remove item from the array
                        self.recordPrivateData.remove(at: self.privateIndexPathLength)
                        
                        
                        // Delete the row from the table view
                        
                        self.privateTableView.deleteSections([self.privateIndexPathLength], with: .fade)
                        
                        self.privateTableView.endUpdates()
                        
                    }
                    
                    
                    if ((dicc["status"] as! String).isEqual("OK"))
                        
                    {
                        let dicValue = [ "id" : self.privateIdValue , "video_type" : self.privateType , "feedback" : "0"]
                        
                        
                        self.getPrivateWebData.getPrivateAcceptRejectWebService(urlString: self.getPrivateURL.privateAcceptRejectAudioVideo(), dicData: dicValue as NSDictionary, callback:{
                            
                            (dicc,err)  in
                            
                        })
                        
                        
                        
                        
                    }
                    
                    
                })
                
                
                
            })
           
            
            customAlertController.addAction(cancelAction)
            
            customAlertController.addAction(otherAction)
            
            
            self.present(customAlertController, animated: true, completion: nil)
        }
        
   
        
    }

    func getRejectAction()
    {
        let title = self.privatefromEmail
        let message = "wanted to Xpress this to you badly . Are you sure you want to reject it?"
        let cancelButtonTitle = "Cancel"
        let otherButtonTitle = "Confirm Rejection"
        print(self.privatefromEmail)
        print(self.privateIdValue)
        print(self.privateType)
        
        
        customAlertController = DOAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.changecustomAlertController()
        
        // customAlertController.overlayColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:0.1)
        
        let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
            action in
            
            print("hi")
        })
        
        let otherAction = DOAlertAction(title: otherButtonTitle, style: .default, handler:{
            
            action in
            
            let dicValue = [ "id" : self.privateIdValue , "video_type" : self.privateType , "feedback" : "0"]
            
            
            self.getPrivateWebData.getPrivateAcceptRejectWebService(urlString: self.getPrivateURL.privateAcceptRejectAudioVideo(), dicData: dicValue as NSDictionary, callback:{
                
                (dicc,err)  in
                
            
                if ((dicc["status"] as! String).isEqual("OK"))
                    
                {
                    
                    let dicData = [ "description" : "Accept","file_id" :self.privateIdValue ,"file_type" : self.privateType ,"user_email" :self.privatefromEmail ] as [String : Any]
                    
                    
                    
                    self.getPrivateWebData.getPrivateData(urlString: self.getPrivateURL.audioVideoReportAbuse(), dicData: dicData, callback: {
                        (dic, err) in
                        
                        print("check Private Data report Abuse",dic)
                        
                    })
                    

                    
                    DispatchQueue.main.async {
                        
                          self.privateTableView.beginUpdates()
                        // Remove item from the array
                        self.recordPrivateData.remove(at: self.privateIndexPathLength)
                        
                        // Delete the row from the table view
                 
                        self.privateTableView.deleteSections([self.privateIndexPathLength], with: .fade)
                        
                        self.privateTableView.endUpdates()
                        
                    }
                    
                }
                
                
            })
            
            
            
        })
        
        
        customAlertController.addAction(cancelAction)
        
        customAlertController.addAction(otherAction)
        
        
        self.present(customAlertController, animated: true, completion: nil)
        
        

        
    }
    
 
    func getAcceptAction()
    {
    let title = self.privatefromEmail
    let message = "It's your turn to xpress! Want to reply right now and xpress yourself back to them? Do it"
    let cancelButtonTitle = "Cancel"
    let otherButtonTitle = "Xpress it"
    

  print(self.privatefromEmail)
    print(self.privateIdValue)
        print(self.privateType)
    customAlertController = DOAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.changecustomAlertController()
        
      // customAlertController.overlayColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha:0.1)
        
        let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .cancel, handler: {
            action in
            
            print("hi")
        })
        
        let otherAction = DOAlertAction(title: otherButtonTitle, style: .default, handler:{
            
            action in
            
            let dicValue = [ "id" : self.privateIdValue , "video_type" : self.privateType , "feedback" : "1"]
          
            self.getPrivateWebData.getPrivateAcceptRejectWebService(urlString: self.getPrivateURL.privateAcceptRejectAudioVideo(), dicData: dicValue as NSDictionary, callback:{
                
                (dicc,err)  in
                
                
                if ((dicc["status"] as! String).isEqual("OK"))
                    
                {
                    
                    let dicData = [ "description" : "Accept","file_id" :self.privateIdValue ,"file_type" : self.privateType ,"user_email" :self.privatefromEmail ] as [String : Any]
                    
                    
                    
                    self.getPrivateWebData.getPrivateData(urlString: self.getPrivateURL.audioVideoReportAbuse(), dicData: dicData, callback: {
                        (dic, err) in
                        
                        print("check Private Data report Abuse",dic)
                       
                    })
                    
                    
                    //http://103.235.104.118:3000/commandService/audioVideoReportAbuse
                    /*
 "{ ""description"": ""ggahhajajajakakq"",
 ""file_id"": ""5923ec0cbf18f87f42727888"",
 ""file_type"": ""video/mp4"",
 ""user_email"": ""jnjaga24@gmail.com""}"
                     
                     
 */
                    
                    DispatchQueue.main.async {
                     
                         self.privateTableView.beginUpdates()
                        // Remove item from the array
                        self.recordPrivateData.remove(at: self.privateIndexPathLength)
                        
                        
                        // Delete the row from the table view
                      
                       
                        self.privateTableView.deleteSections([self.privateIndexPathLength], with: .automatic)
                        self.privateTableView.endUpdates()
                    }
                    
                }
                
                
            })

            
            
        })
        
        
        
        customAlertController.addAction(cancelAction)
        
        customAlertController.addAction(otherAction)
        
        
        self.present(customAlertController, animated: true, completion: nil)
        
    
        
    }
    
    
    func changecustomAlertController()
    {
    
    customAlertController.alertView.layer.cornerRadius = 6.0
    
    customAlertController.alertViewBgColor = UIColor(red:255-255, green:255-255, blue:255-255, alpha:0.7)
    
    customAlertController.titleFont = UIFont(name: "Mosk", size: 17.0)
        
    customAlertController.titleTextColor = UIColor.green
    
    customAlertController.messageFont = UIFont(name: "Mosk", size: 12.0)
    
    customAlertController.messageTextColor = UIColor.white
    
    customAlertController.buttonFont[.cancel] = UIFont(name: "Mosk", size: 15.0)
    
    customAlertController.buttonBgColor[.cancel] = UIColor.getLightBlueColor()
    
    customAlertController.buttonFont[.default] = UIFont(name: "Mosk", size: 15.0)
    
    customAlertController.buttonBgColor[.default] = UIColor.getOrangeColor()
        
     customAlertController.buttonBgColor[.destructive] = UIColor.red
    customAlertController.buttonFont[.destructive] = UIFont.xprezMediumFontOfsize(size: 15.0)
        
        //customAlertController.buttons
        
        

 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
