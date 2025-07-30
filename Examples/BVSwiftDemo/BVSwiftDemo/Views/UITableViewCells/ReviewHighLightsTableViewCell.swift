//
//  ReviewHighLightsTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class ReviewHighLightsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 5
    }
    
    func setReviewHighlightsTitle(title: String) {
        self.titleLabel.text = title
    }
    
    func setBgViewBorder(color: UIColor) {
        self.bgView.layer.borderColor = color.cgColor
        self.bgView.layer.borderWidth = 1
    }

}
