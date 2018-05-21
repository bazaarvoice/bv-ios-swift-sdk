//
//  BVAuthorSort.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public enum BVAuthorSort: BVConversationsQuerySort {
  
  case answers(BVAnswerSort)
  case comments(BVCommentSort)
  case questions(BVQuestionSort)
  case reviews(BVReviewSort)
  
  public var description: String {
    get {
      return internalDescription
    }
  }
}

extension BVAuthorSort: BVConversationsQueryValue {
  var internalDescription: String {
    get {
      switch self {
      case .answers(_):
        return BVAnswer.pluralKey
      case .comments(_):
        return BVComment.pluralKey
      case .questions(_):
        return BVQuestion.pluralKey
      case .reviews(_):
        return BVReview.pluralKey
      }
    }
  }
}
