//
//  XPDashboardHeaderTableViewCell.swift
//  ixprez
//
//  Created by Claritaz Techlabs on 06/06/17.
//  Copyright © 2017 Claritaz Techlabs. All rights reserved.
//

import UIKit

protocol treadingButtonDelegate {
    func  buttonSelectedState (cell : XPDashboardHeaderTableViewCell)
}


class XPDashboardHeaderTableViewCell: UITableViewCell {

    
    @IBOutlet weak var treadingButton = UIButton ()
    @IBOutlet weak var recentButton = UIButton ()
    @IBOutlet weak var treadingViewLine = UIView ()
    @IBOutlet weak var recentViewLine = UIView ()
    var delegate : treadingButtonDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func treadingButton (sender : Any) {
        treadingButton?.isSelected = true
        recentButton?.isSelected = false
        delegate?.buttonSelectedState(cell: self)
    }
    
    @IBAction func recentButton (sender : Any) {
        recentButton?.isSelected = true
        treadingButton?.isSelected = false
        delegate?.buttonSelectedState(cell: self)
    }

}
