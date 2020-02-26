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
/// Used for conformance with the BVQueryIncludeable protocol.
public enum BVAuthorInclude: BVQueryInclude {
  
  case answers
  case comments
  case questions
  case reviews
  
  public static var includePrefix: String {
    return BVConversationsConstants.BVQueryInclude.defaultField
  }
  
  public static var includeLimitKey: String {
    return BVConversationsConstants.BVQueryType.Keys.limit
  }
  
  public static var includeLimitSeparator: String {
    return BVConversationsConstants.BVQueryInclude.limitSeparatorField
  }
  
  public var description: String {
    return internalDescription
  }
}

extension BVAuthorInclude: BVConversationsQueryValue {
  internal var internalDescription: String {
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
