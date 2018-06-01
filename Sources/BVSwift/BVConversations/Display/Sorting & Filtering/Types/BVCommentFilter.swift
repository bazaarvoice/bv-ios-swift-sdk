//
//  BVCommentFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVComment[s]Query.
/// - Note:
/// \
/// Used for conformance with the BVConversationsQueryFilterable protocol.
public enum BVCommentFilter: BVConversationsQueryFilter {
  
  case authorId
  case campaignId
  case categoryAncestorId
  case commentId
  case contentLocale
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

extension BVCommentFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case .authorId:
        return BVConversationsConstants.BVComments.Keys.authorId
      case .campaignId:
        return BVConversationsConstants.BVComments.Keys.campaignId
      case .categoryAncestorId:
        return BVConversationsConstants.BVComments.Keys.categoryAncestorId
      case .commentId:
        return BVConversationsConstants.BVComments.Keys.commentId
      case .contentLocale:
        return BVConversationsConstants.BVComments.Keys.contentLocale
      case .isFeatured:
        return BVConversationsConstants.BVComments.Keys.isFeatured
      case .lastModeratedTime:
        return BVConversationsConstants.BVComments.Keys.lastModeratedTime
      case .lastModificationTime:
        return BVConversationsConstants
          .BVComments.Keys.lastModificationTime
      case .moderatorCode:
        return BVConversationsConstants.BVComments.Keys.moderatorCode
      case .productId:
        return BVConversationsConstants.BVComments.Keys.productId
      case .reviewId:
        return BVConversationsConstants.BVComments.Keys.reviewId
      case .submissionId:
        return BVConversationsConstants.BVComments.Keys.submissionId
      case .submissionTime:
        return BVConversationsConstants.BVComments.Keys.submissionTime
      case .totalFeedbackCount:
        return BVConversationsConstants
          .BVComments.Keys.totalFeedbackCount
      case .totalNegativeFeedbackCount:
        return
          BVConversationsConstants
            .BVComments.Keys.totalNegativeFeedbackCount
      case .totalPositiveFeedbackCount:
        return
          BVConversationsConstants
            .BVComments.Keys.totalPositiveFeedbackCount
      case .userLocation:
        return BVConversationsConstants.BVComments.Keys.userLocation
      }
    }
  }
}

