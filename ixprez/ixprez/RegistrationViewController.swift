//
//  RegistrationViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 27/04/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
   

    @IBOutlet weak var viewScrollView: UIView!
//    @IBOutlet weak var countryPickerView: UIPickerView!
//    @IBOutlet weak var languagePickerView: UIPickerView!
    @IBOutlet weak var nameTextField : UITextField?
    @IBOutlet weak var emailTextField : UITextField?
    @IBOutlet weak var mobileNumberTextField : UITextField?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var countryTextField : UITextField!
    @IBOutlet weak var languageTextField : UITextField!
    @IBOutlet weak var countryTableView : UITableView!
    @IBOutlet weak var languageTableView : UITableView!
    var autoCompleteCountryPossibilities : [String] = []
    var autoCompleteLanguagePossibilities : [String] = []
    var autoCountryComplete : [String] = []
    var autoLanguageComplete : [String] = []
    var isCountryTextField : Bool = false
    
    var defaults = UserDefaults.standard
    var countrySelectedValue = UILabel()
    var languageSelectedValue = UILabel()
    var countrySelectedPhoneCode = UILabel()
    var jsonArrayData = [String]()
    var  pickerData: [String] = [String]()
    var dictValue = NSDictionary()
    var countryArrayData = [String]()
    var languageArrayData = [String]()
    var countryPhoneCode = [String]()
    var listData = [String: AnyObject]()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    let getOTPClass = WebService()
       let getOTPUrl = URLDirectory.RegistrationData()
       let getCountryUrl = URLDirectory.Country()
        let getLanguageUrl = URLDirectory.Language()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let languages = NSLocale.preferredLanguages
        for lang in languages {
            let locale = NSLocale(localeIdentifier: lang)
            let translated = locale.displayName(forKey: NSLocale.Key.identifier, value: lang)!
            print("\(lang), \(translated)")
        }
        let countryLocale : NSLocale =  NSLocale.current as NSLocale
        let countryCode  = countryLocale.object(forKey: NSLocale.Key.countryCode)// as! String
        let country = countryLocale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode!)
        print("Country Locale:\(countryLocale)  Code:\(countryCode) Name:\(country)")
        countryTableView.layer.cornerRadius = 10
        languageTableView.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"bg_reg.png")!)
        self.viewScrollView.backgroundColor = UIColor(patternImage: UIImage(named:"bg_reg.png")!)
        getCountryDataFromTheWebService()
        getLanguageNameFromWebService()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard(rec:)))
            
        view.addGestureRecognizer(tap)
        nameTextField?.delegate = self
        saveButton.layer.cornerRadius = 20.0
        countryTextField.delegate = self
        languageTextField.delegate = self
        countryTableView.delegate = self
        languageTableView.delegate = self
        mobileNumberTextField?.delegate = self
        emailTextField?.delegate = self
//        self.countryPickerView.delegate = self
//        self.countryPickerView.dataSource = self
//        self.countryPickerView.reloadAllComponents()
//        countryTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countryTableView.isHidden = true
        languageTableView.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    if (textField.tag == 1){
            countryTableView.isHidden = false
        isCountryTextField = true
        } else if (textField.tag == 2){
            languageTableView.isHidden = false
        isCountryTextField = false
        }
        
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if (textField.tag == 1){
//            countryTableView.isHidden = true
//        } else {
//            languageTableView.isHidden = true
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var subString = String()
        if (textField.tag == 1) {
          subString   = (countryTextField.text! as NSString).replacingCharacters(in: range, with: string)
            searchAutocompleteCountryEntriesWithSubstring(substring: subString)
        } else if (textField.tag == 2){
           subString = (languageTextField.text! as NSString).replacingCharacters(in: range, with: string)
            searchAutocompleteLanguageEntriesWithSubstring(substring: subString)
        }
        
        return true
    }
    
    func searchAutocompleteCountryEntriesWithSubstring (substring : String) {
        autoCountryComplete.removeAll(keepingCapacity: false)
        
        for countryString in autoCompleteCountryPossibilities
        {
            var myString:NSString! = countryString as NSString
            
            let substringRange :NSRange! = myString.range(of: substring)
            
            if (substringRange.location  == 0)
            {
                autoCountryComplete.append(countryString)
            }
        }
        countryTableView.reloadData()
    }
    
    func searchAutocompleteLanguageEntriesWithSubstring(substring: String) {
        autoLanguageComplete.removeAll(keepingCapacity: false)
        
        for languageString in autoCompleteLanguagePossibilities {
            var myString:NSString! = languageString as NSString
            
            let substringRange :NSRange! = myString.range(of: substring)
            
            if (substringRange.location  == 0)
            {
                autoLanguageComplete.append(languageString)
            }
        }
        languageTableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        if (isCountryTextField == true) {
            countryTableView.isHidden = false
            let cellIdentifier = "XPCountryTableViewCell"
            
             cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? XPCountryTableViewCell)!
//            isCountryTextField = false
            let index = indexPath.row as Int
            cell.textLabel?.text = autoCountryComplete[index]
            return cell
            /*else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }*/
        } else {
            languageTableView.isHidden = false
            let cellIdentifier = "XPLanguageTableViewCell"
            
            cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? XPLanguageTableViewCell)!
            let index = indexPath.row as Int
            cell.textLabel?.text = autoLanguageComplete[index]
            return cell
            /* else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }*/
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isCountryTextField == true {
            return autoCountryComplete.count
        } else {
            return autoLanguageComplete.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isCountryTextField == true) {
                        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
            
                        countryTextField.text = selectedCell.textLabel!.text!
            
                    } else {
                        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
            
                        languageTextField.text = selectedCell.textLabel!.text!
                    }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if (isCountryTextField == true) {
//            let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
//            
//            countryTextField.text = selectedCell.textLabel!.text!
//            
//        } else {
//            let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
//            
//            languageTextField.text = selectedCell.textLabel!.text!
//        }
//        
//        
//        
//        
//    }
    
//    func addToArray(textField: UITextField) {
//        
//        if textField == textField {
//            let textToAdd = textField.text ?? ""
//            
//            autoCompletePossibilities.append(textToAdd)
//            print("it worked")
//        }
//        
//    }
//    
//    func clearTextFieldAfterAddingToArray() {
//        countryTextField.text = ""
//    }
    
    
    // This method will dismiss the keyboard
    func dismissKeyboard(rec: UIGestureRecognizer)
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // This method Will call the Web Service to get the country name and passing parameter
    func getCountryDataFromTheWebService()
    {
        
        let paramsCountry = ["list":"country"] as Dictionary<String, String>
        
      getOTPClass.getCountryDataWebService(urlString: getCountryUrl.url(), dicData: paramsCountry as NSDictionary, callback:
        { ( countryData , error ) in
            
        print("data")
        print(countryData)
        self.countryPhoneCode = (countryData.value(forKey: "ph_code") as! NSArray) as! [String]
        self.countryArrayData = (countryData.value(forKey: "country_name") as! NSArray) as! [String]
//            let delayInSeconds = 1.0
            self.autoCompleteCountryPossibilities = self.countryArrayData
            self.countryTableView.reloadData()
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds, execute: {
//                self.countryPickerView.reloadAllComponents()
//            })
            
        
      })
        
        
             
    }
   // This method Will call the Web Service to get the language and passing parameter
    func getLanguageNameFromWebService() -> Void
    {
    
        let paramsLanguage = ["list" : "language"] as Dictionary<String,String>
        
        getOTPClass.getLanguageDataWebService(urlString: getLanguageUrl.url(), dicData: paramsLanguage as NSDictionary, callBack:{(languageData , error) in
           self.languageArrayData = (languageData.value(forKey: "name") as! NSArray) as! [String]
            self.autoCompleteLanguagePossibilities = self.languageArrayData
            self.languageTableView.reloadData()
//            let delayInSeconds = 1.0
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds, execute: {
//                self.languagePickerView.reloadAllComponents()
//            })
            
        })
    }
    
    // This textfield method will hide the keyboard when click on done button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   /*
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == countryPickerView) {
            return self.countryArrayData.count
        }
        if (pickerView == languagePickerView) {
            return self.languageArrayData.count
        }
       return 0
    }
    
    // This method will display the data inside the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView == countryPickerView) {
            return self.countryArrayData[row]
        }
        if (pickerView == languagePickerView) {
            return self.languageArrayData[row]
        }
        
        return self.countryArrayData[row]
    }
    
    // This method will changed the Title text color of the picker view
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleData =  String()
        var titleColor = NSAttributedString()
        if (pickerView == countryPickerView) {
             titleData = self.countryArrayData[row]
             titleColor = NSAttributedString(string : titleData, attributes : [NSFontAttributeName: UIFont(name: "Georgia", size: 13.0)!, NSForegroundColorAttributeName: UIColor.white])
            return titleColor
        }
        if (pickerView == languagePickerView) {
            titleData = self.languageArrayData[row]
            titleColor = NSAttributedString(string : titleData, attributes : [NSFontAttributeName: UIFont(name: "Georgia", size: 13.0)!, NSForegroundColorAttributeName: UIColor.white])
            return titleColor
        }
        
        return titleColor

    }
    
   // This method will pass the picker view selected row data.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if (pickerView == countryPickerView) {
            countrySelectedValue.text = countryArrayData[row]
            countrySelectedPhoneCode.text = countryPhoneCode[row]
            mobileNumberTextField?.text = countrySelectedPhoneCode.text! + "-"
        }
        if (pickerView == languagePickerView) {
            
            languageSelectedValue.text = languageArrayData[row]
            
        }
        
    }
 */
    // This method will store the data into the NSUSerDefaults.
    @IBAction func saveButtonAction(_ sender: Any)
    {
        if ((nameTextField?.text == "") || (emailTextField?.text == "") || (mobileNumberTextField?.text == "")) {
            let alertController = UIAlertController(title: "Alert!", message: "Registration field will not be Blank: Please check your Name or Email or Mobile Text Field ", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
            
            
        } else {
            defaults.set(nameTextField?.text, forKey: "userName")
            defaults.set(emailTextField?.text, forKey: "emailAddress")
            defaults.set(countrySelectedValue.text, forKey: "countryName")
            defaults.set(languageSelectedValue.text, forKey: "languageName")
            defaults.set(mobileNumberTextField?.text, forKey: "mobileNumber")
            
            
            
            let parameter = ["user_name":defaults.string(forKey: "userName"),"email_id": defaults.string(forKey: "emailAddress"),"phone_number":defaults.string(forKey: "mobileNumber"),"country":defaults.string(forKey: "countryName"),"language": defaults.string(forKey: "languageName"),"device_id":appdelegate.deviceUDID,"notification": "1","reminder":"1","mobile_os":appdelegate.deviceOS,"mobile_version":appdelegate.deviceName,"mobile_modelname": appdelegate.deviceModel,"gcm_id":"DDD454564"]
            
            getOTPClass.getaddDeviceWebService(urlString: getOTPUrl.url(), dicData: parameter as NSDictionary)
            
            let otpValidation = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationViewController") as! OTPVerificationViewController
            otpValidation.userName = defaults.string(forKey: "userName")!
            otpValidation.emailId = defaults.string(forKey: "emailAddress")!
            otpValidation.country = defaults.string(forKey: "countryName")!
            otpValidation.language = defaults.string(forKey: "languageName")!
            otpValidation.mobileNumber = defaults.string(forKey: "mobileNumber")!
            self.present(otpValidation, animated: true, completion: nil)
        }
        
        
        
        
        
}
}


