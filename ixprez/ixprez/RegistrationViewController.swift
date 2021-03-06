//
//  RegistrationViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 27/04/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import CoreTelephony
import FirebaseAuth
import UserNotifications
import CloudKit

class RegistrationViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
   
    @IBOutlet weak var btnTerm: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
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
    var  countryData = [[String : Any]]()
    var languageData = [[String : Any]]()
    var filterCountryData = [[String : Any]]()
    var filterLanguageData = [[String:Any]]()
    
    
    var autoCompleteCountryPossibilities : [NSArray] = []
    var autoCompleteLanguagePossibilities : [NSArray] = []
    var autoCountryComplete : [NSArray] = []
    var autoLanguageComplete : [NSArray] = []
    var isCountryTextField : Bool = false
    var tap = UITapGestureRecognizer()
    
    var defaults = UserDefaults.standard
    var countrySelectedValue = UILabel()
    var languageSelectedValue = UILabel()
    var countrySelectedPhoneCode = UILabel()
    var jsonArrayData = [String]()
    var  pickerData: [String] = [String]()
    var dictValue = NSDictionary()
    var countryArrayData = [NSArray]()
    var languageArrayData = [NSArray]()
    var countryPhoneCode = [NSArray]()
    var listData = [String: AnyObject]()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    let getOTPClass     = XPWebService()
    let getOTPUrl       = URLDirectory.RegistrationData()
    let getCountryUrl   = URLDirectory.Country()
    let getLanguageUrl  = URLDirectory.Language()
    
    var myCountry : String!
    var translated = String()
    var country : String!
    var countryCode : String!
    
    override func awakeFromNib()
    {
        
        let languages = NSLocale.preferredLanguages
        
        for lang in languages
        {
            let locale = NSLocale(localeIdentifier: lang)
            translated = locale.displayName(forKey: NSLocale.Key.identifier, value: lang)!
            print("\(lang), \(translated)")
        }
       
        // This will set the device country code
        let countryLocale : NSLocale =  NSLocale.current as NSLocale
        let countryCode  = countryLocale.object(forKey: NSLocale.Key.countryCode)// as! String
         country = countryLocale.displayName(forKey: NSLocale.Key.countryCode, value: countryCode!)
        
        myCountry = String(describing: country!)
        
        
        print("myCountry", myCountry)
        
        
        print("Country Locale:\(countryLocale)  Code:\(String(describing: countryCode)) Name:\(String(describing: country))")
        
        
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // This will set the device language
        
        languageTextField.text = translated
        
        // This will set the country Mobile prefix code
        countryTextField.text = country!
        
        countryTableView.layer.cornerRadius = 10
        languageTableView.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"bg_reg.png")!)
        self.viewScrollView.backgroundColor = UIColor(patternImage: UIImage(named:"bg_reg.png")!)
        getCountryDataFromTheWebService()
        getLanguageNameFromWebService()
        UserDefaults.standard.set(true, forKey: "isAppFirstTime")
        
        // This gesture will use to hide the keyboard (tap anywhere inside the screen)
        // tap = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard(rec:)))
        //view.addGestureRecognizer(tap)
        nameTextField?.delegate = self
        saveButton.layer.cornerRadius = 20.0
        countryTextField.delegate = self
        languageTextField.delegate = self
     
        mobileNumberTextField?.delegate = self
        emailTextField?.delegate = self
        self.btnTerm.addTarget(self, action: #selector(termsAndCondition(sender:)), for: .touchUpInside)
        self.btnPrivacy.addTarget(self, action: #selector(privacyPolicy(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countryTableView.isHidden = true
        languageTableView.isHidden = true
    }
    
    // This will open the browser for term and Conditions.
   @IBAction func termsAndCondition (sender : UIButton) {
    UIApplication.shared.openURL(NSURL(string: "http://www.quadrupleindia.com/ixprez/page/terms_conditions.html")! as URL)
    }
    // This will open the browser for Privacy.
   @IBAction func privacyPolicy (sender : UIButton) {
    UIApplication.shared.openURL(NSURL(string: "http://www.quadrupleindia.com/ixprez/page/privacy_policy.html")! as URL)
    }
    
    
   
     
    // TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       // tap.cancelsTouchesInView = false
        
        
        var subString = String()
        
        if (textField.tag == 1)
        {
          subString   = (countryTextField.text! as NSString).replacingCharacters(in: range, with: string)
           searchAutocompleteCountryEntriesWithSubstring(substring: subString)
            if (subString.isEmpty)
            {
                countryTableView.isHidden = true
            }else {
                countryTableView.isHidden = false
                languageTableView.isHidden = true
                isCountryTextField = true
            }
            
        } else if (textField.tag == 2)
        {
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
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        countryTableView.isHidden = true
        languageTableView.isHidden = true
    }
    
   
    
    

    // This method will serach the autocompleted country name
    
    func searchAutocompleteCountryEntriesWithSubstring (substring : String)
    {
       
      filterCountryData.removeAll()
        
        
        filterCountryData = countryData.filter({
            
            
             let string = $0["country_name"] as! String
            
           
            return string.lowercased().range(of : substring.lowercased()) != nil
            
        })
        
        
                 DispatchQueue.main.async
            {
            
            self.countryTableView.reloadData()
  
             }
        
        
       }
    
    
    // This method will serach the autocompleted language name
    
    func searchAutocompleteLanguageEntriesWithSubstring(substring: String)
    {
       // autoLanguageComplete.removeAll(keepingCapacity: false)
        filterLanguageData.removeAll()
        
         filterLanguageData = languageData.filter({
            
            let string = $0["name"] as! String
            
            return string.lowercased().range(of: substring.lowercased()) != nil
            
            
        })
 
        
        DispatchQueue.main.async
            {
            self.languageTableView.reloadData()
  
            
        }
        
        
    }

    
    
    // tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       if tableView == countryTableView
       {
            return filterCountryData.count
        
        }
        else
        {
            return filterLanguageData.count
        }
     
    
    }

    
    
    // tableview Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        
        if (tableView == countryTableView)
        
        {
           // countryTableView.isHidden = false
            
            let cellIdentifier = "XPCountryTableViewCell"
            
           let countDic = self.filterCountryData[indexPath.row]
            
             cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? XPCountryTableViewCell)!
            
            
            cell.textLabel?.font = UIFont(name: "Mosk", size: 20)
            
            
            cell.textLabel?.text = countDic["country_name"] as? String
            
        }
            
            
            
      else
        {
            //languageTableView.isHidden = false
            
            let cellIdentifier = "XPLanguageTableViewCell"
            
            cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? XPLanguageTableViewCell)!
            let lanDic = self.filterLanguageData[indexPath.row]
            
            
            cell.textLabel?.font = UIFont(name: "Mosk", size: 20)
            
            
            cell.textLabel?.text = lanDic["name"] as? String
 
            
        }
            
        
        
        return cell
    }
    
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    {
       
        if (tableView == countryTableView)
        
        {
        
            let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
            
            
            countryTextField.text = selectedCell.textLabel!.text!
        
    
           let autoCountryCompleteDic = filterCountryData[indexPath.row]
            
            
            print("mathan check data",autoCountryCompleteDic)
           
            
            
           for i in 0...filterCountryData.count
            {
             
                if indexPath.row == i
                {
                    
                print( autoCountryCompleteDic["ph_code"] as! String)
                    
              self.mobileNumberTextField?.text = String(format: "+%@", (autoCountryCompleteDic["ph_code"] as? String)!)
                    
                 
                
                }
            }
            
            countryTableView.isHidden = true
            
        }
        
         if tableView == languageTableView
       
                   {
                        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
            
                        languageTextField.text = selectedCell.textLabel!.text!
                    }
    
                
        languageTableView.isHidden = true
        
    }
    

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
        
        /*
 self.countryPhoneCode = (countryData.value(forKey: "ph_code") as! NSArray) as! [String]
 self.countryArrayData = (countryData.value(forKey: "country_name") as! NSArray) as! [String]
 //            let delayInSeconds = 1.0
 self.autoCompleteCountryPossibilities = self.countryArrayData
 */
        
        
      let paramsCountry = ["list":"country"] as Dictionary<String, String>
        
      getOTPClass.getCountryDataWebService(urlString: getCountryUrl.url(), dicData: paramsCountry as NSDictionary, callback:
        { ( countryData,needData, error ) in
            
        print("data")
        print(countryData)
      //  self.countryPhoneCode = (countryData.value(forKey: "ph_code") as! NSArray) as! [String]
    
            
            self.countryArrayData = (needData.value(forKey: "country_name") as! NSArray) as! [NSArray]
            
            self.autoCompleteCountryPossibilities = self.countryArrayData
            
            
            self.countryData = countryData
            
            
            DispatchQueue.global(qos: .background).async {
                
            
            let myData :[[String:Any]] = self.countryData.filter({
                
                
                
                let string = $0["country_name"] as? String
                
                let subString =  self.myCountry!
                
                
                
                print ( "my data",string!)
                
                
              
                return string?.lowercased().range(of: subString.lowercased()) != nil
                
         
            })
            
            
       
                
                
            for arrData in myData
            {
                
                self.mobileNumberTextField?.text = String(format: "+%@", arrData["ph_code"] as! String)
                self.countryCode = "+" + (arrData["ph_code"] as! String)
                print("The country code for this country is \(self.countryCode)")
                self.defaults.set(self.countryCode, forKey: "countryCode")
            }
            
            
            
            DispatchQueue.main.async
                {
                
                self.countryTableView.reloadData()
   
            }
            }
            
      })
            
    }
   // This method Will call the Web Service to get the language and passing parameter
    func getLanguageNameFromWebService() -> Void
    {
    
        let paramsLanguage = ["list" : "language"] as Dictionary<String,String>
        
        getOTPClass.getLanguageDataWebService(urlString: getLanguageUrl.url(), dicData: paramsLanguage as NSDictionary, callBack:{(languageData ,needData, error) in
          
            
            self.languageArrayData = (needData.value(forKey: "name") as! NSArray) as! [NSArray]
            
            self.autoCompleteLanguagePossibilities = self.languageArrayData
            
            
            self.languageData = languageData

            
            DispatchQueue.main.async
            {
          self.languageTableView.reloadData()
   
            }
         
            
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
      // This method will store the data into the NSUSerDefaults.
    @IBAction func saveButtonAction(_ sender: Any)
    {
        
        if (nameTextField?.text == "") {
            let alertController = UIAlertController(title: "Alert!", message: "Registration field will not be Blank: Please check your Name.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else if (emailTextField?.text == "") {
            let alertController = UIAlertController(title: "Alert!", message: "Registration field will not be Blank: Please check your Email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else if (!(emailTextField?.text?.isValidEmail())!)  {
            let alertController = UIAlertController(title: "Alert", message: "This is not a Valid Email.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
        } else if (countryTextField.text == "") {
            let alertController = UIAlertController(title: "Alert!", message: "Registration field will not be Blank: Please select your Country from the list only.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }  else if (languageTextField.text == "") {
            let alertController = UIAlertController(title: "Alert!", message: "Registration field will not be Blank: Please select your language from the list only.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }  else if (mobileNumberTextField?.text == "") {
            let alertController = UIAlertController(title: "Alert!", message: "Registration field will not be Blank: Please check your Mobile Number.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }  else if (!(mobileNumberTextField?.text?.isValidPhono())!) {
            let alertController = UIAlertController(title: "Alert", message: "This is not a Valid Phone Number. Use only Numeric with your Country Code", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            print("Good YOU given all the details in Registration Field.")
            
             if (!(countryTextField.text == "")) {
                
                var countryTextFieldString : String = countryTextField.text!
                var CountryTextFieldValidate = String ()
                for coun in self.countryData {
                    
                    let countryName : String = coun["country_name"] as! String
                    print(countryName)
                    if (countryName == countryTextFieldString) {
                        CountryTextFieldValidate = countryTextFieldString
                        break
                    }
                    
                }
                
                if (countryTextFieldString == CountryTextFieldValidate) {
                    print("The country name is available in the web")
                    
                    languageFieldValidation()
                    
                } else {
                    let alertView = UIAlertController(title: "Alert", message: "This country is not available, please select from the country list.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertView.addAction(alertAction)
                    present(alertView, animated: true, completion: nil)
                    
                }
            }
            
        }
    
}// end save function
    
    // This function will validate that language is available in the Server or not
    func languageFieldValidation() {
        if (!(languageTextField.text == "")) {
            
            let languageTextFieldString : String  = languageTextField.text!
            var languageTextFieldValidate = String ()
            
            for lang in self.languageData {
                let languageName: String = lang["name"] as! String
                if (languageName == languageTextFieldString) {
                    languageTextFieldValidate = languageTextFieldString
                    break
                }
            }
            
            if (languageTextFieldString == languageTextFieldValidate) {
                print("This Language is available in List")
                smsFieldVarification()
            } else {
                let alertView = UIAlertController(title: "Alert", message: "This language is not available, please select from the language list.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertView.addAction(alertAction)
                present(alertView, animated: true, completion: nil)
            }
            
        }
    }
    // This method will send the OTP from FCM server.
    func smsFieldVarification () {
        
        defaults.set(nameTextField?.text, forKey: "userName")
        defaults.set(emailTextField?.text, forKey: "emailAddress")
        
        defaults.set(countryTextField.text, forKey: "countryName")
        defaults.set(languageTextField.text, forKey: "languageName")
        defaults.set(mobileNumberTextField?.text, forKey: "mobileNumber")
        PhoneAuthProvider.provider().verifyPhoneNumber((self.mobileNumberTextField?.text)!, completion: { (verificationID, error) in
            print("First time verification Id is \(verificationID)")
            if error != nil {
                print("error \(error?.localizedDescription)")
                self.alertViewControllerWithCancel(headerTile: "Error", bodyMessage: (error?.localizedDescription)! + " Add country code with + symbole if not added.  ")
            } else {
                let defaults = UserDefaults.standard.set(verificationID, forKey: "OTPVerificationID")
                //                    print("OTP is \(verificationID)")
                let verifyOTPView = self.storyboard?.instantiateViewController(withIdentifier: "OTPVerificationViewController") as! OTPVerificationViewController
                self.present(verifyOTPView, animated: true, completion: nil)
                
            }
        })
    }
    


} // end class

