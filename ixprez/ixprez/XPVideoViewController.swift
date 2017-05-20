//
//  XPVideoViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 19/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import ContactsUI

class XPVideoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,CNContactPickerDelegate,videoAddContactDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    

    
    let pulsrator = Pulsator ()
    @IBOutlet weak var  videoMailTableView : UITableView!
    @IBOutlet weak var shareTitleLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    var textField = XPVideoExpressTableViewCell()
    
    @IBOutlet weak var pulsatorAnimationView: UIView!
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var videoPickerView: UIPickerView!
    @IBOutlet weak var videoBGImage = UIImageView()
    
    var emailAddressLabel = UILabel ()
    var moodLabel = UILabel()
    var feelingsLabel = UILabel()
    var isAutoPoplatedContact : Bool = false
    var tap = UITapGestureRecognizer()
    var shareTitle  = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Xpress"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        videoMailTableView.isHidden  = true
        shareTitle = ["Private","Public","Both"]
        videoPickerView.isHidden = true
        tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard(rec:)))
        view.addGestureRecognizer(tap)
        videoBGImage?.clipsToBounds = true
        videoBGImage?.layer.cornerRadius = (self.videoBGImage?.frame.size.width)!/2
        videoBGImage?.layer.masksToBounds = false
        self.pulsatorAnimationView.layer.addSublayer(pulsrator)
    }
    
    
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        pulsrator.numPulse = 5
        pulsrator.radius = 120
        pulsrator.animationDuration = 5
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
        videoPickerView.isHidden = true
        
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
            if (indexPath.row == 0) {
                cell.addContactButon?.isHidden = false
                cell.labelCell?.text = "Express your feelings with"
                cell.expressTitleTextField?.text = "Email"
                cell.delegate = self
                return cell
                
            }
            else if (indexPath.row == 1) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "Caption your feeling"
                cell.expressTitleTextField?.text = "Feelings!"
                cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                return cell
                
            }
        }
        if (shareTitleLabel.text == "Public") {
            if (indexPath.row == 0) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "What's your mood?"
                cell.expressTitleTextField?.text = "Enter Tags"
                return cell
                
            }
            else if (indexPath.row == 1) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "Caption your feeling"
                cell.expressTitleTextField?.text = "Feelings!"
                cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                return cell
            }
            
        }
        if ( shareTitleLabel.text == "Both") {
            if (indexPath.row == 0) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "What's your mood?"
                cell.expressTitleTextField?.text = "Enter Tags"
                return cell
            }
            else if (indexPath.row == 1) {
                cell.addContactButon?.isHidden = false
                cell.labelCell?.text = "Express your feelings with"
                cell.expressTitleTextField?.text = "Email"
                cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 254.0/255.0, green: 108.0/255.0, blue: 39.0/255.0, alpha: 1.0)
                cell.delegate = self
                return cell
            }
            else if (indexPath.row == 2) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "Caption your feeling"
                cell.expressTitleTextField?.text = "Feelings!"
                cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
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
        videoPickerView.isHidden = false
        
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
    
    func addContactButtonTapped(cell: XPVideoExpressTableViewCell) {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self as CNContactPickerDelegate
        self.present(cnPicker, animated: true, completion: nil)
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
    
    @IBAction func NextViewScreenButtonAction (_ sender: Any) {
//        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
//            var imagePicker = UIImagePickerController ()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ? .front : .rear
//            self.present(imagePicker, animated: true, completion: { _ in
//            })
//            
//        } else {
//            print("Device don't have camera")
//        }
        
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPVideoRecordingPlayViewController") as! XPVideoRecordingPlayViewController
        
        self.navigationController?.pushViewController(storyBoard, animated: true)

        
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
