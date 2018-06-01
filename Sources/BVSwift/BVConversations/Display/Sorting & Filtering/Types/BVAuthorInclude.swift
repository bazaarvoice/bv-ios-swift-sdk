//
//  BVAuthorInclude.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible includable BVQueryable objects with a
/// relation to the target BVAuthor object.
/// - Note:
/// \
/// Used for conformance with the BVConversationsQueryIncludeable protocol.
public enum BVAuthorInclude: BVConversationsQueryInclude {
  
  case answers
  case comments
  case questions
  case reviews
  
  public var description: String {
    return internalDescription
  }
}

extension BVAuthorInclude: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
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
}
