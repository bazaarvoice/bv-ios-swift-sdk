//
//  BVReviewSort.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible sorting comparators to filter on for
/// the BVReviewQuery
/// - Note:
/// \
/// Used for conformance with the BVConversationsQuerySortable protocol.
public enum BVReviewSort: BVConversationsQuerySort {
  
  case authorId
  case campaignId
  case categoryAncestorId
  case contentLocale
  case hasComments
  case hasPhotos
  case hasTags
  case hasVideos
  case helpfulness
  case isFeatured
  case isRatingsOnly
  case isRecommended
  case isSubjectActive
  case isSyndicated
  case lastModeratedTime
  case lastModificationTime
  case productId
  case rating
  case reviewId
  case submissionId
  case submissionTime
  case totalCommentCount
  case totalFeedbackCount
  case totalNegativeFeedbackCount
  case totalPositiveFeedbackCount
  case userLocation
  
  public var description: String {
    get {
      return internalDescription
    }
  }
}

extension BVReviewSort: BVConversationsQueryValue {
  var internalDescription: String {
    get {
      switch self {
      case .authorId:
        return BVConversationsConstants.BVReviews.Keys.authorId
      case .campaignId:
        return BVConversationsConstants.BVReviews.Keys.campaignId
      case .categoryAncestorId:
        return BVConversationsConstants.BVReviews.Keys.categoryAncestorId
      case .contentLocale:
        return BVConversationsConstants.BVReviews.Keys.contentLocale
      case .hasComments:
        return BVConversationsConstants.BVReviews.Keys.hasComments
      case .hasPhotos:
        return BVConversationsConstants.BVReviews.Keys.hasPhotos
      case .hasTags:
        return BVConversationsConstants.BVReviews.Keys.hasTags
      case .hasVideos:
        return BVConversationsConstants.BVReviews.Keys.hasVideos
      case .helpfulness:
        return BVConversationsConstants.BVReviews.Keys.helpfulness
      case .isFeatured:
        return BVConversationsConstants.BVReviews.Keys.isFeatured
      case .isRatingsOnly:
        return BVConversationsConstants.BVReviews.Keys.isRatingsOnly
      case .isRecommended:
        return BVConversationsConstants.BVReviews.Keys.isRecommended
      case .isSubjectActive:
        return BVConversationsConstants.BVReviews.Keys.isSubjectActive
      case .isSyndicated:
        return BVConversationsConstants.BVReviews.Keys.isSyndicated
      case .lastModeratedTime:
        return BVConversationsConstants.BVReviews.Keys.lastModeratedTime
      case .lastModificationTime:
        return BVConversationsConstants.BVReviews.Keys.lastModificationTime
      case .productId:
        return BVConversationsConstants.BVReviews.Keys.productId
      case .rating:
        return BVConversationsConstants.BVReviews.Keys.rating
      case .reviewId:
        return BVConversationsConstants.BVReviews.Keys.reviewId
      case .submissionId:
        return BVConversationsConstants.BVReviews.Keys.submissionId
      case .submissionTime:
        return BVConversationsConstants.BVReviews.Keys.submissionTime
      case .totalCommentCount:
        return BVConversationsConstants.BVReviews.Keys.totalCommentCount
      case .totalFeedbackCount:
        return BVConversationsConstants.BVReviews.Keys.totalFeedbackCount
      case .totalNegativeFeedbackCount:
        return BVConversationsConstants.BVReviews.Keys
          .totalNegativeFeedbackCount
      case .totalPositiveFeedbackCount:
        return BVConversationsConstants.BVReviews.Keys
          .totalPositiveFeedbackCount
      case .userLocation:
        return BVConversationsConstants.BVReviews.Keys.userLocation
      }
    }
  }
}
