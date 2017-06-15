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
    
    
    var isFromMenu = Bool()
    var cnPicker = CNContactPickerViewController()
    var contact = CNContact ()
    let appDelegate = AppDelegate ()
    @IBOutlet weak var contactTableView = UITableView ()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Contact"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        print(contact)
        cnPicker.delegate = self as! CNContactPickerDelegate
//        self.fetchContacts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction (sender : Any) {
        guard (isFromMenu) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true, completion: nil)
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
        cell.contactUserProfile?.layer.masksToBounds = true
        cell.contactUserProfile?.layer.cornerRadius = (cell.contactUserProfile?.frame.size.width)!/2
//        cell.contactUserProfile?.backgroundColor = UIColor.orange
        cell.contactUserName?.text = "Mark Bravo"
//        let emailAddrs = (contact.emailAddresses)
//        let emailAddrsVaue = emailAddrs.val
        cell.contactUserEmail?.text = "markbravo@gmail.com"
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

