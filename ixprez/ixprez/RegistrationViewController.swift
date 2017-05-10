//
//  RegistrationViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 27/04/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import CoreTelephony

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
    var someDict:[String :String] = ["BD": "880" ,"BE": "32", "BF": "226", "BG": "359", "BA": "387", "BB": "+1-246", "WF": "681", "BL": "590", "BM": "+1-441", "BN": "673", "BO": "591", "BH": "973", "BI": "257", "BJ": "229", "BT": "975", "JM": "+1-876", "BV": "", "BW": "267", "WS": "685", "BQ": "599", "BR": "55", "BS": "+1-242", "JE": "+44-1534", "BY": "375", "BZ": "501", "RU": "7", "RW": "250", "RS": "381", "TL": "670", "RE": "262", "TM": "993", "TJ": "992", "RO": "40", "TK": "690", "GW": "245", "GU": "+1-671", "GT": "502", "GS": "", "GR": "30", "GQ": "240", "GP": "590", "JP": "81", "GY": "592", "GG": "+44-1481", "GF": "594", "GE": "995", "GD": "+1-473", "GB": "44", "GA": "241", "SV": "503", "GN": "224", "GM": "220", "GL": "299", "GI": "350", "GH": "233", "OM": "968", "TN": "216", "JO": "962", "HR": "385", "HT": "509", "HU": "36", "HK": "852", "HN": "504", "HM": " ", "VE": "58", "PR": "+1-787 and 1-939", "PS": "970", "PW": "680", "PT": "351", "SJ": "47", "PY": "595", "IQ": "964", "PA": "507", "PF": "689", "PG": "675", "PE": "51", "PK": "92", "PH": "63", "PN": "870", "PL": "48", "PM": "508", "ZM": "260", "EH": "212", "EE": "372", "EG": "20", "ZA": "27", "EC": "593", "IT": "39", "VN": "84", "SB": "677", "ET": "251", "SO": "252", "ZW": "263", "SA": "966", "ES": "34", "ER": "291", "ME": "382", "MD": "373", "MG": "261", "MF": "590", "MA": "212", "MC": "377", "UZ": "998", "MM": "95", "ML": "223", "MO": "853", "MN": "976", "MH": "692", "MK": "389", "MU": "230", "MT": "356", "MW": "265", "MV": "960", "MQ": "596", "MP": "+1-670", "MS": "+1-664", "MR": "222", "IM": "+44-1624", "UG": "256", "TZ": "255", "MY": "60", "MX": "52", "IL": "972", "FR": "33", "IO": "246", "SH": "290", "FI": "358", "FJ": "679", "FK": "500", "FM": "691", "FO": "298", "NI": "505", "NL": "31", "NO": "47", "NA": "264", "VU": "678", "NC": "687", "NE": "227", "NF": "672", "NG": "234", "NZ": "64", "NP": "977", "NR": "674", "NU": "683", "CK": "682", "XK": "", "CI": "225", "CH": "41", "CO": "57", "CN": "86", "CM": "237", "CL": "56", "CC": "61", "CA": "1", "CG": "242", "CF": "236", "CD": "243", "CZ": "420", "CY": "357", "CX": "61", "CR": "506", "CW": "599", "CV": "238", "CU": "53", "SZ": "268", "SY": "963", "SX": "599", "KG": "996", "KE": "254", "SS": "211", "SR": "597", "KI": "686", "KH": "855", "KN": "+1-869", "KM": "269", "ST": "239", "SK": "421", "KR": "82", "SI": "386", "KP": "850", "KW": "965", "SN": "221", "SM": "378", "SL": "232", "SC": "248", "KZ": "7", "KY": "+1-345", "SG": "65", "SE": "46", "SD": "249", "DO": "+1-809 and 1-829", "DM": "+1-767", "DJ": "253", "DK": "45", "VG": "+1-284", "DE": "49", "YE": "967", "DZ": "213", "US": "1", "UY": "598", "YT": "262", "UM": "1", "LB": "961", "LC": "+1-758", "LA": "856", "TV": "688", "TW": "886", "TT": "+1-868", "TR": "90", "LK": "94", "LI": "423", "LV": "371", "TO": "676", "LT": "370", "LU": "352", "LR": "231", "LS": "266", "TH": "66", "TF": "", "TG": "228", "TD": "235", "TC": "+1-649", "LY": "218", "VA": "379", "VC": "+1-784", "AE": "971", "AD": "376", "AG": "+1-268", "AF": "93", "AI": "+1-264", "VI": "+1-340", "IS": "354", "IR": "98", "AM": "374", "AL": "355", "AO": "244", "AQ": "", "AS": "+1-684", "AR": "54", "AU": "61", "AT": "43", "AW": "297", "IN": "91", "AX": "+358-18", "AZ": "994", "IE": "353", "ID": "62", "UA": "380", "QA": "974", "MZ": "258"]
    var autoCompleteCountryPossibilities : [String] = []
    var autoCompleteLanguagePossibilities : [String] = []
    var autoCountryComplete : [String] = []
    var autoLanguageComplete : [String] = []
    var isCountryTextField : Bool = false
    var tap = UITapGestureRecognizer()
    
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
    
    let getOTPClass = XPWebService()
       let getOTPUrl = URLDirectory.RegistrationData()
       let getCountryUrl = URLDirectory.Country()
        let getLanguageUrl = URLDirectory.Language()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This will set the device language
        
        let languages = NSLocale.preferredLanguages
        var translated = String()
        for lang in languages {
            let locale = NSLocale(localeIdentifier: lang)
            translated = locale.displayName(forKey: NSLocale.Key.identifier, value: lang)!
            print("\(lang), \(translated)")
        }
        languageTextField.text = translated
        
        // This will set the device country code
        let countryLocale : NSLocale =  NSLocale.current as NSLocale
        let countryCode  = countryLocale.object(forKey: NSLocale.Key.countryCode)// as! String
        let country = countryLocale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode!)
        print("Country Locale:\(countryLocale)  Code:\(String(describing: countryCode)) Name:\(String(describing: country))")
        countryTextField.text = country
        
        // This will set the country Mobile prefix code
        for (key, value) in someDict {
            if (countryLocale.countryCode == (key)) {
                mobileNumberTextField?.text = (value) + " -"
            }
            print("Dictionary key \(key) -  Dictionary value \(value)")
        }
        countryTableView.layer.cornerRadius = 10
        languageTableView.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"bg_reg.png")!)
        self.viewScrollView.backgroundColor = UIColor(patternImage: UIImage(named:"bg_reg.png")!)
        getCountryDataFromTheWebService()
        getLanguageNameFromWebService()
        
        // This gesture will use to hide the keyboard (tap anywhere inside the screen)
         tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard(rec:)))
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
    
    // TextField Delegate
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//    tap.cancelsTouchesInView = false
//    if (textField.tag == 1){
//        countryTableView.isHidden = false
//        languageTableView.isHidden = true
//        isCountryTextField = true
//        } else if (textField.tag == 2){
//            languageTableView.isHidden = false
//        countryTableView.isHidden = true
//        isCountryTextField = false
//        }
//        
//    }
    
     // TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        tap.cancelsTouchesInView = false
        var subString = String()
        if (textField.tag == 1) {
          subString   = (countryTextField.text! as NSString).replacingCharacters(in: range, with: string)
            searchAutocompleteCountryEntriesWithSubstring(substring: subString)
            if (subString.isEmpty) {
                countryTableView.isHidden = true
            }else {
                countryTableView.isHidden = false
                languageTableView.isHidden = true
                isCountryTextField = true
            }
            
        } else if (textField.tag == 2){
           subString = (languageTextField.text! as NSString).replacingCharacters(in: range, with: string)
            searchAutocompleteLanguageEntriesWithSubstring(substring: subString)
            if (subString.isEmpty) {
                languageTableView.isHidden = true
            }else {
                languageTableView.isHidden = false
                countryTableView.isHidden = true
                isCountryTextField = false
            }
        }
        
        return true
    }
    
    // This method will serach the autocompleted country name
    func searchAutocompleteCountryEntriesWithSubstring (substring : String) {
        autoCountryComplete.removeAll(keepingCapacity: false)
        
        for countryString in autoCompleteCountryPossibilities
        {
            var myString:NSString! = countryString as NSString
            let newString: NSString! =  myString.lowercased as NSString
            let newSubString : NSString = substring.lowercased() as NSString
            let substringRange :NSRange! = newString.range(of: newSubString as String)
            
            if (substringRange.location  == 0)
            {
                autoCountryComplete.append(countryString)
            }
        }
        countryTableView.reloadData()
    }
    
    // This method will serach the autocompleted language name
    func searchAutocompleteLanguageEntriesWithSubstring(substring: String) {
        autoLanguageComplete.removeAll(keepingCapacity: false)
        
        for languageString in autoCompleteLanguagePossibilities {
            var myString:NSString! = languageString as NSString
            let newString: NSString! =  myString.lowercased as NSString
            let newSubString : NSString = substring.lowercased() as NSString
            let substringRange :NSRange! = newString.range(of: newSubString as String)
            
            if (substringRange.location  == 0)
            {
                autoLanguageComplete.append(languageString)
            }
        }
        languageTableView.reloadData()
        
    }
    
    // tableview Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        if (isCountryTextField == true) {
            countryTableView.isHidden = false
            let cellIdentifier = "XPCountryTableViewCell"
            
             cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? XPCountryTableViewCell)!
//            isCountryTextField = false
            let index = indexPath.row as Int
            cell.textLabel?.font = UIFont(name: "Mosk", size: 20)
            cell.textLabel?.text = autoCountryComplete[index]
            
        } else {
            languageTableView.isHidden = false
            let cellIdentifier = "XPLanguageTableViewCell"
            
            cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? XPLanguageTableViewCell)!
            let index = indexPath.row as Int
            cell.textLabel?.font = UIFont(name: "Mosk", size: 20)
            cell.textLabel?.text = autoLanguageComplete[index]
//            return cell
        }
        
        return cell
    }
    
    // tableview Delegate
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
        countryTableView.isHidden = true
        languageTableView.isHidden = true
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
        if ((nameTextField?.text == "") || (emailTextField?.text == "") || (mobileNumberTextField?.text == "") || (countryTextField.text == "") || (languageTextField.text == "")) {
            let alertController = UIAlertController(title: "Alert!", message: "Registration field will not be Blank: Please check your Name or Email or Mobile Text Field ", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
            
            
        } else {
            defaults.set(nameTextField?.text, forKey: "userName")
            defaults.set(emailTextField?.text, forKey: "emailAddress")
            defaults.set(countryTextField.text, forKey: "countryName")
            defaults.set(languageTextField.text, forKey: "languageName")
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


