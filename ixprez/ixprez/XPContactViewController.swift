//
//  XPContactViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 14/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit
import ContactsUI

protocol contactEmailDelegate {
    func passEmailToAudioAndVideo (email : String)
}

class XPContactViewController: UIViewController, CNContactPickerDelegate, UISearchBarDelegate {
    
    
    var isFromMenu = Bool()
    var cnPicker = CNContactPickerViewController()
    var contact = CNContact ()
    let appDelegate = AppDelegate ()
    // data
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    var isFiltered : Bool!
    var emailDelegate : contactEmailDelegate?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                    //                    self.tableView.isHidden = !success
                    //                    self.noContactsLabel.isHidden = success
                    if success && (contacts?.count)! > 0 {
                        self.contacts = contacts!
                        self.contactTableView?.reloadData()
                    } else {
                        //self.noContactsLabel.text = "Unable to get contacts..."
                        print("Unable to get contacts...")
                    }
                })
            }
        }
    }
    
    
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(accessGranted)
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [ContactEntry]?) -> Void) {
        var contacts = [ContactEntry]()
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
            try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = ContactEntry(cnContact: cnContact) { contacts.append(contact) }
            })
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
    }
    
    // This method will search the contact
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //    recordisFiltered.removeAll()
        
        
        if (searchBar.text?.characters.count)! <= 2
        {
            //        isFiltered = false
            
            let alert = UIAlertController(title: nil, message: "please enter minimum three characters", preferredStyle: .alert)
            
            
            let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action1)
            
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        else
        {
            
            
            isFiltered = true
            
            
            DispatchQueue.global(qos: .background).async {
                
                
//                self.recordisFiltered = self.recordPublicVideo.filter({
                
                    //   let string1 = $0["tags"] as! String
                    
//                    let string2 = $0["title"] as! String
                
                    //  let string = string1 + string2
                    
                    
                    
//                    return string2.lowercased().range(of: searchBar.text!.lowercased() )  != nil
                
                    
                    
//                })
                
                
//                print("check data filter",self.recordisFiltered)
                
//                if self.recordisFiltered.count == 0
//                {
//                    self.isFiltered = false
//                }
//                else
//                {
//                    self.isFiltered = true
//                }
                
                DispatchQueue.main.async {
                    
                    self.contactTableView?.reloadData()
                    
                }
                
                
            }
            
        }
        
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.navigationController?.navigationBar.isHidden = false
//            self.collectionViewWidth.constant = 160
            
            self.view.layoutIfNeeded()
            
            
        })
        
        
        
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        /*
         if searchText.characters.count == 0
         {
         isFiltered = false
         DispatchQueue.main.async
         {
         
         self.publicTableView.reloadData()
         
         }
         
         }
         else
         {
         
         isFiltered = true
         
         recordisFiltered.removeAll()
         
         DispatchQueue.global(qos: .background).async {
         
         
         self.recordisFiltered = self.recordPublicVideo.filter({
         
         let string = $0["title"] as! String
         
         
         return string.lowercased().range(of: searchText.lowercased() ) != nil
         
         })
         
         
         
         DispatchQueue.main.async {
         
         self.publicTableView.reloadData()
         
         }
         
         
         }
         
         
         }
         
         
         */
        
        
        
//        print("mathan search",recordisFiltered)
        
        
        
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        
        
        searchBar.resignFirstResponder()
        
        return true
        
        
    }
    
//    func fetchContacts()
//    {
//       var dataArray = NSMutableArray()
//        
//        let toFetch = [CNContactGivenNameKey, CNContactImageDataKey, CNContactFamilyNameKey, CNContactImageDataAvailableKey]
//        let request = CNContactFetchRequest(keysToFetch: toFetch as [CNKeyDescriptor])
//        
//        do{
//        /*   try appDelegate.conta .enumerateContactsWithFetchRequest(request) {
//                contact, stop in */
//                print(contact.givenName)
//                print(contact.familyName)
//                print(contact.identifier)
//                
//                var userImage : UIImage;
//                // See if we can get image data
//                if let imageData = contact.imageData {
//                    //If so create the image
//                    userImage = UIImage(data: imageData)!
//                }else{
//                    userImage = UIImage(named: "no_contact_image")!
//                }
//                
////            let data = Data(named: contact.givenName)
////                self.dataArray?.addObject(data)
//            
////            }
//        } catch let err{
//            print(err)
////            self.errorStatus()
//        }
//        
//        self.contactTableView?.reloadData()
//        
//    }
    
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
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "XPContactTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactTableViewCell
//        cell.contactUserProfile?.layer.masksToBounds = true
//        cell.contactUserProfile?.layer.cornerRadius = (cell.contactUserProfile?.frame.size.width)!/2
////        cell.contactUserProfile?.backgroundColor = UIColor.orange
//        cell.contactUserName?.text = "Mark Bravo"
////        let emailAddrs = (contact.emailAddresses)
////        let emailAddrsVaue = emailAddrs.val
//        cell.contactUserEmail?.text = "markbravo@gmail.com"
        let entry = contacts[(indexPath as NSIndexPath).row]
        cell.configureWithContactEntry(entry)
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellIdentifier = "XPContactHeaderTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactHeaderTableViewCell
        cell.searchBar?.delegate = self as! UISearchBarDelegate
        return cell.contentView
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    
}

extension XPContactViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cellIdentifier = "XPContactTableViewCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! XPContactTableViewCell
//        cell.configureWithContactEntry(ContactEntry)
        let entry = contacts[(indexPath as NSIndexPath).row]
        let email = entry.email
        emailDelegate?.passEmailToAudioAndVideo(email: email!)
        
        guard (isFromMenu) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

