//
//  ReviewsSectionsToogleTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Rahul on 23/07/25.
//  Copyright © 2025 Bazaarvoice. All rights reserved.
//

import UIKit

protocol ReviewsSectionsToogleTableViewCellDelegate: AnyObject {
    func didToggleReviewHighlights(isOn: Bool)
    func didSortReviews()
}

class ReviewsSectionsToogleTableViewCell: UITableViewCell {

    @IBOutlet weak var toggleReviewHighlightsButton: UIButton!
    @IBOutlet weak var sortReviewsButton: UIButton!

    var delegate: ReviewsSectionsToogleTableViewCellDelegate?
    var isOn = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setButtonsTitle(sortButtonTitle: String) {
        toggleReviewHighlightsButton.setTitle(isOn ? "Hide Review Highlights" : "Show Review Highlights", for: .normal)
        toggleReviewHighlightsButton.setImage(UIImage(systemName: isOn ? "arrowtriangle.up" : "arrowtriangle.down"), for: .normal)
        sortReviewsButton.setTitle(sortButtonTitle, for: .normal)
    }

    @IBAction func toggleReviewHighlightsAction(_ sender: Any) {
        isOn.toggle()
        delegate?.didToggleReviewHighlights(isOn: isOn)
    }
    
    @IBAction func sortReviewsAction(_ sender: Any) {
        delegate?.didSortReviews()
    }
    
}
