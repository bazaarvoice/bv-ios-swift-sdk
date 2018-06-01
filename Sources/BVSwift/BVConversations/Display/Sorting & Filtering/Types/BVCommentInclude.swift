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
/// Used for conformance with the BVConversationsQueryIncludeable protocol.
public enum BVCommentInclude: BVConversationsQueryInclude {
  
  case authors
  case products
  case reviews
  
  public var description: String {
    return internalDescription
  }
}

extension BVCommentInclude: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
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
}
