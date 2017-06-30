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
    
    var checkMarkClean = [Int]()
    
    var activityView = UIActivityIndicatorView()
    
    
    var customAlertController : DOAlertController!
    
    var flag : Bool!
    
    var delegate : passData!
    
    var getLanData : String!
    var getConData : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
  
      activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge , spinColor: .gray, bgColor: .clear, placeInTheCenterOf: self.tableview)
        
        
    }
    
    override func awakeFromNib()
    {
        
        getCountryData()
        getLanguageData()
  
        
    }
    
    func getCountryData()
    {
        
        activityView.startAnimating()
        
        
        let dicData = ["list" : "country"]
        
        
        getCountryLanguageWebService.getCountryLanguageDataWebService(urlString: getUrlCountry.url(), dicData: dicData as NSDictionary, callback: { (arrData ,error) in
            
             print(arrData)
            
            

            if error == nil
            {
            
            self.arrCountry = arrData
            
            
            
            DispatchQueue.main.async {
                
                self.activityView.stopAnimating()
                
                self.tableview.reloadData()
                
            }
            
            }
            else
            {
                DispatchQueue.main.async {
                    
                    self.activityView.startAnimating()
                }
                
            }
            
            
            
        })
        
        
    }
    
    
    func getLanguageData()
    {
        
        activityView.startAnimating()
        
        let dicData = ["list" : "language"]
        
        
        getCountryLanguageWebService.getCountryLanguageDataWebService(urlString: getUrlLanguage.url(), dicData: dicData as NSDictionary, callback: { (arrData ,error) in
            
            
            print(arrData)
            
            
            if error == nil
            {
            self.arrLanguage = arrData
            
            DispatchQueue.main.async {
                
                self.activityView.stopAnimating()
                self.tableview.reloadData()
                
            }
            }
            else
            {
                DispatchQueue.main.async
                    {
                    
                    self.activityView.startAnimating()
                    
                }
                
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
        
            if checkMarkClean.contains(indexPath.row)
            {
                cell.accessoryType = .checkmark
            }
            else
            {
                cell.accessoryType = .none
            }
        }
        else
        {
            let lang = arrLanguage[indexPath.row]
            
            cell.lblName.text = lang["name"] as? String
            
            if checkMarkClean.contains(indexPath.row)
            {
                cell.accessoryType = .checkmark
            }
            else
            {
                cell.accessoryType = .none
            }
            
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
            
            //cell.accessoryType = .checkmark
            
            
            checkMarkClean.removeAll()
            
            checkMarkClean.append(indexPath.row)
            
            
        }
        else
        {
      
           
            let cell = tableview.cellForRow(at: indexPath) as! XPSettingLGTableViewCell
            
            self.getLanData = cell.lblName.text
            
            cell.accessoryType = .checkmark
            //delegate.passingLanData(name: (cell?.textLabel?.text!)!)
            
            checkMarkClean.removeAll()
            
            checkMarkClean.append(indexPath.row)
            
            
        }
        
        tableView.reloadData()
        
        
        
    }
    
  /*
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        if flag == true
        {
            let cell = tableview.cellForRow(at: indexPath) as! XPSettingLGTableViewCell
            
              self.getConData =  ""
            
            cell.accessoryType = .none
            
          //  checkMarkClean.removeAll()
            
         //   checkMarkClean.append(indexPath.row)
            
            
        }
        else
        {
            
            let cell = tableview.cellForRow(at: indexPath) as! XPSettingLGTableViewCell
            self.getLanData = ""
           // cell.accessoryType = .none
            
            checkMarkClean.removeAll()
            
           // checkMarkClean.append(indexPath.row)
            
        }
 
    }
 */
    
    
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
        
        if flag == true
        {
            
            delegate.passingCounData(name: "")
            
            self.dismiss(animated: false, completion: nil)
            
       
        }
        
        else
        {
            delegate.passingLanData(name: "")
            

            self.dismiss(animated: false, completion: nil)
            
        }
    }
    
    func doneView(sender : UIButton)
    {
        self.dismiss(animated: false, completion: nil)

        
        if flag == true
        {
            
        if self.getConData != nil
        {
  
            delegate.passingCounData(name: self.getConData!)
            
        }
            else
        {
            
            delegate.passingCounData(name: "")
            
        }
            
        }
        else
        {
          if self.getLanData != nil
          {
            delegate.passingLanData(name: self.getLanData!)
            }
            
            else
            
          {
            delegate.passingLanData(name: "")
            
            }
        }
        
        
     }
    
}
