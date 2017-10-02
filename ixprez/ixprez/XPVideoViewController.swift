//
//  XPVideoViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 19/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import ContactsUI
import AVFoundation

//protocol videoViewEmailDelegate {
//   func passVideoEmail(email : String)
//}

class XPVideoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,CNContactPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate {
    

    
    let pulsrator = Pulsator ()
    @IBOutlet weak var  videoMailTableView : UITableView!
    @IBOutlet weak var shareTitleLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var textField = XPVideoExpressTableViewCell()
    
    @IBOutlet weak var pulsatorAnimationView: UIView!
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var videoPickerView: UIPickerView?
    @IBOutlet weak var videoBGImage = UIImageView()
    @IBOutlet weak var pickerNavBar = UINavigationBar ()
    
    var emailAddressLabel = UILabel ()
    var nameAndNumber = String ()
    var phoneNumberValidate = String ()
    var moodLabel = UILabel()
    var feelingsLabel = UILabel()
    var isAutoPoplatedContact : Bool = false
    var tap = UITapGestureRecognizer()
    var shareTitle  = [String]()
    var defaultValue = UserDefaults.standard
    var rowInCell = Int ()
    let cameraSession = AVCaptureSession()
    var imagePicker = UIImagePickerController ()
    var contactUserEmail : Bool = false
    var selectContactVideo = Bool ()
    var webReference = PrivateWebService()
    var urlReference = URLDirectory.contactData()
    var filteredString = String ()
    var customAlertController = DOAlertController ()
//    var videoEmailDelegate : videoViewEmailDelegate?
    
    var picker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Xpress"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        videoMailTableView.isHidden  = true
        shareTitle = ["Private","Public","Both"]
        videoPickerView?.isHidden = true
        pickerNavBar?.isHidden = true
        tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard(rec:)))
        view.addGestureRecognizer(tap)
        videoBGImage?.clipsToBounds = true
        videoBGImage?.layer.cornerRadius = (self.videoBGImage?.frame.size.width)!/2
        videoBGImage?.layer.masksToBounds = false
        self.pulsatorAnimationView.layer.addSublayer(pulsrator)
//        setupCameraSession()
//        cameraSession.startRunning()
        

    }
    
    @IBAction func donePicker (_ sender: Any) {
      videoPickerView?.isHidden = true
      pickerNavBar?.isHidden = true
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func upArrowPickerButtonAction (_sender : Any) {
        print("you select the up arrow button")
        var upArrow : Int =  self.videoPickerView!.selectedRow(inComponent: 0)
        print(upArrow)
        if (videoPickerView?.selectedRow(inComponent: 0) == 2) {
            videoPickerView?.selectRow(1, inComponent: 0, animated: true)
            shareTitleLabel.text = shareTitle[upArrow - 1]
            videoTableView.reloadData()
        } else if (videoPickerView?.selectedRow(inComponent: 0) == 1) {
            videoPickerView?.selectRow(0, inComponent: 0, animated: true)
            shareTitleLabel.text = shareTitle[upArrow - 1]
            videoTableView.reloadData()
        }
    }
    @IBAction func downArrowPickerButtonAction (_sender : Any) {
        print("you select the down arrow button")
        var downArrow : Int =  self.videoPickerView!.selectedRow(inComponent: 0)
        print(downArrow)
        if (videoPickerView?.selectedRow(inComponent: 0) == 0) {
            videoPickerView?.selectRow(1, inComponent: 0, animated: true)
            shareTitleLabel.text = shareTitle[downArrow + 1]
            videoTableView.reloadData()
        } else if (videoPickerView?.selectedRow(inComponent: 0) == 1) {
            videoPickerView?.selectRow(2, inComponent: 0, animated: true)
            shareTitleLabel.text = shareTitle[downArrow + 1]
            videoTableView.reloadData()
        }
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
//        self.view.layer.addSublayer(previewLayer)
        pulsrator.numPulse = 5
        pulsrator.radius = 150
        pulsrator.animationDuration = 6
        pulsrator.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6).cgColor
        self.videoTableView.reloadData()
        pulsrator.start()
        
    
    }
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
        preview?.bounds = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height)
        preview?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        preview?.videoGravity = AVLayerVideoGravityResize
        return preview!
    }()
    
    func setupCameraSession() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            cameraSession.beginConfiguration()
            
            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
            }
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
            dataOutput.alwaysDiscardsLateVideoFrames = true
            
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
            }
            
            cameraSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "ixprez")
            dataOutput.setSampleBufferDelegate(self, queue: queue)
            
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pulsrator.stop()
        cameraSession.stopRunning()
    }
    
    func dismissKeyboard(rec: UIGestureRecognizer)
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        videoPickerView?.isHidden = true
        pickerNavBar?.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        guard isAutoPoplatedContact else {
        if (shareTitleLabel.text == "Both"){
            return 3
        }else {
            return 2
        }
        //        }
        
        
        
    }
    
    // MARK: Tableview Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "XPVideoExpressTableViewCell"
        let  cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPVideoExpressTableViewCell)!
        
        if (shareTitleLabel.text == "Private") {
            cell.pickerStatusType.text = shareTitleLabel.text
            if (indexPath.row == 0) {
                cell.addContactButon?.isHidden = false
                cell.labelCell?.text = "Express your feelings with"
                if (contactUserEmail == true  || selectContactVideo == true) {
                    cell.expressTitleTextField?.text = emailAddressLabel.text
                } else {
                    cell.expressTitleTextField?.text = "Phone Number"
                }
                
                cell.indexPathRow = indexPath.row
                cell.delegate = self
                return cell
                
            }
            else if (indexPath.row == 1) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "Caption your feeling"
                cell.expressTitleTextField?.text = "Feelings!"
                cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                cell.indexPathRow = indexPath.row
                cell.delegate = self
                return cell
                
            }
        }
        if (shareTitleLabel.text == "Public") {
            cell.pickerStatusType.text = shareTitleLabel.text
            if (indexPath.row == 0) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "What's your mood?"
                cell.expressTitleTextField?.text = "Enter Tags"
                cell.indexPathRow = indexPath.row
                cell.delegate = self
                return cell
                
            }
            else if (indexPath.row == 1) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "Caption your feeling"
                cell.expressTitleTextField?.text = "Feelings!"
                cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                cell.indexPathRow = indexPath.row
                cell.delegate = self
                return cell
            }
            
        }
        if ( shareTitleLabel.text == "Both") {
            cell.pickerStatusType.text = shareTitleLabel.text
            if (indexPath.row == 0) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "What's your mood?"
                cell.expressTitleTextField?.text = "Enter Tags"
                cell.indexPathRow = indexPath.row
                cell.delegate = self
                return cell
            }
            else if (indexPath.row == 1) {
                cell.addContactButon?.isHidden = false
                cell.labelCell?.text = "Express your feelings with"
                if (contactUserEmail == true) {
                    cell.expressTitleTextField?.text = emailAddressLabel.text
                } else {
                    cell.expressTitleTextField?.text = "Phone Number"
                }
                cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 254.0/255.0, green: 108.0/255.0, blue: 39.0/255.0, alpha: 1.0)
                cell.indexPathRow = indexPath.row
                cell.delegate = self
                return cell
            }
            else if (indexPath.row == 2) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "Caption Your Feeling"
                cell.expressTitleTextField?.text = "Feelings!"
                cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                cell.indexPathRow = indexPath.row
                cell.delegate = self
                return cell
            }
        }
        return cell
    }
    
    
    //MARK: Pickerview DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Pickerview DataSource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shareTitle.count
    }
    
    // Pickerview DataSource
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return shareTitle[row]
    }
    
    //MARK: Pickerview Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shareTitleLabel.text = shareTitle[row]
        videoTableView.reloadData()
        
        
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        videoPickerView?.isHidden = false
        pickerNavBar?.isHidden = false
        
    }
    
    
    // MARK: CNContactPicker delegate Method
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        for emailAddress in contact.emailAddresses {
            let selectedContactEmail  = emailAddress.value
            if  (selectedContactEmail == nil) {
                print("Contact Don't have mail id")
            } else {
                print("selecte mail is : \(selectedContactEmail)")
            }
            
        }
    }
    
    
    func addContact(cell: XPVideoExpressTableViewCell) {
//        let cnPicker = CNContactPickerViewController()
//        cnPicker.delegate = self as CNContactPickerDelegate
//        self.present(cnPicker, animated: true, completion: nil)
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPContactViewController") as! XPContactViewController
//        videoEmailDelegate?.passVideoEmail(email: "rahul@claritaz.com")
        storyboard.emailDelegate = self
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
//    func addContactButtonTapped(cell: XPVideoExpressTableViewCell) {
//        let cnPicker = CNContactPickerViewController()
//        cnPicker.delegate = self as CNContactPickerDelegate
//        self.present(cnPicker, animated: true, completion: nil)
//    }
    
    
    // This method will display the descrition of type in audio
    @IBAction func showModal(_ sender : UIButton) {
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPPopOverViewController") as! XPPopOverViewController
        
        self.addChildViewController(popController)
        popController.view.frame = self.view.frame
        self.view.addSubview(popController.view)
        popController.didMove(toParentViewController: self)
        
    }
    
    // This method will pass the unregistered ixprez user mailid [as parameter] from pop up to uploadaudio web API.
    func unregisterdXprezAudioUser (){
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "CameraDemoViewController") as! CameraDemoViewController
        self.navigationController?.pushViewController(storyBoard, animated: true)
    }
    
    // This method will create the custom pop up.
    func displayPopUpController () {
        let title = "Oops! Look like \(self.filteredString) hasn't signed up for iXprez yet! Use his email ID to Xpress to him."
        //let message = "A message should be a short, complete sentence."
        let cancelButtonTitle = "Cancel"
        let otherButtonTitle = "Invite and xpress"
        
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
            
            if (textFields != nil) {
                for textField: UITextField in textFields! {
                    print("mathan Check",textField.text!)
                    UserDefaults.standard.set(true, forKey: "isUnregisterXprezUser")
                    // This will store the pop up email TextField value
                    UserDefaults.standard.set(textField.text!, forKey: "inviteXprezUser")
                    self.unregisterdXprezAudioUser()
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: "Email- Id can not be blank.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        // Add the actions.
        customAlertController.addAction(cancelAction)
        customAlertController.addAction(otherAction)
        
        present(customAlertController, animated: true, completion: nil)
    }
    
    
    
    func xpressUserValidate(sender: UIButton)
        
    {
        phoneNumberValidate = self.emailAddressLabel.text!
        let numericSet : [Character] = ["+","0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let filteredCharacters = phoneNumberValidate.characters.filter {
            return numericSet.contains($0)
        }
        filteredString = String(filteredCharacters)
        var phoneNumber = [String]()
        phoneNumber = [filteredString]
        let para = { ["contactList" :  phoneNumber ] }
        
        
        // This API will return the ixprez user list.
        webReference.getiXprezUserValidateWebService(urlString: urlReference.getXpressContact(), dicData: para() , callback: { (myData ,error) in
            print(myData)
            
            print("\(myData)")
            let userPhoneNumber : NSArray = myData.value(forKey: "data") as! NSArray
            print(userPhoneNumber)
            
            DispatchQueue.main.async {
                if (userPhoneNumber.count > 0) {
                    print("This number is a iXprez verified Number")
                    UserDefaults.standard.set(false, forKey: "isUnregisterXprezUser")
                    self.unregisterdXprezAudioUser()
                    
                } else {
                    print("This number is not a iXprez verified Number")
                    self.displayPopUpController()
                }
            }
        })
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
    
    @IBAction func NextViewScreenButtonAction (_ sender: Any) {
        defaultValue.set(shareTitleLabel.text, forKey: "pickerStatus")
        defaultValue.set(emailAddressLabel.text, forKey: "toEmailAddress")
        defaultValue.set(moodLabel.text , forKey: "moodLabelValue")
        defaultValue.set(feelingsLabel.text, forKey: "feelingsLabelValue")
        
        let alert = UIAlertController(title: "Alert", message: "Phone Number and feeling can not Empty", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        if (shareTitleLabel.text == "Private") {
            if ((emailAddressLabel.text == nil) || (feelingsLabel.text == nil) || (feelingsLabel.text == "Feelings!")) {
                self.present(alert, animated: true, completion: nil)
            } else {
                if (feelingsLabel.text == nil) {
                    feelingsLabel.text! = "Awesome"
//                    storyBoard.titleString = feelingsLabel.text!
                }else {
//                    storyBoard.titleString = feelingsLabel.text!
                }
                self.nextButton.addTarget(self, action: #selector(xpressUserValidate(sender:)), for: .touchUpInside)
            }
            
        } else if (shareTitleLabel.text == "Public") {
            if ((moodLabel.text == nil) || (moodLabel.text == "Enter Tags") || (feelingsLabel.text == nil) || (feelingsLabel.text == "Feelings")) {
                self.present(alert, animated: true, completion: nil)
            } else {
                if (feelingsLabel.text == nil) {
                    feelingsLabel.text! = "Awesome"
//                    storyBoard.titleString = feelingsLabel.text!
                }else {
//                    storyBoard.titleString = feelingsLabel.text!
                }
            }
            self.unregisterdXprezAudioUser()
            
        } else if (shareTitleLabel.text == "Both") {
            if ((moodLabel.text == nil) || (moodLabel.text == "Enter Tags") || (feelingsLabel.text == nil) || (feelingsLabel.text == "Feelings") || (emailAddressLabel.text == nil)) {
                self.present(alert, animated: true, completion: nil)
            } else {
                if (feelingsLabel.text == nil) {
                    feelingsLabel.text! = "Awesome"
//                    storyBoard.titleString = feelingsLabel.text!
                }else {
//                    storyBoard.titleString = feelingsLabel.text!
                }
                self.nextButton.addTarget(self, action: #selector(xpressUserValidate(sender:)), for: .touchUpInside)
            }
            
        }
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension XPVideoViewController : VideoTextFieldDelegate {
    func textFieldValidate(textFieldName: String, row: Int) {
        
        rowInCell = row
        if (shareTitleLabel.text == "Private") {
            guard (rowInCell == 0) else {
                feelingsLabel.text = textFieldName
                return
            }
            emailAddressLabel.text = textFieldName
            
        } else if (shareTitleLabel.text == "Public") {
            
            guard (rowInCell == 0) else {
                feelingsLabel.text = textFieldName
                return
            }
            moodLabel.text = textFieldName
            return
            
        } else if (shareTitleLabel.text == "Both") {
            
            if (rowInCell == 0) {
                moodLabel.text = textFieldName
                return
            } else if  (rowInCell == 1) {
                emailAddressLabel.text = textFieldName
                return
            } else if (rowInCell == 2){
                feelingsLabel.text = textFieldName
                return
            }
            
        }
    }
    
}

extension XPVideoViewController : contactEmailDelegate {
    func passEmailToAudioAndVideo(email: String, name: String) {
        self.contactUserEmail = true
        self.nameAndNumber = name+" - "+email
        self.emailAddressLabel.text = self.nameAndNumber
    }
}

