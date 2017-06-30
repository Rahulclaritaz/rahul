//
//  XPSettingsViewController.swift
//  ixprez
//
//  Created by Quad on 5/16/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPSettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, passData,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var isFromMenu = Bool()
    var arrayName = [String]()
    var userName    = String()
    var phoneNumber = String()
    var emailID     = String()
    var notify = String()
    var remain = String()
    var language = String()
    var country = String()
    
    
    
    var saveEmail = String()
    
    var previousCountData : Int!
    
    var userFollowersData : Int!
    
    var recordProfileData = [String:Any]()
    
    var getSettingWebService = PrivateWebService()
    
    var getSettingUrl = URLDirectory.Setting()
    
    var orginalUrl = String()
    
    var customAlertController : DOAlertController!
    
    let imagePickerController = UIImagePickerController()

    var isTuch : Bool!
    
    @IBOutlet weak var settingTableView: UITableView!
    
    @IBOutlet weak var roundprofilePhoto: UIImageView!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var lblfollowers: UILabel!
    
    @IBOutlet weak var lblFollowing: UILabel!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    let getOTPClass = XPWebService()
    
    let getOTPUrl = URLDirectory.RegistrationData()
    
    var tapGesture = UITapGestureRecognizer()
    
    var getData = UserDefaults.standard
    
    
    
    @IBAction func settingBackButton(_ sender: Any)
    {
        
        guard (isFromMenu) else
        {
            self.navigationController?.popViewController(animated: true)
            
            return
            
            
          }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    override func awakeFromNib()
    {
 
 
 
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        print("hai da mathan",isFromMenu)
        
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

        
        emailID =  getData.string(forKey: "emailAddress")!
        userName = getData.string(forKey: "userName")!
        phoneNumber = getData.string(forKey: "mobileNumber")!
        language = getData.string(forKey: "languageName")!
        country = getData.string(forKey: "countryName")!
        
        
    
        isTuch = true
 
        navigationItem.backBarButtonItem =  UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        roundprofilePhoto.layer.cornerRadius = roundprofilePhoto.frame.size.width/2
    
        roundprofilePhoto.clipsToBounds = true
        
    
    arrayName = ["User Name","Mobile Number","Email","Reminders","Notification","Language","Country","","Support","Help" ,"About"]
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewPhoto(sender:)))

        roundprofilePhoto.isUserInteractionEnabled = true
        
        roundprofilePhoto.addGestureRecognizer(tapGesture)
            
        
         imagePickerController.delegate = self
        
        
      
        getPrivateData()

        
    }
    
    func viewPhoto(sender : UIGestureRecognizer)
    {
        
         let myView = self.storyboard?.instantiateViewController(withIdentifier: "XPSettingPhotoViewController") as! XPSettingPhotoViewController
        
               myView.setImage = roundprofilePhoto.image!
        
        
         self.navigationController?.pushViewController(myView, animated: true)
        
      
    }
    
    @IBAction func  backButtonAction( _sender : Any) {
        
        guard (isFromMenu) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getPrivateData()
    {
        let dicData = ["PreviousCount":0 ,"user_email": emailID] as [String : Any]
        
        getSettingWebService.getPrivateData(urlString: getSettingUrl.getPrivateData(), dicData: dicData as [String:Any], callback: {
            (dicc,error) in
            
            
            self.recordProfileData = dicc["data"] as! [String:Any]
            
            print("data data",self.recordProfileData)
            
        
            self.previousCountData =  self.recordProfileData["FollowingCount"]! as! Int
            
            self.userFollowersData =  self.recordProfileData["PrivateCount"]! as! Int
            
            self.orginalUrl = self.recordProfileData["ProfileImage"] as! String
            
            
            
            self.orginalUrl.replace("/root/cpanel3-skel/public_html/Xpress/",with: "http://103.235.104.118:3000/")
        
            
        
            
            DispatchQueue.main.async(execute: {
                
                self.lblfollowers.text = String(format: "%d Followers", self.previousCountData)
                self.lblFollowing.text = String(format: "%d Following .", self.userFollowersData)
                
                self.profilePhoto.getImageFromUrl(self.orginalUrl)
                
                self.roundprofilePhoto.getImageFromUrl(self.orginalUrl)
                
                
            })
            
         
            
            
        })
  

    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    return arrayName.count
    
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         // print(self.recordProfileData)
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingcell", for: indexPath) as! XPSettingTableViewCell
   
        settingTableView.rowHeight = 44
      
        cell.isUserInteractionEnabled = true
     
        cell.imgRightArrow.isHidden = true
        
        cell.btnSettingSave.isHidden = true
        
        cell.switchNotify.isHidden = true
        
        cell.txtEnterSettings.isHidden = true
        
        cell.lblSettingName.isHidden = true
        
        cell.downArrow.isHidden = true
        
        
        switch indexPath.row
        {
            
        case 0:
            
          
            cell.txtEnterSettings.isHidden = false
            cell.lblSettingName.isHidden = false
            cell.lblSettingName.text = arrayName[0]
            cell.txtEnterSettings.text = userName
            cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
           
            
        case 1:
            
     
            cell.txtEnterSettings.isHidden = false
            cell.lblSettingName.isHidden = false
            cell.lblSettingName.text = arrayName[1]
            cell.txtEnterSettings.text = phoneNumber
            cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
           
            
        case 2:
          
            
            cell.lblSettingName.isHidden = false
            cell.lblSettingName.text = arrayName[2]
            cell.txtEnterSettings.isHidden = false
            cell.txtEnterSettings.text = emailID
            cell.txtEnterSettings.isUserInteractionEnabled = false
            cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
          
        case 3:
            
            cell.switchNotify.isHidden = false
            cell.lblSettingName.isHidden = false
            cell.lblSettingName.text = arrayName[3]
            cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
          
            
        case 4:
          
            cell.switchNotify.isHidden = false
            cell.lblSettingName.isHidden = false
            cell.lblSettingName.text = arrayName[4]
            cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
            
            
            
        case 5:
            
            cell.lblSettingName.isHidden = false
            cell.txtEnterSettings.isHidden = false
            cell.lblSettingName.text = arrayName[5]
            cell.txtEnterSettings.text = language
            cell.txtEnterSettings.isHidden = false
            cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
            cell.txtEnterSettings.addTarget(self, action: #selector(languageData(sender:)), for: .editingDidBegin)
           
            
        case 6:
            
             cell.lblSettingName.isHidden = false
            cell.txtEnterSettings.isHidden = false
            cell.lblSettingName.text = arrayName[6]
            cell.txtEnterSettings.text = country
             cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
            cell.txtEnterSettings.addTarget(self, action: #selector(countryData(sender:)), for: .editingDidBegin)
           
            
            
            
            
        case 7:
            
            
          
            cell.btnSettingSave.isHidden = false
     
            cell.btnSettingSave.tag = indexPath.row
           // cell.btnSettingSave.layer.cornerRadius = 12.0
            cell.btnSettingSave.setTitleColor(UIColor.white, for: .normal)
            cell.btnSettingSave.backgroundColor = UIColor.getOrangeColor()
            
            
            cell.downArrow.isHidden = false
            
            cell.btnSettingSave.addTarget(self, action: #selector(saveSetting(sender:)), for: .touchUpInside)
            
            cell.downArrow.addTarget(self, action: #selector(scrollToLastRow), for: .touchUpInside)
            
            
            settingTableView.rowHeight = CGFloat(cell.lblWidthSize.constant + 50)
            
     
        case 8:
            cell.imgRightArrow.isHidden = false
            cell.lblSettingName.isHidden = false
            cell.lblSettingName.text = arrayName[8]
            cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
            
            
        case 9:
            cell.imgRightArrow.isHidden = false
          
            cell.lblSettingName.isHidden = false
            
            cell.lblSettingName.text = arrayName[9]
            
            cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
         
        case 10:
            
            cell.imgRightArrow.isHidden = false
          
            cell.lblSettingName.isHidden = false
            cell.lblSettingName.text = arrayName[10]
            cell.lblWidthSize.constant = CGFloat((cell.lblSettingName.text?.lengthOfBytes(using: .utf32))!*2)
            
            
        default:
            print("No Data")
        }
        
  
        return cell
   
    }
    
    func scrollToLastRow()
    {
     
        
        if (isTuch == true)
        {
        
        let arrData : Int = arrayName.count - 1
        
        let indexPath = IndexPath(row: arrData, section: 0)
        
        
        settingTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        isTuch = false
        }
        else
        {
 
            let indexPath = IndexPath(row: 0, section: 0)
            
            
            settingTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            isTuch = true
        }
    }
    
    
    func languageData(sender:UITextField)
    {
        
        let getCountryFromView = self.storyboard?.instantiateViewController(withIdentifier: "XPSettingLanguageCountryViewController") as! XPSettingLanguageCountryViewController
        
        getCountryFromView.flag = false
        
        getCountryFromView.delegate = self
        
        
        self.present(getCountryFromView, animated: false, completion: nil)
        
    }
    func countryData(sender : UITextField)
    {
      
        
        let getCountryFromView = self.storyboard?.instantiateViewController(withIdentifier: "XPSettingLanguageCountryViewController") as! XPSettingLanguageCountryViewController
        
         getCountryFromView.flag = true
         getCountryFromView.delegate = self
        
        
        self.present(getCountryFromView, animated: false, completion: nil)
        
    
    }
    func passingCounData(name : String)
    {
        let indexCountry = IndexPath(row: 6, section: 0)
        
        let conCell = settingTableView.cellForRow(at: indexCountry) as! XPSettingTableViewCell
        
        if ( name.isEmpty)
        {
      
            //self.dismiss(animated: false, completion: nil)
            
            conCell.txtEnterSettings.text! = country
        
        }
        else
        
        {
           // self.dismiss(animated: false, completion: nil)
         
            conCell.txtEnterSettings.text! = name
          
        }
        
    }
    func passingLanData(name : String)
    {
        
        let indexLanguage = IndexPath(row: 5, section: 0)
        
        let langCell = settingTableView.cellForRow(at: indexLanguage) as! XPSettingTableViewCell
        
       
        
        if ( name.isEmpty)
        {
            
            langCell.txtEnterSettings.text = language
            
          //self.dismiss(animated: false, completion: nil)
    
        }
        
        else
        {
          //  self.dismiss(animated: false, completion: nil)
            
            langCell.txtEnterSettings.text! = name
        }
 
        
        
    }

    
    func saveSetting(sender : UIButton)
    {
    
       let  IndexPathUser = IndexPath(row: 0, section: 0)
        
       let userCell  = settingTableView.cellForRow(at: IndexPathUser) as! XPSettingTableViewCell
        
       userName = userCell.txtEnterSettings.text!
    
       let  IndexPathPhone = IndexPath(row: 1, section: 0)
    
       let phoneCell = settingTableView.cellForRow(at: IndexPathPhone) as! XPSettingTableViewCell
            
        phoneNumber    = phoneCell.txtEnterSettings.text!
        
       let  IndexPathEmail = IndexPath(row: 2, section: 0)
        
       let emailCell = settingTableView.cellForRow(at: IndexPathEmail) as! XPSettingTableViewCell
        
       emailID = emailCell.txtEnterSettings.text!
    
        let IndexPathNotify = IndexPath(row: 3, section: 0)
        
        let notifyCell = settingTableView.cellForRow(at: IndexPathNotify) as! XPSettingTableViewCell
        
        
        if ( notifyCell.switchNotify.isOn == true)
        {
            notify = "1"
        }
        else
        {
            notify = "0"
        }
        
        
        let IndexPathRemin = IndexPath(row: 4, section: 0)
        
        let reminCell = settingTableView.cellForRow(at: IndexPathRemin) as! XPSettingTableViewCell
        
        
        if ( reminCell.switchNotify.isOn == true)
        {
            remain = "1"
        }
        else
        {
            remain = "0"
        }
        
        
        
        let indexLanguage = IndexPath(row: 5, section: 0)
        
        let langCell = settingTableView.cellForRow(at: indexLanguage) as! XPSettingTableViewCell
        
        language = langCell.txtEnterSettings.text!
        
        
        
        let indexCountry = IndexPath(row: 6, section: 0)
        
        let conCell = settingTableView.cellForRow(at: indexCountry) as! XPSettingTableViewCell
        
        country = conCell.txtEnterSettings.text!
        
        
       print(userName,"+",phoneNumber,"+",emailID,"+",notify,"+",remain,"+",country,"+", language)
        
        if (userCell.txtEnterSettings.text == "" || phoneCell.txtEnterSettings.text == "" || emailCell.txtEnterSettings.text?.isValidEmail() == false || conCell.txtEnterSettings.text == "" || langCell.txtEnterSettings.text == "")
        {
            if userCell.txtEnterSettings.text == ""
            {
            
                
                userCell.txtEnterSettings.textFieldBoarder(txtColor: UIColor.red, txtWidth: 3)
                
                
            }
            if phoneCell.txtEnterSettings.text == ""
            {
                
                phoneCell.txtEnterSettings.textFieldBoarder(txtColor: UIColor.red , txtWidth: 3)
                
            }
            if (emailCell.txtEnterSettings.text?.isValidEmail())! == false
            {
                emailCell.txtEnterSettings.textFieldBoarder(txtColor: UIColor.getLightBlueColor(), txtWidth: 1)
                
            }
            if (langCell.txtEnterSettings.text == "")
            {
                langCell.txtEnterSettings.textFieldBoarder(txtColor: UIColor.getLightBlueColor(), txtWidth: 1)
            }
            
            if (conCell.txtEnterSettings.text == "" )
            {
                conCell.txtEnterSettings.textFieldBoarder(txtColor: UIColor.getLightBlueColor(), txtWidth: 1)
            }
            else
            {
                print("OK")
            }
            
            
        }
        
     else
        {
        let parameter = ["user_name":userName,"email_id":emailID,"phone_number":phoneNumber,"country":country,"language": language,"device_id":appdelegate.deviceUDID,"notification": notify ,"remainder": remain,"mobile_os":appdelegate.deviceOS,"mobile_version":appdelegate.deviceName,"mobile_modelname": appdelegate.deviceModel,"gcm_id":"DDD454564"]
        
        getOTPClass.getaddDeviceWebService(urlString: getOTPUrl.url(), dicData: parameter as NSDictionary, callBack: {
            (dicc, err) in
            
            print(dicc)
            
        })
        

        }
        
        
  
    }

    
/*    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 170.0
        
    }
    
    func   tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
     //  print(self.recordProfileData)
        
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell") as! XPSettingHeaderTableViewCell
        
        
       headerView.lblFollowers.text = String(format: "%d", self.previousCountData)
        
        
        
      
      // self.previousCountData
        
        
      /*
         
        headerView.lblFollowers.text = String(format: "%d", recordProfileData["PrivateFollowCount"] as! Int)
        
        
        
         headerView.lblFollowing.text = String(format: "%d", recordProfileData["FollowingCount"] as! Int)
 
        
        
         var orginalimage = recordProfileData["ProfileImage"] as! String
        
        
        orginalimage.replace("/root/cpanel3-skel/public_html/Xpress/",with: "http://103.235.104.118:3000/")
        
        
        headerView.imgProfilePhoto.getImageFromUrl(orginalimage)
    
    
        */
        
        
        
        return headerView.contentView
        
        
        
    }
   */
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool
     {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
      
        
        switch indexPath.row {
        
        
        case 8:
            
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "XPSupportViewController") as! XPSupportViewController
            
            self.navigationController?.pushViewController(nextView, animated: true)
            
        
        case 9:
            
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "XPHelpViewController") as! XPHelpViewController
            
            self.navigationController?.pushViewController(nextView, animated: true)
            
        
        case 10:
            
            let nextView = self.storyboard?.instantiateViewController(withIdentifier: "XPAboutViewController") as! XPAboutViewController
            
            self.navigationController?.pushViewController(nextView, animated: true)
            
            
        default:
            print("Not Inddex")
        }
        
    }
 
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
     
        switch indexPath.row {
         
            
        case 0:
            
            
            cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, cell.bounds.size.width)
            
        case 1:
            
            cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, cell.bounds.size.width)
            
        case 2:
            
            
            cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, cell.bounds.size.width)
        case 3:
            
            
            cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, cell.bounds.size.width)
            
        case 4:
            
            
            cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, cell.bounds.size.width)
            
        case 5:
            
            cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, cell.bounds.size.width)
            
        case 6:
            
            
            cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, cell.bounds.size.width)
  
        case 7:
            
           
     cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, -cell.bounds.size.width)
            
        case 8:
            
     cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, -cell.bounds.size.width)
       
        case 9:
            
            
    cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, -cell.bounds.size.width)
        case 10:
            
            
     cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, -cell.bounds.size.width)
            
            
        default:
            print("Not Inddex")
        }
   
 
    }
    @IBAction func selectSouceImage(_ sender: Any)
    {
        
        let title = "Select Source"
        let action1 = "Camera"
        let action2 = "Gallery"
        let action3 = "Photos"
     
         customAlertController =  DOAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        changecustomAlertController(alphaValue: 0.0)
        
        //create action 
        
        let myAction1 = DOAlertAction(title: action1, style: .default, handler: {
            action in
            
            self.openCamera()
            
            
        })
        
        
        let myAction2 = DOAlertAction(title: action2, style: .default, handler: {
            action in
            
              self.openGallery()
            
        })
        
        let myAction3 = DOAlertAction(title: action3, style: .default, handler: {
            action in
            
            
            self.openPhoto()
            
        })
        
        let myAction4 = DOAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
       
        
        customAlertController.addAction(myAction1)
        customAlertController.addAction(myAction2)
        customAlertController.addAction(myAction3)
        customAlertController.addAction(myAction4)
   
        
        
        self.present(customAlertController, animated: true, completion: nil)
        
    
        
    }
    
    func openCamera()
    {
           print("open camera")
        
          self.dismiss(animated: true, completion: nil)
    
 
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
         {
            imagePickerController.allowsEditing = true
            
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            
            self.present(imagePickerController, animated: true, completion: nil)
            
        
        }
        else
        {
    
        self.alerViewSource()
            
            
        }
        
        
    }
    
    func openGallery()
    {
        
        print("open camera")
        
        self.dismiss(animated: true, completion: nil)
        
        if ( UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
        
        {
           
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
            
            
        }
        else
        {
             self.alerViewSource()
        }
        
    }
    
    func openPhoto()
    {
        print( "open photo")
        
        self.dismiss(animated: true, completion: nil)
        
        if ( UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum))
        {
        
            imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
            
        }
        else
        {
            self.alerViewSource()
            
        }
    }
    func alerViewSource()
    {
        customAlertController = DOAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
        
        changecustomAlertController(alphaValue: 0.5)
        let myAction1 = DOAlertAction(title: "OK", style: .default, handler: nil)
        
        let myAction2 = DOAlertAction(title: "Cancel", style: .default, handler: nil)
        
        
        customAlertController.addAction(myAction1)
        
        customAlertController.addAction(myAction2)
        
        
        self.present(customAlertController, animated: true, completion: nil)
        
    }
 
      
/*
 
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            profilePhoto.contentMode = .scaleAspectFill
            profilePhoto.image = pickedImage
            roundprofilePhoto.image = pickedImage
            getuploadProfileImage()
        }
        
        self.dismiss(animated: true, completion: nil)
         
     
 
    }*/
    
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {

        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            
            profilePhoto.contentMode = .scaleAspectFill
            profilePhoto.image = chosenImage
            roundprofilePhoto.image = chosenImage
            getuploadProfileImage()
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
 
 
    func getuploadProfileImage()
    {
 
        //NSData *imageData = UIImageJPEGRepresentation(_image1, 0.9);
        
        
       let imageData : Data = (profilePhoto.image?.lowestQualityJPEGNSData)!
 
 
        
        let url = URL(string: getSettingUrl.uploadProfileImage())
        
        var request = URLRequest(url: url!)
        
        let boundary = generateBoundaryString1()
        
        
        let body = NSMutableData()
      
 
 
        request.setValue("multipart/form-data; boundary =\("---------------------------14737809831466499882746641449")", forHTTPHeaderField: "Content-Type")
 
 
        body.appendString("--\("---------------------------14737809831466499882746641449")\r\n")
        body.appendString("Content-Disposition: form-data; name=\"user_email\"\r\n\r\n")
        body.appendString(emailID)
        body.appendString("\r\n")
     
      
        
         body.appendString("--\("---------------------------14737809831466499882746641449")\r\n")
         body.appendString("Content-Disposition: form-data; name=\"profileImage\"; filename=\"sample.jpg\"\r\n")
         body.appendString("Content-Type: image/jpg\r\n\r\n")
         body.append(imageData)
         body.appendString("\r\n")
        
        
         body.appendString("--\("---------------------------14737809831466499882746641449")--\r\n")
     
        request.httpBody = body as Data
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.httpShouldHandleCookies = false
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request, completionHandler: {
         
            (data,response,error) -> Void in
            
            do
            {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
            print(jsonData)
            }
            
            catch
            {
                
            }
            
        })
        
        dataTask.resume()
        
        
    }
    func generateBoundaryString1() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
 
    func changecustomAlertController(alphaValue : Float)
    {
        
        customAlertController.alertView.layer.cornerRadius = 6.0
        
    //customAlertController.alertViewBgColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: CGFloat(alphaValue))
        
        customAlertController.alertViewBgColor = UIColor.white
        
        customAlertController.titleFont = UIFont(name: "Mosk", size: 20.0)
        customAlertController.titleTextColor = UIColor.blue
        
        customAlertController.messageFont = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.messageTextColor = UIColor.white
        
        customAlertController.buttonFont[.cancel] = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.buttonBgColor[.cancel] = UIColor.getOrangeColor()
        
        customAlertController.buttonFont[.default] = UIFont(name: "Mosk", size: 15.0)
        
        customAlertController.buttonBgColor[.default] = UIColor.lightGray
        
    }
    
  

}
