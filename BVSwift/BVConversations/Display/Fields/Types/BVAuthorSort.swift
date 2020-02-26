//
//  BVAuthorSort.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible sorting comparators to filter on for
/// the BVAuthorQuery
/// - Note:
/// \
/// Used for conformance with the BVQuerySortable protocol.
public enum BVAuthorSort: BVQuerySort {
  
  case answers(BVAnswerSort)
  case comments(BVCommentSort)
  case questions(BVQuestionSort)
  case reviews(BVReviewSort)
  
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

extension BVAuthorSort: BVConversationsQueryValue {
  var internalDescription: String {
    switch self {
    case .answers:
      return BVAnswer.pluralKey
    case .comments:
      return BVComment.pluralKey
    case .questions:
      return BVQuestion.pluralKey
    case .reviews:
      return BVReview.pluralKey
    }
  }
}
