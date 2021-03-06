
//  XPContactViewController.swift
//  ixprez
//  Created by Claritaz Techlabs on 14/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.



import UIKit

import ContactsUI

import AddressBook

var expressEmailId = [String]()

var saveContactList = [ContactList]()

var deviceEmailID = [String]()

var devicePhoneNumber = [String]()

var contactStore = CNContactStore()

var contactss = [ContactEntry]()

var contactModeSelection = XPContactModeViewController()

let contact = CNContact()

enum ContactType
{
    case addressBookContact
    case cnContact
}

func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
    let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
    
    switch authorizationStatus
    {
    case .authorized: completion(true)
    // authorized previously
    case .denied, .notDetermined:
        // needs to ask for authorization
        contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
            completion(accessGranted)
        })
    default: // not authorized.
        completion(false)
    }
}

func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [ContactEntry]?) -> Void)
{
    var contacts = [ContactEntry]()
    do {
        let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
        try contactStore.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
            if let contact = ContactEntry(cnContact: cnContact)
            {
                contacts.append(contact)
                
            }
        })
        completion(true, contacts)
    }
    catch
    {
        completion(false, nil)
    }
}

func getContact()
{
    requestAccessToContacts { (success) in
        if success {
            retrieveContacts({ (success, contacts) in
                
                print("retrieve Contacts",contacts!)
                
                if success && (contacts?.count)! > 0
                {
                    contactss = contacts!
                    
                    saveContactList.removeAll()
                    
                    
                    for ccc in  contacts!
                    {
                        
                        if (ccc.phone != nil)  && (ccc.name != nil)
                            
                        {
                            let cont = ContactList()
                            
                            if (ccc.image != nil)
                            {
                                
                                cont.userName = ccc.name
                                
                                cont.emailId = ccc.email
                                
                                cont.imageData = ccc.image
                                
                                cont.phoneNumber = ccc.phone
                                
                                saveContactList.append(cont)
                                
                            // This will add the email id in contact.
                                
//                                deviceEmailID.append(ccc.email!)
                                
                                devicePhoneNumber.append(ccc.phone!)
                                print("The Total number of phone number in device With user image is  \(devicePhoneNumber.count)")
                            }
                            else
                            {
                                cont.userName = ccc.name
                                
                                cont.emailId = ccc.email
                                
                                cont.imageData = UIImage(named: "")
                                
                                cont.phoneNumber = ccc.phone
                                
                                
                                //ccc.image ?? UIImage(named: "UploadSmileyOrange")!
                                
                                saveContactList.append(cont)
                               
                                // This will add the email id in contact.
                                
//                                deviceEmailID.append(ccc.email!)
                                
                                devicePhoneNumber.append(ccc.phone!)
                                
                                //deviceName.append(ccc.name!)
                                print("The Total number of phone number in device With out user image is  \(devicePhoneNumber.count)")
                            }
                            
                            
                            
                        }
                        else
                            
                        {
                            print("Email or name is nil")
                        }
                        
                        
                    }
                    
                    
                    
                } else {
                    
                    print("Unable to get contacts...")
                }
            })
        }
    }
    
    // getWebServiceContact()
    
}

// create contact
func createAddressBookContactWithFirstName(_ firstName: String, lastName: String, email: String?, phone: String?, image: UIImage?)
{
    // first check permissions.
    
    let abAuthStatus = ABAddressBookGetAuthorizationStatus()
    if abAuthStatus == .denied || abAuthStatus == .restricted {
        //self.showAlertMessage("Sorry, you are not authorize to access the contacts.")
        return
    }
    
    // get addressbook reference.
    let addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    // now let's create the contact.
    let newContact: ABRecord = ABPersonCreate().takeRetainedValue()
    
    // first name
    if !ABRecordSetValue(newContact, kABPersonFirstNameProperty, firstName as CFTypeRef, nil)
    {
        //self.showAlertMessage("Error setting first name for the new contact")
        return
    }
    // last name
    if !ABRecordSetValue(newContact, kABPersonLastNameProperty, lastName as CFTypeRef, nil)
    {
        //self.showAlertMessage("Error setting last name for the new contact")
        return
    }
    // email
    if email != nil
    {
        let emails: ABMutableMultiValue =
            ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(emails, email! as CFTypeRef!, kABHomeLabel, nil)
        if !ABRecordSetValue(newContact, kABPersonEmailProperty, emails, nil) {
            // self.showAlertMessage("Error setting email for the new contact")
            return
        }
        
    }
    
    // phone number
    if phone != nil {
        let phoneNumbers: ABMutableMultiValue =
            ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(phoneNumbers, phone! as CFTypeRef!, kABPersonPhoneMainLabel, nil)
        if !ABRecordSetValue(newContact, kABPersonPhoneProperty, phoneNumbers, nil) {
            //self.showAlertMessage("Error setting phone number for the new contact")
            return
        }
    }
    
    // image
    if image != nil {
        let imageData = UIImageJPEGRepresentation(image!, 0.9)
        if !ABPersonSetImageData(newContact, imageData as CFData!, nil) {
            //self.showAlertMessage("Error setting image for the new contact")
            return
        }
    }
    
    // finally, store person and save addressbook
    var errorSavingContact = false
    if ABAddressBookAddRecord(addressBookRef, newContact, nil) { // stored. Now save addressbook.
        if ABAddressBookHasUnsavedChanges(addressBookRef){
            if !ABAddressBookSave(addressBookRef, nil) {
                errorSavingContact = true
            }
        }
    }
    
    if errorSavingContact
    {
        // self.showAlertMessage("There was an error storing your new contact. Please try again.")
    }
    else
    {
        // self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}


func createCNContactWithFirstName(_ firstName: String, lastName: String, email: String?, phone: String?, image: UIImage?)
{
    // create contact with mandatory values: first and last name
    let newContact = CNMutableContact()
    newContact.givenName = firstName
    newContact.familyName = lastName
    
    // email
    if email != nil {
        let contactEmail = CNLabeledValue(label: CNLabelHome, value: email! as NSString)
        newContact.emailAddresses = [contactEmail]
    }
    // phone
    if phone != nil {
        let contactPhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: phone!))
        newContact.phoneNumbers = [contactPhone]
    }
    
    // image
    if image != nil {
        newContact.imageData = UIImageJPEGRepresentation(image!, 0.9)
    }
    
    do {
        let newContactRequest = CNSaveRequest()
        newContactRequest.add(newContact, toContainerWithIdentifier: nil)
        try CNContactStore().execute(newContactRequest)
        
        //self.presentingViewController?.dismiss(animated: true, completion: nil)
    } catch
    {
        //self.showAlertMessage("I was unable to create the new contact. An error occurred.")
    }
}



protocol contactEmailDelegate
{
    func passEmailToAudioAndVideo (email : String, name : String)
}

class XPContactViewController: UIViewController, CNContactPickerDelegate, UISearchBarDelegate
{
    
    var saveRecentContactList = [RecentContactList]()
    
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchHight: NSLayoutConstraint!
    @IBOutlet weak var contactSegmentationController: UISegmentedControl!
    var classReference : ContactList!
    
    @IBOutlet weak var contactHeaderView: UIView!
    
    var isFromMenu = Bool()
    var isFromAudio = Bool ()
    var cnPicker = CNContactPickerViewController()
    var saveContactList1 = [ContactList]()
    let appDelegate = AppDelegate ()
    
    // data
    var typeCon: ContactType?
    var isFiltered : Bool!
    var emailDelegate : contactEmailDelegate?
    var userEmail = String ()
    var userName = String ()
    var webReference = PrivateWebService()
    var deviceName = [String]()
    var urlReference = URLDirectory.contactData()
    
    
    var getIxpressContactList  = [[String :Any]]()
    
    //var deviceName = [String]()
    
    var filterData = [ContactList]()
    var isRecent : Bool!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // recentEmailId.append("jnjaga24@gmail.com ")
        
        
        isFiltered = false
        
        isRecent = false
        
        self.navigationItem.title = "Contact"
        
        
        self.navigationItem.title = "Contact"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // print("check Contact List",contactSegmentationController.selectedSegmentIndex)
        
        cnPicker.delegate = self as CNContactPickerDelegate
        
        
        getContact()
        getWebServiceContact()
        // getRecentWebServiceContact()
        
    }
    
    @IBAction func segmentAction(_ sender: Any)
    {
        if (sender as AnyObject).selectedSegmentIndex == 0
        {
            isRecent = false
            getContact()
            getWebServiceContact()
            
            DispatchQueue.main.async {
                
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    
                    self.searchHight.constant = 44
                    
                    self.view.layoutIfNeeded()
                    
                    
                }, completion: nil)
                
            }
            
        }
        else
        {
            isRecent = true
            
            getContact()
            getWebServiceContact()
            getRecentWebServiceContact()
            
            DispatchQueue.main.async {
                
                
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    
                    self.searchHight.constant = 0
                    
                    self.view.layoutIfNeeded()
                    
                }, completion: nil)
                
                
            }
            
            
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        // getWebServiceContact()
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonAction (sender : Any)
    {
        guard (isFromMenu) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        
    }
    func getWebServiceContact()
    {
//        print("emmmm",deviceEmailID)
        print("The contact of the phone list is",devicePhoneNumber)
        
        var setData = Set<String>()
        
//        for email in deviceEmailID
//        {
//            
//            setData.insert(email)
//            
//        }
//        
//        var newEmail = [String]()
//        
//        
//        for data in setData
//        {
//            
//            newEmail.append(data)
//            
//            
//        }
        
        for phoneNumber in devicePhoneNumber
        {
            
            setData.insert(phoneNumber)
            
        }
        
        var newPhoneNumber = [String]()
        
        
        for data in setData
        {
            
            newPhoneNumber.append(data)
            
            
        }
        
        print("with out dupliacte data",setData)
        
        
        print("with out dupliacte data in array",newPhoneNumber)
        
        
        let para = { ["contactList" :  newPhoneNumber ] }
        
        webReference.getiXprezUserValidateWebService(urlString: urlReference.getXpressContact(), dicData: para() , callback: { (myData ,error) in
            
            
            self.getIxpressContactList = myData["data"] as! [[String:Any]]
            
            
            
            if  self.getIxpressContactList.isEmpty
            {
                print("No Data")
            }
                
            else
            {
                for xpressContactList in self.getIxpressContactList
                {
                    
                    let newData = ContactList()
                    
                    let newData1 = RecentContactList()
                    
                    
                    print("The iXprez user name is ",xpressContactList["user_name"] as! String)
                    
                    newData.userName = xpressContactList["user_name"] as! String
                    
//                    newData.emailId = xpressContactList["email_id"] as! String
                    newData.phoneNumber = xpressContactList["email_id"] as! String
                    
                    
                    newData1.userNameRecent = xpressContactList["user_name"] as! String
                    
//                    newData1.emailIdRecent = xpressContactList["email_id"] as! String
                    newData1.phoneNumberRecent  = xpressContactList["email_id"] as! String
                    
                    
                    expressEmailId.append(xpressContactList["email_id"] as! String)
                    
                    
                    
                    newData.imageData = nil
                    
                    newData1.imageDataRecent = nil
                    
                    
                    let imageString = xpressContactList["profile_image"] as! String
                    
                    DispatchQueue.global(qos: .background).async
                        {
                            let url = URL(string: imageString)
                            
                            let sess = URLSession.shared
                            
                            let dataTask = sess.dataTask(with: url!, completionHandler:
                            { ( data,response,error) in
                                
                                DispatchQueue.main.async
                                    {
                                        
                                        newData.imageData = UIImage(data: data!)!
                                        
                                        newData1.imageDataRecent = UIImage(data: data!)!
                                        
                                        self.contactTableView?.reloadData()
                                }
                                
                                
                            })
                            
                            dataTask.resume()
                            
                            
                    }
                    
                    // This will delete the expressuser contact from contact list already appear in the contact list. to avoid the duplicasy with expressUser and device contact user
                    for(index, element ) in saveContactList.enumerated() {
                        let expressUserEmail = newData.phoneNumber
                        let contactUserEmail = saveContactList[index].phoneNumber
                        print("The contact user phonenumber is \(saveContactList[index].phoneNumber) at index \(index)")
                        let contactUserName = saveContactList[index].userName
                        print("The contact user name is \(saveContactList[index].userName) at index \(index)")
                        
                        if (expressUserEmail == contactUserEmail) {
                            saveContactList.remove(at: index)
                            break
                        }
                        
                    }
                    // This will save the expressuser in the device contact.
                    saveContactList.insert(newData, at: 0)
                    
                    self.saveRecentContactList.append(newData1)
                    
                    
                }
                
                print("mathan cmathan check",expressEmailId)
                
            }
            
        })
        
    }
    
    func getRecentWebServiceContact()
    {
        isRecent = true
        
//        if ((UserDefaults.standard.object(forKey: "toEmailAddress")) != nil) {
//            saveContactList1 = saveContactList.filter({
//                
//                return $0.emailId.lowercased().range(of: UserDefaults.standard.object(forKey: "toEmailAddress") as! String) != nil
//                
//            })
//            
//        }
        
        DispatchQueue.main.async {
            
            self.contactTableView.reloadData()
            
        }
        print("mathan check",saveContactList1)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    
    // This method will search the contact
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        
        searchBar.resignFirstResponder()
        DispatchQueue.main.async
            {
                
                self.contactTableView?.reloadData()
        }
        
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        if searchText.characters.count == 0
        {
            isFiltered = false
            
            DispatchQueue.main.async
                {
                    self.contactTableView?.reloadData()
            }
            
            
        }
        else
        {
            isFiltered = true
            
            filterData = saveContactList.filter({
                
                return $0.userName.lowercased().range(of: searchText.lowercased(), options: .caseInsensitive) != nil
            })
            
            DispatchQueue.main.async
                {
                    self.contactTableView?.reloadData()
            }
            print(filterData)
            
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        
        searchBar.resignFirstResponder()
        
    }
}
extension XPContactViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isRecent == false
        {
            if isFiltered == false
            {
                return saveContactList.count
            }
            else
            {
                return filterData.count
            }
            
        }
        else
        {
            return saveContactList1.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cellIdentifier = "XPContactTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactTableViewCell
        
        cell.contactType?.image = UIImage(named: "bg_reg.png")
        
        
        
        if isRecent == false
        {
            
            if isFiltered == false
            {
                
                
                let entry = saveContactList[indexPath.row]
                cell.configureWithContactEntry(entry)
                cell.layoutIfNeeded()
                return cell
            }
            else
            {
                let entry = filterData[indexPath.row]
                cell.configureWithContactEntry(entry)
                cell.layoutIfNeeded()
                return cell
            }
            
        }
        else
        {
            
            let entry1  = saveContactList1[indexPath.row]
            
            cell.configureWithContactEntry1(entry1)
            
            cell.layoutIfNeeded()
            
            
            return cell
            
        }
        
        return cell
    }
    
    
}

extension XPContactViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if isRecent == false
        {
            if isFiltered != true
            {
                let entry = saveContactList[indexPath.row]
                
                print("chech tableview Data",entry)
                
                let email = entry.phoneNumber
                let name = entry.userName
                if (email == nil)
                {
                    userEmail = "No Phone-Number"
                } else
                {
                    userEmail = email!
                    userName = name!
                    
                    // deviceEmailID.append(email!)
                    
                }
                
                guard (isFromMenu) else {
                    
                    guard (isFromAudio) else {
                        //                let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "XPCameraBaseViewController") as! XPCameraBaseViewController
                        //                videoVC.selectedUserEmail = userEmail
                        //                videoVC.contactVideo = true
                        
                        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPCameraBaseViewController") as! XPCameraBaseViewController
                        storyboard.selectedUserEmail = userName+" - "+userEmail
//                        storyboard.selectedUserName = userName
                        storyboard.contactVideo = true
                        let navigation = UINavigationController.init(rootViewController: storyboard)
                        self.navigationController?.present(navigation, animated: true, completion: nil)
//                                        self.navigationController?.popViewController(animated: true)
//                                        emailDelegate?.passEmailToAudioAndVideo(email: userEmail, name: userName)
                        //                self.navigationController?.pushViewController(videoVC, animated: true)
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
                    emailDelegate?.passEmailToAudioAndVideo(email: userEmail, name: userName)
                    return
                }
                
                let  popController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPContactModeViewController") as! XPContactModeViewController
                self.addChildViewController(popController)
                popController.contactUserEmail = userEmail
                popController.contactUserName = userName
                popController.view.frame = self.view.frame
                self.view.addSubview(popController.view)
                popController.didMove(toParentViewController: self)
                
                
                
                //        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPAudioViewController") as! XPAudioViewController
                //        storyBoard.selectContactEmail = true
                //        storyBoard.emailAddressLabel.text = userEmail
                //        self.navigationController?.pushViewController(storyBoard, animated: true)
                //self.dismiss(animated: true, completion: nil)
                
            }
                
            else
            {
                let entry = filterData[indexPath.row]
                
                print("chech tableview Data",entry)
                
                let email = entry.phoneNumber
                if (email == nil)
                {
                    userEmail = "No Phone-Number"
                } else
                {
                    userEmail = email!
                    
                    // deviceEmailID.append(email!)
                    
                }
                
                guard (isFromMenu) else {
                    
                    guard (isFromAudio) else {
                        //                let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "XPCameraBaseViewController") as! XPCameraBaseViewController
                        //                videoVC.selectedUserEmail = userEmail
                        //                videoVC.contactVideo = true
                        
                        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPCameraBaseViewController") as! XPCameraBaseViewController
                        storyboard.selectedUserEmail = userName+" - "+userEmail
                        storyboard.contactVideo = true
                        let navigation = UINavigationController.init(rootViewController: storyboard)
                        self.navigationController?.present(navigation, animated: true, completion: nil)
                        //                self.navigationController?.popViewController(animated: true)
                        //                emailDelegate?.passEmailToAudioAndVideo(email: userEmail)
                        //                self.navigationController?.pushViewController(videoVC, animated: true)
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
                    emailDelegate?.passEmailToAudioAndVideo(email: userEmail, name: userName)
                    return
                }
                
                
                
                //            guard (isFromMenu) else {
                //                self.navigationController?.popViewController(animated: true)
                //                emailDelegate?.passEmailToAudioAndVideo(email: userEmail)
                //                return
                //            }
                
                //            let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPAudioViewController") as! XPAudioViewController
                //            storyBoard.selectContactEmail = true
                //            storyBoard.emailAddressLabel.text = userEmail
                //            self.navigationController?.pushViewController(storyBoard, animated: true)
                
                
                
                let  popController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPContactModeViewController") as! XPContactModeViewController
                self.addChildViewController(popController)
                popController.contactUserEmail = userEmail
                popController.view.frame = self.view.frame
                self.view.addSubview(popController.view)
                popController.didMove(toParentViewController: self)
                
                
            }
        }
            
            
        else
        {
            let entry = saveContactList1[indexPath.row]
            
            print("chech tableview Data",entry)
            
            let email = entry.emailId
            if (email == nil)
            {
                userEmail = "No Email"
            } else
            {
                userEmail = email!
                
                // deviceEmailID.append(email!)
                
            }
            
            guard (isFromMenu) else {
                
                guard (isFromAudio) else {
                    //                let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "XPCameraBaseViewController") as! XPCameraBaseViewController
                    //                videoVC.selectedUserEmail = userEmail
                    //                videoVC.contactVideo = true
                    
                    let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "XPCameraBaseViewController") as! XPCameraBaseViewController
                    storyboard.selectedUserEmail = userEmail+" - "+userName
                    storyboard.contactVideo = true
                    let navigation = UINavigationController.init(rootViewController: storyboard)
                    self.navigationController?.present(navigation, animated: true, completion: nil)
                    //                self.navigationController?.popViewController(animated: true)
                    //                emailDelegate?.passEmailToAudioAndVideo(email: userEmail)
                    //                self.navigationController?.pushViewController(videoVC, animated: true)
                    return
                }
                self.navigationController?.popViewController(animated: true)
                emailDelegate?.passEmailToAudioAndVideo(email: userEmail, name: userName)
                return
            }
            
            let  popController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "XPContactModeViewController") as! XPContactModeViewController
            self.addChildViewController(popController)
            popController.contactUserEmail = userEmail
            popController.view.frame = self.view.frame
            self.view.addSubview(popController.view)
            popController.didMove(toParentViewController: self)
            
            
            
            //        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPAudioViewController") as! XPAudioViewController
            //        storyBoard.selectContactEmail = true
            //        storyBoard.emailAddressLabel.text = userEmail
            //        self.navigationController?.pushViewController(storyBoard, animated: true)
            //self.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    
}
