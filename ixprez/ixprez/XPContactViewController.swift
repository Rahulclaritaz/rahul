//
//  XPContactViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 14/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import ContactsUI

class XPContactViewController: UIViewController, CNContactPickerDelegate {
    var cnPicker = CNContactPickerViewController()
    var contact = CNContact ()
    let appDelegate = AppDelegate ()
    @IBOutlet weak var contactTableView = UITableView ()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(contact)
        cnPicker.delegate = self as! CNContactPickerDelegate
        self.fetchContacts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchContacts()
    {
       var dataArray = NSMutableArray()
        
        let toFetch = [CNContactGivenNameKey, CNContactImageDataKey, CNContactFamilyNameKey, CNContactImageDataAvailableKey]
        let request = CNContactFetchRequest(keysToFetch: toFetch as [CNKeyDescriptor])
        
        do{
        /*   try appDelegate.conta .enumerateContactsWithFetchRequest(request) {
                contact, stop in */
                print(contact.givenName)
                print(contact.familyName)
                print(contact.identifier)
                
                var userImage : UIImage;
                // See if we can get image data
                if let imageData = contact.imageData {
                    //If so create the image
                    userImage = UIImage(data: imageData)!
                }else{
                    userImage = UIImage(named: "no_contact_image")!
                }
                
//            let data = Data(named: contact.givenName)
//                self.dataArray?.addObject(data)
            
//            }
        } catch let err{
            print(err)
//            self.errorStatus()
        }
        
        self.contactTableView?.reloadData()
        
    }
    
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
//        for number in contact.phoneNumbers {
//            let phoneString = number.value.stringValue
////            phoneLabel?.text = phoneString
//            print("The phone number is :\(phoneString)")
//        }
//        
//        for email in contact.emailAddresses {
//            let emailAddress = email.value
////            emailLabel?.text = emailAddress as String
//            print("the email is \(emailAddress)")
//            //            emailLabel?.text = email.
//        }
//        
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension XPContactViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "XPContactTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactTableViewCell
        cell.contactUserName?.text = contact.givenName
//        let emailAddrs = (contact.emailAddresses)
//        let emailAddrsVaue = emailAddrs.val
//        cell.contactUserEmail?.text = emailAddrs
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellIdentifier = "XPContactHeaderTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactHeaderTableViewCell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    
}

extension XPContactViewController : UITableViewDelegate {
    
}

