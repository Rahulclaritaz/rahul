//
//  XPSettingLanguageCountryViewController.swift
//  ixprez
//
//  Created by Quad on 6/6/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

protocol passData
{
    func passingCounData(name : String)
    func passingLanData (name : String)
    
}

class XPSettingLanguageCountryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tableview: UITableView!
    
    var getUrlCountry = URLDirectory.Country()
    
    var getUrlLanguage = URLDirectory.Language()
    
    var getCountryLanguageWebService = XPWebService()
    
    var arrCountry = [[String : Any]]()
    
    var arrLanguage = [[String : Any]]()
    
    var customAlertController : DOAlertController!
    
    var flag : Bool!
    
    var delegate : passData!
    
    var getLanData : String!
    var getConData : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
 
    }
    
    override func awakeFromNib()
    {
        
        getCountryData()
        getLanguageData()
  
        
    }
    
    func getCountryData()
    {
        
        let dicData = ["list" : "country"]
        
        
        getCountryLanguageWebService.getCountryLanguageDataWebService(urlString: getUrlCountry.url(), dicData: dicData as NSDictionary, callback: { (arrData ,error) in
            
             print(arrData)
            
            self.arrCountry = arrData
            
            DispatchQueue.main.async {
                
                
                self.tableview.reloadData()
                
            }
            
        })
        
        
    }
    
    
    func getLanguageData()
    {
        let dicData = ["list" : "language"]
        
        
        getCountryLanguageWebService.getCountryLanguageDataWebService(urlString: getUrlLanguage.url(), dicData: dicData as NSDictionary, callback: { (arrData ,error) in
            
            
            print(arrData)
            
            self.arrLanguage = arrData
            
            DispatchQueue.main.async {
                
                
                self.tableview.reloadData()
                
            }
            
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    if flag == true
    {
        return arrCountry.count
    }
    else
    {
        return arrLanguage.count
    
    }

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! XPSettingLGTableViewCell
       
        
        if ( flag == true)
        {
        let coun = arrCountry[indexPath.row]
            
            
        cell.lblName.text = coun["country_name"] as? String
        
        }
        else
        {
            let lang = arrLanguage[indexPath.row]
            
            cell.lblName.text = lang["name"] as? String
            
            
        }
        
        return cell
        
        
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        
        if flag == true
        {
            
            //dataCell
           
          
           let cell = tableview.cellForRow(at: indexPath) as! XPSettingLGTableViewCell
            
            self.getConData =  cell.lblName.text
            
                // delegate.passingCounData(name: (cell?.textLabel?.text!)!)
            
            cell.accessoryType = .checkmark
            
        }
        else
        {
      
           
            let cell = tableview.cellForRow(at: indexPath) as! XPSettingLGTableViewCell
            
            self.getLanData = cell.lblName.text
            
            cell.accessoryType = .checkmark
            //delegate.passingLanData(name: (cell?.textLabel?.text!)!)
            
            
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        if flag == true
        {
            let cell = tableview.cellForRow(at: indexPath) as! XPSettingLGTableViewCell
            
              self.getConData =  ""
            
            cell.accessoryType = .none
            
        }
        else
        {
            
            let cell = tableview.cellForRow(at: indexPath) as! XPSettingLGTableViewCell
           self.getLanData = ""
            cell.accessoryType = .none
            
        }
 
    }
 
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
     let cell = tableView.dequeueReusableCell(withIdentifier: "donecell") as! XPSettingLanConDoneTableViewCell
  
        cell.btnDismissView.addTarget(self, action: #selector(dismissView(sender:)), for: .touchUpInside)
        
        cell.btnDoneDismiss.addTarget(self, action: #selector(doneView(sender:)), for: .touchUpInside)
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44.00
        
    }
    
    func dismissView(sender : UIButton)
    {
        
        delegate.passingLanData(name: "")
        
        delegate.passingCounData(name: "")
        
        
    }
    
    func doneView(sender : UIButton)
    {
      
        
        if flag == true
        {
            
            
  
            delegate.passingCounData(name: self.getConData!)
            
            
            
        }
        else
        {
       
            delegate.passingLanData(name: self.getLanData!)
            
        }
        
        
     }
    
}
