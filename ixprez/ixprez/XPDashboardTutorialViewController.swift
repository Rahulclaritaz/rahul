//
//  XPDashboardTutorialViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/07/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPDashboardTutorialViewController: UIViewController {
    
    var swipeGesture = UISwipeGestureRecognizer()
    var tapGesture =  UITapGestureRecognizer ()

    override func viewDidLoad() {
        super.viewDidLoad()
       self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTutorialView(sender:)))
//        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(removeTutorialView(sender:)))
//        swipeGesture.direction = .down
        self.view.addGestureRecognizer(tapGesture)
//        self.view.addGestureRecognizer(swipeGesture)

        // Do any additional setup after loading the view.
    }
    
    func  removeTutorialView (sender : AnyObject) {
        print("you swipe the view")
        self.view.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.removeFromSuperview()
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
