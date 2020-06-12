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
    
    @IBOutlet weak var view_CellBackground: UIView!
    @IBOutlet weak var lbl_Title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setReviewHighlightsTitle(title: String) {
        self.lbl_Title.text = title.capitalized
    }

}
