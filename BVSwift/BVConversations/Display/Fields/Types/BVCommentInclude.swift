//
//  BVCommentInclude.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible includable BVQueryable objects with a
/// relation to the target BVComment object.
/// - Note:
/// \
/// Used for conformance with the BVQueryIncludeable protocol.
public enum BVCommentInclude: BVQueryInclude {
  
  case authors
  case products
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

extension BVCommentInclude: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .authors:
      return BVAuthor.pluralKey
    case .products:
      return BVProduct.pluralKey
    case .reviews:
      return BVReview.pluralKey
    }
  }
}
