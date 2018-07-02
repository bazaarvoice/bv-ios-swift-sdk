//
//  BVCommentSort.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible sorting comparators to filter on for
/// the BVComment[s]Query
/// - Note:
/// \
/// Used for conformance with the BVQuerySortable protocol.
public enum BVCommentSort: BVQuerySort {
  
  case authorId
  case campaignId
  case commentId
  case contentLocale
  case isFeatured
  case lastModeratedTime
  case lastModificationTime
  case productId
  case reviewId
  case submissionId
  case submissionTime
  case totalFeedbackCount
  case totalNegativeFeedbackCount
  case totalPositiveFeedbackCount
  case userLocation
  
  public static var sortPrefix: String {
    return BVConversationsConstants.BVQuerySort.defaultField
  }
  
  public static var sortTypeSeparator: String {
    return BVConversationsConstants.BVQuerySort.typeSeparatorField
  }
  
  public static var sortValueSeparator: String {
    return BVConversationsConstants.BVQuerySort.valueSeparatorField
  }
  
  public var description: String {
    return internalDescription
  }
}

extension BVCommentSort: BVConversationsQueryValue {
  var internalDescription: String {
    switch self {
    case .authorId:
      return BVConversationsConstants.BVComments.Keys.authorId
    case .campaignId:
      return BVConversationsConstants.BVComments.Keys.campaignId
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
