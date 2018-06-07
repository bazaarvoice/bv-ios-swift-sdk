//
//  MyReviewTableViewCell.swift
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

import UIKit
import BVSwift

class MyReviewTableViewCell: BVTableViewCell<BVReview> {
  @IBOutlet weak var reviewTitle : UILabel!
  @IBOutlet weak var reviewText : UILabel!
  
  override var bvType: BVReview? {
    didSet {
      
      guard let review = bvType else {
        return
      }
      
      var titleString: String = review.title ?? ""
      
      // Get the author and date
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
      let dateString = dateFormatter.string(from: (review.submissionTime)!)
      
      var badgesString: String = "\nBadges: ["
      
      // let's see if this author has any badges
      for badge : BVBadge in (review.badges)! {
        guard let id = badge.badgeId else {
          continue
        }
        badgesString += " \(id) "
      }
      
      badgesString += "]"
      
      titleString = titleString.appending("\nBy \(review.userNickname ?? "no author") on \(dateString)\(badgesString)")
      
      if let contextDataValues = review.contextDataValues {
        // Add any context data values, if present. E.g. Age, Gender, other....
        for contextDataValue in contextDataValues {
          let value = contextDataValue.valueLabel ?? "Value Not defined"
          let label = contextDataValue.dimensionLabel ?? "Label Not defined"
          titleString.append("\n\(label): \(value)")
        }
      }
      
      reviewTitle.text = titleString
      
      // Create a review body some example of data we can pull in.
      var reviewString: String = review.reviewText ?? ""
      
      reviewString.append("\n")
      
      if let isRecommended = review.isRecommended {
        reviewString.append("\nIs Recommended?  \(isRecommended)")
      }
      
      if let isSyndicated = review.isSyndicated {
        reviewString.append("\nIs Syndicated?  \(isSyndicated)")
        if isSyndicated,
          let syndicationSource = review.syndicationSource?.name {
          reviewString.append("\nSyndication Source: \(syndicationSource)")
        }
      }
      
      if let totalPositiveFeedbackCount = review.totalPositiveFeedbackCount {
        reviewString.append("\nHelpful Count: \(totalPositiveFeedbackCount)")
      }
      
      if let totalNegativeFeedbackCount = review.totalNegativeFeedbackCount {
        reviewString.append("\nNot Helpful Count: \(totalNegativeFeedbackCount)")
      }
      
      // See if there are context data values
      var secondaryRatingsText: String = "\nSecondary Ratings: ["
      
      // Check and see if this reviewer supplied any of the secondary ratings
      
      if let secondaryRatings = review.secondaryRatings {
        for rating : BVSecondaryRating in secondaryRatings {
          let value: String = String(rating.value ?? -1)
          let label: String = rating.label ?? "Label Not defined"
          secondaryRatingsText += " \(label)(\(value)) "
        }
      }
      
      secondaryRatingsText += "]"
      
      reviewString.append(secondaryRatingsText)
      
      // check for comments
      if let comments = review.comments {
        let commentsText = "\nNum Comments: [\(comments.count)]"
        reviewString.append(commentsText)
      }
      
      reviewText.text = reviewString
    }
  }
}
