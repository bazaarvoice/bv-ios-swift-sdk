//
//  ReviewHighlightsHeaderTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

// This cell is used to display the header for review highlights section in the table view.

class ReviewHighlightsHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setReviewHighlightsData(title: String, image: String) {
        self.titleLabel.text = title
        if image.isEmpty {
            self.iconImageView.isHidden = image.isEmpty
        } else {
            self.iconImageView.isHidden = false
            self.iconImageView.image = UIImage(systemName: image)
        }
    }

}
