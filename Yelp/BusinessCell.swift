//
//  BusinessCell.swift
//  Yelp
//
//  Created by Do Ngoc Tan on 9/2/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    
    @IBOutlet weak var imgThumbnail: UIImageView!
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbDistance: UILabel!
    
    @IBOutlet weak var lbReviewCount: UILabel!
    
    @IBOutlet weak var lbAddress: UILabel!
    
    @IBOutlet weak var imgRating: UIImageView!

    @IBOutlet weak var lbcategory: UILabel!
    
    var business: Business! {
        didSet {
            lbName.text = business.name
            imgThumbnail.setImageWithURL(business.imageURL)
            lbcategory.text = business.categories
            lbAddress.text = business.address
            lbReviewCount.text = "\(business.reviewCount!) reviews"
            imgRating.setImageWithURL(business.ratingImageURL)
            lbDistance.text = business.distance
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgThumbnail.layer.cornerRadius = 3
        imgThumbnail.clipsToBounds = true
        lbName.preferredMaxLayoutWidth = lbName.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // lbName.preferredMaxLayoutWidth = lbName.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
