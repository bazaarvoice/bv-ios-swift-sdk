//
//  BVProductSort.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible sorting comparators to filter on for
/// the BVProduct[s]Query
/// - Note:
/// \
/// Used for conformance with the BVConversationsQuerySortable protocol.
public enum BVProductSort: BVConversationsQuerySort {
  
  case answers(BVAnswerSort)
  case authors(BVAuthorSort)
  case averageOverallRating
  case categoryId
  case comments(BVCommentSort)
  case helpfulness
  case isActive
  case isDisabled
  case lastAnswerTime
  case lastQuestionTime
  case lastReviewTime
  case lastStoryTime
  case name
  case productId
  case questions(BVQuestionSort)
  case rating
  case ratingsOnlyReviewCount
  case reviews(BVReviewSort)
  case totalAnswerCount
  case totalQuestionCount
  case totalReviewCount
  case totalStoryCount
  
  public var description: String {
    return internalDescription
  }
}

extension BVProductSort: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case .answers(_):
        return BVAnswer.pluralKey
      case .authors(_):
        return BVAuthor.pluralKey
      case .averageOverallRating:
        return BVConversationsConstants.BVProducts.Keys.averageOverallRating
      case .categoryId:
        return BVConversationsConstants.BVProducts.Keys.categoryId
      case .comments(_):
        return BVComment.pluralKey
      case .helpfulness:
        return BVConversationsConstants.BVProducts.Keys.helpfulness
      case .isActive:
        return BVConversationsConstants.BVProducts.Keys.isActive
      case .isDisabled:
        return BVConversationsConstants.BVProducts.Keys.isDisabled
      case .lastAnswerTime:
        return BVConversationsConstants.BVProducts.Keys.lastAnswerTime
      case .lastQuestionTime:
        return BVConversationsConstants.BVProducts.Keys.lastQuestionTime
      case .lastReviewTime:
        return BVConversationsConstants.BVProducts.Keys.lastReviewTime
      case .lastStoryTime:
        return BVConversationsConstants.BVProducts.Keys.lastStoryTime
      case .name:
        return BVConversationsConstants.BVProducts.Keys.name
      case .productId:
        return BVConversationsConstants.BVProducts.Keys.productId
      case .questions(_):
        return BVQuestion.pluralKey
      case .rating:
        return BVConversationsConstants.BVProducts.Keys.rating
      case .ratingsOnlyReviewCount:
        return BVConversationsConstants.BVProducts.Keys.ratingsOnlyReviewCount
      case .reviews(_):
        return BVReview.pluralKey
      case .totalAnswerCount:
        return BVConversationsConstants.BVProducts.Keys.totalAnswerCount
      case .totalQuestionCount:
        return BVConversationsConstants.BVProducts.Keys.totalQuestionCount
      case .totalReviewCount:
        return BVConversationsConstants.BVProducts.Keys.totalReviewCount
      case .totalStoryCount:
        return BVConversationsConstants.BVProducts.Keys.totalStoryCount
      }
    }
  }
}
