//
//  XPContactViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 14/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//


import UIKit
import ContactsUI

var deviceEmailID = [String]()

var recentEmailID = [String]()

 
protocol contactEmailDelegate
{
    func passEmailToAudioAndVideo (email : String)
}

class XPContactViewController: UIViewController, CNContactPickerDelegate, UISearchBarDelegate
{
    @IBOutlet weak var contactSegmentationController: UISegmentedControl!
    var classReference : ContactList!
    
    @IBOutlet weak var contactHeaderView: UIView!
    
    var isFromMenu = Bool()
    var cnPicker = CNContactPickerViewController()
    var contact = CNContact ()
    let appDelegate = AppDelegate ()
    // data
    var contactStore = CNContactStore()
    var contacts = [ContactEntry]()
    var isFiltered : Bool!
    var emailDelegate : contactEmailDelegate?
    var userEmail = String ()
    var webReference = PrivateWebService()
    var deviceName = [String]()
    var urlReference = URLDirectory.contactData()
    
    
    //var deviceName = [String]()
    
    var saveContactList = [ContactList]()
    
    var filterData = [ContactList]()
    
    var isRecent : Bool!
    
    
    @IBOutlet weak var contactTableView = UITableView ()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        isFiltered = false
        isRecent = false
        
        
     deviceEmailID.append("mathan6@gmail.com")
        
     recentEmailID.append("kavin6@gmail.com")
        recentEmailID.append("kavinarush6@gmail.com")
        
        
        
        self.navigationItem.title = "Contact"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 103.0/255.0, green: 68.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
       // print("check Contact List",contactSegmentationController.selectedSegmentIndex)
        
        cnPicker.delegate = self as CNContactPickerDelegate
        
        
        getContact()
         
    }
    
    @IBAction func segmentAction(_ sender: Any)
    {
        if (sender as AnyObject).selectedSegmentIndex == 0
        {
            getContact()
            
            isRecent = false
            
        }
        else
        {
            isRecent = true
          //  getContact()
            
        }

        
    }
    
    
    func getContact()
    {
        requestAccessToContacts { (success) in
            if success {
                self.retrieveContacts({ (success, contacts) in
                  
                    print("retrieve Contacts",contacts!)
                    
                    if success && (contacts?.count)! > 0
                    {
                        
                        
                        self.contacts = contacts!
                        
                      self.saveContactList.removeAll()
                        
                      
                        
                    for ccc in self.contacts
                    {
                        
                        
                        if (ccc.email != nil)  && (ccc.name != nil)
                            
                        {
                            let cont = ContactList()

                            if (ccc.image != nil)
                            {
                                
                                
                                cont.userName = ccc.name
                                
                                cont.emailId = ccc.email
                                
                                cont.imageData = ccc.image
                                
                                self.saveContactList.append(cont)
                                
                                deviceEmailID.append(ccc.email!)
                                
                                    self.deviceName.append(ccc.name!)
                            }
                            else
                            {
                                
                                
                                
                                cont.userName = ccc.name
                                
                                cont.emailId = ccc.email
                                
                                cont.imageData =  ccc.image ?? UIImage(named: "UploadSmileyOrange")!
                                
                                self.saveContactList.append(cont)
                                
                                deviceEmailID.append(ccc.email!)
                                
                                self.deviceName.append(ccc.name!)
                            }
                            
                            
                            
                        }
                        else
                            
                        {
                            
                        }
                        
                        
                    }
                    
                    DispatchQueue.main.async
                        {
                            self.contactTableView?.reloadData()
                            
                    }
                    
                } else {
                    
                    print("Unable to get contacts...")
                }
            })
        }
    }

    getWebServiceContact()

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
            
            var imagData = UIImage()
            
       if  getIxpressContactList.isEmpty
       {
        print("No Data")
        
       }
        
        else
        {
            for xpressContactList in getIxpressContactList
            {
                
                let imgString = xpressContactList["profile_image"] as! String
                
                
                DispatchQueue.global(qos: .background).async
                    {
                        let url = URL(string: imgString)
                        
                        let sess = URLSession.shared
                        
                        let dataTask = sess.dataTask(with: url!, completionHandler:
                        { ( data,response,error) in
                            
                            DispatchQueue.main.async
                                {
                                    
                                    imagData = UIImage(data: data!)!
                                    
                            }
                            
                        })
                        
                        dataTask.resume()
                        
                        
                }
              
                let newData = ContactList()
                
                newData.userName = xpressContactList["user_name"] as! String
                
                newData.emailId = xpressContactList["email_id"] as! String
                
                newData.imageData = imagData
                
                self.saveContactList.insert(newData, at: 0)
            
            }
      
        }
            DispatchQueue.main.async {
                
                self.contactTableView?.reloadData()
                
            }

        
        
            print("wwwww",myData)
            
        })
            
        
                       //getPrivateAcceptRejectWebService
        
        
    }
    
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true)
        // authorized previously
        case .denied, .notDetermined:
            // needs to ask for authorization
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
                if let contact = ContactEntry(cnContact: cnContact)
                {
                    contacts.append(contact)
                 
                }
            })
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
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
        if isRecent == true
        {
        let cellIdentifier = "XPContactTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactTableViewCell
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
            let cellIdentifier = "XPContactTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactTableViewCell
                let entry = saveContactList[indexPath.row]
                cell.configureWithContactEntry(entry)
                cell.layoutIfNeeded()
 
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellIdentifier = "XPContactHeaderTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! XPContactHeaderTableViewCell
        cell.searchBar?.delegate = self
        
        return cell.contentView
    
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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

