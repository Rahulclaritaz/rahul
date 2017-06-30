//
//  XPSettingPhotoViewController.swift
//  ixprez
//
//  Created by Quad on 6/17/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class XPSettingPhotoViewController: UIViewController {

     var setImage = UIImage()
      var titleName = NSString()
    
    @IBOutlet weak var imgMyPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
 
    imgMyPhoto.isUserInteractionEnabled = true

         imgMyPhoto.contentMode = .scaleAspectFill
     imgMyPhoto.image = setImage
        
       
        
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
