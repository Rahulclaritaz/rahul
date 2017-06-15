//
//  XPAudioViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import ContactsUI

//protocol cellTextValidateDelegate {
//    func cellTextData (vc : XPAudioViewController)
//}

class XPAudioViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,CNContactPickerDelegate, UIPopoverPresentationControllerDelegate {
    
    enum shareButtonTitle {
        case Private
        case Public
        case Both
    }
    
    let pulsrator = Pulsator ()
  
    @IBOutlet weak var  audioMailTableView : UITableView!
    @IBOutlet weak var shareTitleLabel: UILabel!

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var audioPickerBar : UINavigationBar!
    
//    var textField = XPAudioXpressTableViewCell()
    
//    @IBOutlet weak var moodTitleTextField: UITextField!
//    @IBOutlet weak var expressTitleTextField: UITextField!
//    @IBOutlet weak var captionTitleTextField: UITextField!
    @IBOutlet weak var pulsatorAnimationView: UIView!
    @IBOutlet weak var audioTableView: UITableView!
    @IBOutlet weak var audioPickerView: UIPickerView!
    @IBOutlet weak var audioBGImage = UIImageView()
    @IBOutlet weak var audioBGBorderImage = UIImageView()
    @IBOutlet weak var audioBGAnimationOne = UIImageView()
    @IBOutlet weak var audioBGAnimationTwo = UIImageView()
    var emailAddressLabel = UILabel ()
    var moodLabel = UILabel()
    var feelingsLabel = UILabel()
    var isAutoPoplatedContact : Bool = false
    var rowInCell = Int ()
//    var cellIndexPath = XPAudioXpressTableViewCell()
//    var delegateCell : cellTextValidateDelegate?
    
    
    var tap = UITapGestureRecognizer()
    var cell = XPAudioXpressTableViewCell()
    var defaultValue = UserDefaults.standard

    var shareTitle  = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.delegateCell = self as? cellTextValidateDelegate
        self.navigationItem.title = "Voice your thoughts"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        audioMailTableView.isHidden  = true
        shareTitle = ["Private","Public","Both"]
        audioPickerBar.isHidden = true
        audioPickerView.isHidden = true
        tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard(rec:)))
        view.addGestureRecognizer(tap)
        audioBGImage?.clipsToBounds = true
        audioBGImage?.layer.cornerRadius = (self.audioBGImage?.frame.size.width)!/2
        audioBGImage?.layer.masksToBounds = false
        audioBGBorderImage?.isHidden = true
        audioBGAnimationOne?.isHidden = true
        audioBGAnimationTwo?.isHidden = true
//        audioBGBorderImage?.clipsToBounds = true
//        audioBGBorderImage?.layer.cornerRadius = (self.audioBGBorderImage?.frame.size.width)!/2
//        audioBGBorderImage?.layer.masksToBounds = false
//        audioBGAnimationOne?.clipsToBounds = true
//        audioBGAnimationOne?.layer.cornerRadius = (self.audioBGAnimationOne?.frame.size.width)!/2
//        audioBGAnimationOne?.layer.masksToBounds = false
//        audioBGAnimationTwo?.clipsToBounds = true
//        audioBGAnimationTwo?.layer.cornerRadius = (self.audioBGAnimationTwo?.frame.size.width)!/2
//        audioBGAnimationTwo?.clipsToBounds = true
        self.pulsatorAnimationView.layer.addSublayer(pulsrator)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func donePickerAction (_sender : Any) {
        audioPickerView.isHidden = true
        audioPickerBar.isHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        pulsrator.numPulse = 5
        pulsrator.radius = 150
        pulsrator.animationDuration = 6
        pulsrator.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6).cgColor
        pulsrator.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pulsrator.stop()
    }
    
    func dismissKeyboard(rec: UIGestureRecognizer)
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        audioPickerView.isHidden = true
        audioPickerBar.isHidden = true
    
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
        
         let cellIdentifier = "XPAudioXpressTableViewCell"
        let  cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPAudioXpressTableViewCell)!

        if (shareTitleLabel.text == "Private") {
            cell.pickerStatusType.text = shareTitleLabel.text
            if (indexPath.row == 0) {
                cell.addContactButon?.isHidden = false
                cell.labelCell?.text = "Express your feelings with"
                cell.expressTitleTextField?.text = "Email"
                cell.indexPathRow = indexPath.row
                cell.delegate = self
                return cell
                
             }
            else if (indexPath.row == 1) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "Caption Your Feeling"
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
                    cell.expressTitleTextField?.text = "Email"
                    cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 254.0/255.0, green: 108.0/255.0, blue: 39.0/255.0, alpha: 1.0)
                    cell.indexPathRow = indexPath.row
                    cell.delegate = self
                    return cell
                }
                else if (indexPath.row == 2) {
                    cell.addContactButon?.isHidden = true
                    cell.labelCell?.text = "Caption your feeling"
                    cell.expressTitleTextField?.text = "Feelings!"
                    cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                    cell.indexPathRow = indexPath.row
                    cell.delegate = self
                    return cell
                }
            }
          return cell
       }
    // MARK: Tableview Delegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        if (indexPath.row == 0) {
////          self.emailAddressLabel.text = cell.expressTitleTextField?.text
////        } else if () {
////            se
////        }
//        
//        return
//    }
    
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var selecteCellIndexPath = tableView.indexPathForSelectedRow
//        print(selecteCellIndexPath)
//        
//        print("You select the : \(indexPath.row)")
//    }
    
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
    
    // This method will changed the Title text color of the picker view
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        var titleData =  String()
//        var titleColor = NSAttributedString()
//            titleData = self.shareTitle[row]
//            shareTitleLabel.text = titleData
//            titleColor = NSAttributedString(string : titleData, attributes : [NSFontAttributeName: UIFont(name: "Mosk", size: 20.0)!, NSForegroundColorAttributeName: UIColor.black])
//            return titleColor
//        
//    }
    
    //MARK: Pickerview Delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shareTitleLabel.text = shareTitle[row]
        audioTableView.reloadData()
        
        
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if (textField.tag == 1) {
//            moodTitleTextField .text = ""
//        } else if (textField.tag == 2) {
//            expressTitleTextField.text = ""
//        } else if (textField.tag == 3) {
//            captionTitleTextField.text = ""
//        }
//        
//       
//        return true
//    }
    
    
    @IBAction func shareButtonAction(_ sender: Any) {
        audioPickerView.isHidden = false
        audioPickerBar.isHidden = false
        
    }
    
    // This method will open the contact page
//    @IBAction func addContactButtonAction(_ sender: Any) {
//       let cnPicker = CNContactPickerViewController()
//        cnPicker.delegate = self as? CNContactPickerDelegate
//        self.present(cnPicker, animated: true, completion: nil)
//    }
    
    private var selectedItems = [String]()
    func addContact (cell: XPAudioXpressTableViewCell) {
    /*    let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self as CNContactPickerDelegate
        self.present(cnPicker, animated: true, completion: nil) */
        
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPContactViewController") as! XPContactViewController
        self.navigationController?.pushViewController(storyboard, animated: true)
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
    
    // This method will display the descrition of type in audio
    @IBAction func showModal(_ sender : UIButton) {
    // get a reference to the view controller for the popover
    let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPPopOverViewController") as! XPPopOverViewController
        
        self.addChildViewController(popController)
        popController.view.frame = self.view.frame
        self.view.addSubview(popController.view)
        popController.didMove(toParentViewController: self)

    }
    
    // This method will check the textfield validation and move to next Controller. 
    @IBAction func NextViewScreenButtonAvtion (sender: Any) {
        defaultValue.set(shareTitleLabel.text, forKey: "pickerStatus")
        defaultValue.set(emailAddressLabel.text, forKey: "toEmailAddress")
        defaultValue.set(moodLabel.text , forKey: "moodLabelValue")
        defaultValue.set(feelingsLabel.text, forKey: "feelingsLabelValue")
        let alert = UIAlertController(title: "Alert", message: "Email and feeling can not Empty", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPAudioRecordingViewController") as! XPAudioRecordingViewController
        if (shareTitleLabel.text == "Private") {
            if ((emailAddressLabel.text == nil) || (emailAddressLabel.text?.isValidEmail() != true) || (feelingsLabel.text == nil) || (feelingsLabel.text == "Feelings")) {
                self.present(alert, animated: true, completion: nil)
            } else {
                if (feelingsLabel.text == nil) {
                  feelingsLabel.text! = "Awesome"
                    storyBoard.titleString = feelingsLabel.text!
                }else {
                    storyBoard.titleString = feelingsLabel.text!
                }
                
                self.navigationController?.pushViewController(storyBoard, animated: true)
            }
            
        } else if (shareTitleLabel.text == "Public") {
            if ((moodLabel.text == nil) || (moodLabel.text == "Enter Tags") || (feelingsLabel.text == nil) || (feelingsLabel.text == "Feelings")) {
                self.present(alert, animated: true, completion: nil)
            } else {
                if (feelingsLabel.text == nil) {
                    feelingsLabel.text! = "Awesome"
                    storyBoard.titleString = feelingsLabel.text!
                }else {
                    storyBoard.titleString = feelingsLabel.text!
                }
                self.navigationController?.pushViewController(storyBoard, animated: true)
            }
            
            
        } else if (shareTitleLabel.text == "Both") {
            if ((moodLabel.text == nil) || (moodLabel.text == "Enter Tags") || (feelingsLabel.text == nil) || (feelingsLabel.text == "Feelings") || (emailAddressLabel.text == nil) || (emailAddressLabel.text?.isValidEmail() != true)) {
                self.present(alert, animated: true, completion: nil)
            } else {
                if (feelingsLabel.text == nil) {
                    feelingsLabel.text! = "Awesome"
                    storyBoard.titleString = feelingsLabel.text!
                }else {
                    storyBoard.titleString = feelingsLabel.text!
                }
                self.navigationController?.pushViewController(storyBoard, animated: true)
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

extension XPAudioViewController : AudioTextFieldDelegate {
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




