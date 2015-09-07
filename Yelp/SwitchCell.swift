//
//  SwitchCell.swift
//  Yelp
//
//  Created by Do Ngoc Tan on 9/5/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    
    optional func switchCell(switchCell: SwitchCell, didChangedValue value: Bool)
}

class SwitchCell: UITableViewCell {
    
    
    @IBOutlet weak var lbSwitch: UILabel!
    var country: String = ""
    
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        onSwitch.addTarget(self, action: "switchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func switchValueChanged() {
        country = lbSwitch.text!
        delegate?.switchCell?(self, didChangedValue: onSwitch.on)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
