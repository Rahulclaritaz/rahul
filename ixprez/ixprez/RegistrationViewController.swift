//
//  RegistrationViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 27/04/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate {
   

    @IBOutlet weak var viewScrollView: UIView!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var languagePickerView: UIPickerView!
    @IBOutlet weak var nameTextField : UITextField?
    @IBOutlet weak var emailTextField : UITextField?
    @IBOutlet weak var mobileNumberTextField : UITextField?
    @IBOutlet weak var saveButton: UIButton!
    
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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"bg_reg.png")!)
        self.viewScrollView.backgroundColor = UIColor(patternImage: UIImage(named:"bg_reg.png")!)
        getCountryDataFromTheWebService()
        getLanguageNameFromWebService()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard(rec:)))
            
        view.addGestureRecognizer(tap)
        nameTextField?.delegate = self
        saveButton.layer.cornerRadius = 20.0
        self.countryPickerView.delegate = self
        self.countryPickerView.dataSource = self
        self.countryPickerView.reloadAllComponents()
        
    }
    
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
            
      })
      
        
             
    }
   // This method Will call the Web Service to get the language and passing parameter
    func getLanguageNameFromWebService() -> Void
    {
    
        let paramsLanguage = ["list" : "language"] as Dictionary<String,String>
        
        getOTPClass.getLanguageDataWebService(urlString: getLanguageUrl.url(), dicData: paramsLanguage as NSDictionary)
        
        
    
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
             titleColor = NSAttributedString(string : titleData, attributes : [NSFontAttributeName: UIFont(name: "Georgia", size: 15.0)!, NSForegroundColorAttributeName: UIColor.white])
            return titleColor
        }
        if (pickerView == languagePickerView) {
            titleData = self.languageArrayData[row]
            titleColor = NSAttributedString(string : titleData, attributes : [NSFontAttributeName: UIFont(name: "Georgia", size: 15.0)!, NSForegroundColorAttributeName: UIColor.white])
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
    // rahul
    // This method will store the data into the NSUSerDefaults.
    @IBAction func saveButtonAction(_ sender: Any)
    {
        defaults.set(nameTextField?.text, forKey: "userName")
        defaults.set(emailTextField?.text, forKey: "emailAddress")
        defaults.set(countrySelectedValue.text, forKey: "countryName")
        defaults.set(languageSelectedValue.text, forKey: "languageName")
        defaults.set(mobileNumberTextField?.text, forKey: "mobileNumber")

        
        
        let parameter = ["user_name":defaults.string(forKey: "userName"),"email_id": defaults.string(forKey: "emailAddress"),"phone_number":defaults.string(forKey: "mobileNumber"),"country":defaults.string(forKey: "countryName"),"language": defaults.string(forKey: "languageName"),"device_id":appdelegate.deviceUDID,"notification": "1","reminder":"1","mobile_os":appdelegate.deviceOS,"mobile_version":appdelegate.deviceName,"mobile_modelname": appdelegate.deviceModel,"gcm_id":"DDD454564"]
       
     
        
        getOTPClass.getaddDeviceWebService(urlString: getOTPUrl.url(), dicData: parameter as NSDictionary)
        
        
        
              
        
}
}


