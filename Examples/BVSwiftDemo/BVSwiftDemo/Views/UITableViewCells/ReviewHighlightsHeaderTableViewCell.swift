//
//  ReviewHighlightsHeaderTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class ReviewHighlightsHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view_CellBackground: UIView!
    @IBOutlet weak var view_Separator: UIView!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Count: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lbl_Count.text = "0"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setReviewHighlightsData(title: String, count: Int) {
        self.lbl_Title.text = title
        self.lbl_Count.text = "\(count)"
    }

}
