//
//  XPAudioViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/05/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPAudioViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    enum shareButtonTitle {
        case Private
        case Public
        case Both
    }
    @IBOutlet weak var shareTitleLabel: UILabel!

    @IBOutlet weak var shareButton: UIButton!
    
//    @IBOutlet weak var moodTitleTextField: UITextField!
//    @IBOutlet weak var expressTitleTextField: UITextField!
//    @IBOutlet weak var captionTitleTextField: UITextField!
    @IBOutlet weak var audioTableView: UITableView!
    @IBOutlet weak var audioPickerView: UIPickerView!
    @IBOutlet weak var audioBGImage = UIImageView()
    @IBOutlet weak var audioBGBorderImage = UIImageView()
    @IBOutlet weak var audioBGAnimationOne = UIImageView()
    @IBOutlet weak var audioBGAnimationTwo = UIImageView()
    
    var tap = UITapGestureRecognizer()
//    var cell = UITableViewCell()

    var shareTitle  = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Voice your Thoughts"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        shareTitle = ["Private","Public","Both"]
        audioPickerView.isHidden = true
        tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard(rec:)))
        view.addGestureRecognizer(tap)
        audioBGImage?.clipsToBounds = true
        audioBGImage?.layer.cornerRadius = (self.audioBGImage?.frame.size.width)!/2
        audioBGImage?.layer.masksToBounds = false
        audioBGBorderImage?.isHidden = true
        audioBGBorderImage?.clipsToBounds = true
        audioBGBorderImage?.layer.cornerRadius = (self.audioBGBorderImage?.frame.size.width)!/2
        audioBGBorderImage?.layer.masksToBounds = false
        audioBGAnimationOne?.clipsToBounds = true
        audioBGAnimationOne?.layer.cornerRadius = (self.audioBGAnimationOne?.frame.size.width)!/2
        audioBGAnimationOne?.layer.masksToBounds = false
        audioBGAnimationTwo?.clipsToBounds = true
        audioBGAnimationTwo?.layer.cornerRadius = (self.audioBGAnimationTwo?.frame.size.width)!/2
        audioBGAnimationTwo?.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func dismissKeyboard(rec: UIGestureRecognizer)
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        audioPickerView.isHidden = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (shareTitleLabel.text == "Both"){
           return 3
        }else {
            return 2
        }
        
        
    }
    
    // Tableview Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cellIdentifier = "XPAudioXpressTableViewCell"
        let  cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPAudioXpressTableViewCell)!
        if (shareTitleLabel.text == "Private") {
//            shareTitleLabel.text = "Private"
            if (indexPath.row == 0) {
                cell.addContactButon?.isHidden = false
                cell.labelCell?.text = "Express your feelings with"
                cell.expressTitleTextField?.text = "Email"
                return cell
                
//             let cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPAudioXpressTableViewCell)!
//                return cell
            } else if (indexPath.row == 1) {
                cell.addContactButon?.isHidden = true
                cell.labelCell?.text = "Caption your feeling"
                cell.expressTitleTextField?.text = "Feelings!"
                 cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                return cell
//                cellIdentifier = "XPAudioCaptionTableViewCell"
//             let   cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPAudioCaptionTableViewCell)!
//                return cell
            }
            
            
        } //else {
            if (shareTitleLabel.text == "Public") {
//                shareTitleLabel.text = "Public"
                if (indexPath.row == 0) {
                    cell.addContactButon?.isHidden = true
                    cell.labelCell?.text = "What's your mood?"
                    cell.expressTitleTextField?.text = "Enter Tags"
                    return cell
                    
//                    cellIdentifier = "XPAudioMoodTableViewCell"
//               let  cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPAudioMoodTableViewCell)!
//                    return cell
                } else if (indexPath.row == 1) {
                    cell.addContactButon?.isHidden = true
                    cell.labelCell?.text = "Caption your feeling"
                    cell.expressTitleTextField?.text = "Feelings!"
                     cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                    return cell
//                    cellIdentifier = "XPAudioCaptionTableViewCell"
//                 let   cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPAudioCaptionTableViewCell)!
//                    return cell
                }
                
            } //else {
        if ( shareTitleLabel.text == "Both") {
                if (indexPath.row == 0) {
                    cell.addContactButon?.isHidden = true
                    cell.labelCell?.text = "What's your mood?"
                    cell.expressTitleTextField?.text = "Enter Tags"
                    return cell
//                    cellIdentifier = "XPAudioMoodTableViewCell"
//                let  cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPAudioMoodTableViewCell)!
//                    return cell
                } else if (indexPath.row == 1) {
                    cell.addContactButon?.isHidden = false
                    cell.labelCell?.text = "Express your feelings with"
                    cell.expressTitleTextField?.text = "Email"
                    cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 254.0/255.0, green: 108.0/255.0, blue: 39.0/255.0, alpha: 1.0)
                    return cell
//                    cellIdentifier = "XPAudioXpressTableViewCell"
//                 let   cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPAudioXpressTableViewCell)!
//                    return cell
                } else if (indexPath.row == 2) {
                    cell.addContactButon?.isHidden = true
                    cell.labelCell?.text = "Caption your feeling"
                    cell.expressTitleTextField?.text = "Feelings!"
                    cell.expressTitleTextField?.textColor = UIColor.init(colorLiteralRed: 35.0/255.0, green: 255.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                    return cell
//                    cellIdentifier = "XPAudioCaptionTableViewCell"
//                 let   cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as? XPAudioCaptionTableViewCell)!
//                    return cell
                }
                
                
            }
       // }
    return cell
    }
    // Tableview Delegate
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.row == 0) {
//            audioPickerView.isHidden = false
//        } else {
//            audioPickerView.isHidden = true
//        }
//        
//        return
//    }
    
    // Pickerview DataSource
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
    
    // Pickerview Delegate
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
