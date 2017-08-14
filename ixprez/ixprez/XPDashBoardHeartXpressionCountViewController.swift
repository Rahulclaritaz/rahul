//
//  XPDashBoardHeartXpressionCountViewController.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 12/07/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

protocol DashBoardHeartButtonDelegate {
    func dashBoardHeartButtonCount (isTapped : Bool)
}

class XPDashBoardHeartXpressionCountViewController: UIViewController {
    
    var tapGesture = UITapGestureRecognizer ()
  @IBOutlet weak var countExpressionLabel = UILabel ()
    @IBOutlet weak var imageView = UIImageView ()
    var countExpression = Int ()
     var delegate : DashBoardHeartButtonDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTheView(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        self.countExpressionLabel?.text = String(countExpression)
       
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView?.zoomInWithEasing()
        imageView?.zoomOutWithEasing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func removeTheView (sender: AnyObject) {
        print("you click on the xpression heart touch screen")
        delegate?.dashBoardHeartButtonCount(isTapped: false)
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
