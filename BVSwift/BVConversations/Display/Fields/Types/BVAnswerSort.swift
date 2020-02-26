//
//  BVAnswerSort.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible sorting comparators to filter on for
/// the BVAnswerQuery
/// - Note:
/// \
/// Used for conformance with the BVQuerySortable protocol.
public enum BVAnswerSort: BVQuerySort {
  
  case answerId
  case authorId
  case campaignId
  case contentLocale
  case hasPhotos
  case isBestAnswer
  case isFeatured
  case lastModeratedTime
  case lastModificationTime
  case productId
  case questionId
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

extension BVAnswerSort: BVConversationsQueryValue {
  var internalDescription: String {
    switch self {
    case .answerId:
      return BVConversationsConstants.BVAnswers.Keys.answerId
    case .authorId:
      return BVConversationsConstants.BVAnswers.Keys.authorId
    case .campaignId:
      return BVConversationsConstants.BVAnswers.Keys.campaignId
    case .contentLocale:
      return BVConversationsConstants.BVAnswers.Keys.contentLocale
    case .hasPhotos:
      return BVConversationsConstants.BVAnswers.Keys.hasPhotos
    case .isBestAnswer:
      return BVConversationsConstants.BVAnswers.Keys.isBestAnswer
    case .isFeatured:
      return BVConversationsConstants.BVAnswers.Keys.isFeatured
    case .lastModeratedTime:
      return BVConversationsConstants.BVAnswers.Keys.lastModeratedTime
    case .lastModificationTime:
      return BVConversationsConstants.BVAnswers.Keys.lastModificationTime
    case .productId:
      return BVConversationsConstants.BVAnswers.Keys.productId
    case .questionId:
      return BVConversationsConstants.BVAnswers.Keys.questionId
    case .submissionId:
      return BVConversationsConstants.BVAnswers.Keys.submissionId
    case .submissionTime:
      return BVConversationsConstants.BVAnswers.Keys.submissionTime
    case .totalFeedbackCount:
      return BVConversationsConstants.BVAnswers.Keys.totalFeedbackCount
    case .totalNegativeFeedbackCount:
      return BVConversationsConstants.BVAnswers.Keys
        .totalNegativeFeedbackCount
    case .totalPositiveFeedbackCount:
      return BVConversationsConstants.BVAnswers.Keys
        .totalPositiveFeedbackCount
    case .userLocation:
      return BVConversationsConstants.BVAnswers.Keys.userLocation
    }
  }
}
