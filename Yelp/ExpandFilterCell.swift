//
//  ExpandFilterCell.swift
//  Yelp
//
//  Created by Do Ngoc Tan on 9/7/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol ExpandFilterCellDelegate {
    
    optional func expandFilterCell(expandFilterCell: ExpandFilterCell, didChangedValue value: Bool)
}

class ExpandFilterCell: UITableViewCell {

    
    @IBOutlet weak var lbExpandGuide: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
