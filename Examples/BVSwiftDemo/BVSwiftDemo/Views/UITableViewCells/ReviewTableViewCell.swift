//
//  ReviewTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewText : UILabel!
    @IBOutlet weak var reviewTitle : UILabel!
    @IBOutlet weak var reviewAuthor : UILabel!
    @IBOutlet weak var reviewAuthorLocation : UILabel!
    @IBOutlet weak var reviewStars : HCSStarRatingView!
    @IBOutlet weak var reviewPhoto : UIImageView!
    
    @IBOutlet weak var thumbUpButton: UIButton!
    @IBOutlet weak var thumbDownButton: UIButton!
    
    @IBOutlet weak var commentsButton: UIButton!
    
    @IBOutlet weak var upVoteCountLabel: UILabel!
    @IBOutlet weak var downVoteCountLabel: UILabel!
    @IBOutlet weak var totalCommentsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
