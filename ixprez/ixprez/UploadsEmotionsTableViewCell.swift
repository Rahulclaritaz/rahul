//
//  UploadsEmotionsTableViewCell.swift
//  ixprez
//
//  Created by Quad on 5/23/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

class UploadsEmotionsTableViewCell: UITableViewCell
{


    
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var btnEmotion: UIButton!
    
    @IBOutlet weak var lblEmotionEmoji: UILabel!
    @IBOutlet weak var lblEmotionCount: UILabel!
    
    
    @IBOutlet weak var emotionWidth: NSLayoutConstraint!
    override func awakeFromNib()
    {
        
        lblEmotionCount.layer.cornerRadius = lblEmotionCount.frame.size.width/2
        
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    

}
