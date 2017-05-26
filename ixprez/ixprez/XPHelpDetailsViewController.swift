//
//  XPHelpDetailsViewController.swift
//  ixprez
//
//  Created by Quad on 5/25/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPHelpDetailsViewController: UIViewController {

    
    @IBOutlet weak var helpWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let url = URL(string: "http://claritaz.com/")
        
        let request = URLRequest(url: url!)
        
        
    helpWebView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
