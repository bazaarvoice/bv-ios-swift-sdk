//
//  ReviewTableViewCell.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 09/06/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift
import HCSStarRatingView
import FontAwesomeKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var reviewText : UILabel!
    @IBOutlet weak var reviewTitle : UILabel!
    @IBOutlet weak var lastModificationTimeLabel : UILabel!
    @IBOutlet weak var reviewAuthorLocation : UILabel!
    @IBOutlet weak var reviewStars : HCSStarRatingView!
    @IBOutlet weak var reviewPhoto : UIImageView!
    @IBOutlet weak var view_CellBackground: CardView!
    
    @IBOutlet weak var thumbUpButton: UIButton!
    @IBOutlet weak var thumbDownButton: UIButton!
    
    @IBOutlet weak var commentsButton: UIButton!
    
    @IBOutlet weak var upVoteCountLabel: UILabel!
    @IBOutlet weak var downVoteCountLabel: UILabel!
    @IBOutlet weak var totalCommentsLabel: UILabel!
    
    var onAuthorNickNameTapped : ((_ authorId : String) -> Void)?
    
    var review: BVReview?
    
    var totalCommentCount = 0
    var totalUpVoteCount = 0
    var totalDownVoteCount = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let commentsIconColor = self.totalCommentCount > 0 ? UIColor.bazaarvoiceTeal.withAlphaComponent(1) :UIColor.lightGray.withAlphaComponent(0.5)
        
        let thumbDownColor = UIColor.lightGray.withAlphaComponent(0.5)
        let thumbUpColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        self.thumbUpButton.setBackgroundImage(getIconImage(FAKFontAwesome.thumbsUpIcon(withSize:), color: thumbUpColor), for: .normal)
        self.thumbDownButton.setBackgroundImage(getIconImage(FAKFontAwesome.thumbsDownIcon(withSize:), color: thumbDownColor), for: .normal)
        self.commentsButton.setBackgroundImage(getIconImage(FAKFontAwesome.commentIcon(withSize:), color: commentsIconColor), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func tappedAuthor(_ sender:UITapGestureRecognizer) {
        
        guard let authorId = self.review?.authorId else { return }
        
        guard let onAuthorNameTapped = self.onAuthorNickNameTapped else { return }
        
        onAuthorNameTapped(authorId)
        
    }
    
    private func getIconImage(_ icon : ((_ size: CGFloat) -> FAKFontAwesome?), color: UIColor) -> UIImage {
        
        let size = CGFloat(22)
        
        let newIcon = icon(size)
        newIcon?.addAttribute(
            NSAttributedString.Key.foregroundColor.rawValue,
            value: color
        )
        
        return newIcon!.image(with: CGSize(width: size, height: size))
        
    }
    
    func setReview(review: BVReview) {
        
        self.review = review
        
        if let imageUrl = review.photos?.first?.photoSizes?.first?.url?.value {
            
            self.reviewPhoto.sd_setImage(with: imageUrl) { [weak self] (image, error, cacheType, url) in
                
                guard let strongSelf = self else { return }
                
                guard let _ = error else { return }
                strongSelf.reviewPhoto.image = FAKFontAwesome.photoIcon(withSize: 80.0)?
                    .image(with: CGSize(width: strongSelf.reviewPhoto.frame.size.width,
                                        height: strongSelf.reviewPhoto.frame.size.height))
                strongSelf.reviewPhoto.image?.withTintColor(UIColor.bazaarvoiceNavy)
            }
        }
        
        self.reviewText.text = review.reviewText
        self.reviewTitle.text = review.title
        self.reviewAuthorLocation.text = review.userLocation
        self.totalCommentsLabel.text = "\(review.comments?.count ?? 0)"
        self.reviewStars.value = CGFloat(review.rating ?? 0)
        self.totalCommentsLabel.text = "\(review.totalCommentCount ?? 0)"
        self.upVoteCountLabel.text = "\(review.totalPositiveFeedbackCount ?? 0)"
        self.downVoteCountLabel.text = "\(review.totalNegativeFeedbackCount ?? 0)"
        
        
        if let submissionTime = review.submissionTime, let nickname = review.userNickname {
            
            self.lastModificationTimeLabel.linkAuthorNameLabel(fullText: "\(dateTimeAgo(submissionTime)) by " + nickname,
                                                               author: nickname,
                                                               target: self,
                                                               selector: #selector(AnswerTableViewCell.tappedAuthor(_:)))
        }
    }
}
