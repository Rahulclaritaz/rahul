//
//  XPContactViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 14/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//


import UIKit
import ContactsUI
import AddressBook

var saveContactList = [ContactList]()

var deviceEmailID = [String]()

var recentEmailID = [String]()

var contactStore = CNContactStore()

var contactss = [ContactEntry]()

 let contact = CNContact ()

enum ContactType
{
    case addressBookContact
    case cnContact
}

func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
    let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
    
    switch authorizationStatus {
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

func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [ContactEntry]?) -> Void) {
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
                     
                        if (ccc.email != nil)  && (ccc.name != nil)
                            
                        {
                            let cont = ContactList()
                            
                            if (ccc.image != nil)
                            {
                                
                                
                                cont.userName = ccc.name
                                
                                cont.emailId = ccc.email
                                
                                cont.imageData = ccc.image
                                
                                saveContactList.append(cont)
                                
                                deviceEmailID.append(ccc.email!)
                             
                               // deviceName.append(ccc.name!)
                            }
                            else
                            {
                                cont.userName = ccc.name
                                
                                cont.emailId = ccc.email
                                
                                cont.imageData =  ccc.image ?? UIImage(named: "UploadSmileyOrange")!
                                
                                saveContactList.append(cont)
                                
                                deviceEmailID.append(ccc.email!)
                                
                                //deviceName.append(ccc.name!)
                            }
                            
                            
                            
                        }
                        else
                            
                        {
                            
                        }
                        
                        
                    }
                    
                   /* DispatchQueue.main.async
                        {
                        contactTableView?.reloadData()
                            
                    }*/
 
                    
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
    func passEmailToAudioAndVideo (email : String)
}

class XPContactViewController: UIViewController, CNContactPickerDelegate, UISearchBarDelegate
{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchHight: NSLayoutConstraint!
    @IBOutlet weak var contactSegmentationController: UISegmentedControl!
    var classReference : ContactList!
    
    @IBOutlet weak var contactHeaderView: UIView!
    
    var isFromMenu = Bool()
    var cnPicker = CNContactPickerViewController()
    var saveContactList1 = [ContactList]()
    let appDelegate = AppDelegate ()
    
    // data
   var typeCon: ContactType?
    var isFiltered : Bool!
    var emailDelegate : contactEmailDelegate?
    var userEmail = String ()
    var webReference = PrivateWebService()
    var deviceName = [String]()
    var urlReference = URLDirectory.contactData()
    
    
    //var deviceName = [String]()
    var filterData = [ContactList]()
    
    var isRecent : Bool!
    
    
    @IBOutlet weak var contactTableView = UITableView ()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        isFiltered = false
        isRecent = false
     
        
     recentEmailID.append("kavin6@gmail.com")
        
     recentEmailID.append("kavinarush6@gmail.com")
        
        
        
        self.navigationItem.title = "Contact"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
       // print("check Contact List",contactSegmentationController.selectedSegmentIndex)
        
        cnPicker.delegate = self as CNContactPickerDelegate
        
        
         getContact()
         getWebServiceContact()
        
         
    }
    
    @IBAction func segmentAction(_ sender: Any)
    {
        if (sender as AnyObject).selectedSegmentIndex == 0
        {
            
            isRecent = false
            
            self.view.layoutIfNeeded()
            
            searchHight.constant = 44
            
            self.view.layoutIfNeeded()
        }
        else
        {
            isRecent = true
          
            
            
            self.view.layoutIfNeeded()
            
            searchHight.constant = 0
            
            self.view.layoutIfNeeded()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    func getWebServiceContact()
    {
        print("emmmm",deviceEmailID)
        
        
        
   let para = { ["contactList" :  deviceEmailID ] }
        
        webReference.getPrivateAcceptRejectWebService1(urlString: urlReference.getXpressContact(), dicData: para() , callback: { (myData ,error) in
            
            
            let getIxpressContactList = myData["data"] as! [[String:Any]]
            
            
            
       if  getIxpressContactList.isEmpty
       {
        print("No Data")
        }
        
        else
        {
            for xpressContactList in getIxpressContactList
            {
               
                let newData = ContactList()
                 print("name mathan",xpressContactList["user_name"] as! String)
                newData.userName = xpressContactList["user_name"] as! String
                
                newData.emailId = xpressContactList["email_id"] as! String
                
                
                
                
           // saveContactList.insert(newData, at: 1)
                
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
                         
                            }
                            
                            
                        })
                        
                        dataTask.resume()
                        
                       // saveContactList.insert(newData, at: 0)
 
                }
       saveContactList.insert(newData, at: 0)
            }
            
      
        }
            DispatchQueue.main.async {
                
                self.contactTableView?.reloadData()
                
            }

        
        
            print("wwwww",myData)
            
        })
            
        
                       //getPrivateAcceptRejectWebService
        
        
    }
    
    
      // This method will search the contact
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        
        searchBar.resignFirstResponder()
        DispatchQueue.main.async {
            
            self.contactTableView?.reloadData()
        }
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        if searchText.characters.count == 0
        {
            isFiltered = false
            
        }
        else
        {
            isFiltered = true
           
            filterData = saveContactList.filter({
             
         return $0.emailId.lowercased().range(of: searchText.lowercased(), options: .caseInsensitive) != nil
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
           
            return saveContactList.count
        }
    
    
    
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        let cellIdentifier = "XPContactTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactTableViewCell
        
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
           
            
            /*let cellIdentifier = "XPContactTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactTableViewCell
                let entry = saveContactList[indexPath.row]
                cell.configureWithContactEntry(entry)
                cell.layoutIfNeeded()
 */
            
                return cell
        }
    }
    
         
}

extension XPContactViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entry = saveContactList[indexPath.row]
        
        print("chech tableview Data",entry)
        
        let email = entry.emailId
        if (email == nil) {
            userEmail = "No Email"
        } else {
            userEmail = email!
            
            deviceEmailID.append(email!)
            
        }
        
        guard (isFromMenu) else {
            self.navigationController?.popViewController(animated: true)
            emailDelegate?.passEmailToAudioAndVideo(email: userEmail)
            return
        }
        
        let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "XPAudioViewController") as! XPAudioViewController
        storyBoard.selectContactEmail = true
        storyBoard.emailAddressLabel.text = userEmail
        self.navigationController?.pushViewController(storyBoard, animated: true)
        //self.dismiss(animated: true, completion: nil)
        
    }
    
}

