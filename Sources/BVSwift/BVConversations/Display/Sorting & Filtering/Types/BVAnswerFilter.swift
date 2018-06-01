//
//
//  BVAnswerFilter.swift
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVAnswerQuery
/// - Note:
/// \
/// Used for conformance with the BVConversationsQueryFilterable protocol.
public enum BVAnswerFilter: BVConversationsQueryFilter {
  
  case answerId
  case authorId
  case campaignId
  case categoryAncestorId
  case contentLocale
  case hasPhotos
  case isBestAnswer
  case isBrandAnswer
  case isFeatured
  case lastModeratedTime
  case lastModificationTime
  case moderatorCode
  case productId
  case reviewId
  case submissionId
  case submissionTime
  case totalFeedbackCount
  case totalNegativeFeedbackCount
  case totalPositiveFeedbackCount
  case userLocation
  
  public var description: String {
    return internalDescription
  }
}

extension BVAnswerFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case .answerId:
        return BVConversationsConstants.BVAnswers.Keys.answerId
      case .authorId:
        return BVConversationsConstants.BVAnswers.Keys.authorId
      case .campaignId:
        return BVConversationsConstants.BVAnswers.Keys.campaignId
      case .categoryAncestorId:
        return BVConversationsConstants.BVAnswers.Keys.categoryAncestorId
      case .contentLocale:
        return BVConversationsConstants.BVAnswers.Keys.contentLocale
      case .hasPhotos:
        return BVConversationsConstants.BVAnswers.Keys.hasPhotos
      case .isBestAnswer:
        return BVConversationsConstants.BVAnswers.Keys.isBestAnswer
      case .isBrandAnswer:
        return BVConversationsConstants.BVAnswers.Keys.isBrandAnswer
      case .isFeatured:
        return BVConversationsConstants.BVAnswers.Keys.isFeatured
      case .lastModeratedTime:
        return BVConversationsConstants.BVAnswers.Keys.lastModeratedTime
      case .lastModificationTime:
        return BVConversationsConstants
          .BVAnswers.Keys.lastModificationTime
      case .moderatorCode:
        return BVConversationsConstants.BVAnswers.Keys.moderatorCode
      case .productId:
        return BVConversationsConstants.BVAnswers.Keys.productId
      case .reviewId:
        return BVConversationsConstants.BVComments.Keys.reviewId
      case .submissionId:
        return BVConversationsConstants.BVAnswers.Keys.submissionId
      case .submissionTime:
        return BVConversationsConstants.BVAnswers.Keys.submissionTime
      case .totalFeedbackCount:
        return BVConversationsConstants
          .BVAnswers.Keys.totalFeedbackCount
      case .totalNegativeFeedbackCount:
        return
          BVConversationsConstants
            .BVAnswers.Keys.totalNegativeFeedbackCount
      case .totalPositiveFeedbackCount:
        return
          BVConversationsConstants
            .BVAnswers.Keys.totalPositiveFeedbackCount
      case .userLocation:
        return BVConversationsConstants.BVAnswers.Keys.userLocation
      }
    }
  }
}
