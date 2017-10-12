//
//  PrivateAudioVideoTableViewCell.swift
//  ixprez
//
//  Created by Quad on 5/8/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class PrivateAudioVideoTableViewCell: UITableViewCell {

    //Outlet of PrivateAudioVideoTableviewCell
    
    @IBOutlet weak var imgPrivateVideoAudio: UIImageView!
    
    @IBOutlet weak var lblPrivateName: UILabel!
    
    @IBOutlet weak var lblPrivateTitle: UILabel!
    
    @IBOutlet weak var imgPrivateTime: UIImageView!
    
    @IBOutlet weak var imgPrivateCalander: UIImageView!
    
    @IBOutlet weak var lblPrivateTime: UILabel!
    
    @IBOutlet weak var lblPrivateDate: UILabel!
    
    @IBOutlet weak var btnPrivatePlay: UIButton!
    
    
    @IBOutlet weak var imgAV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        imgPrivateVideoAudio.layer.cornerRadius = 5.0
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
