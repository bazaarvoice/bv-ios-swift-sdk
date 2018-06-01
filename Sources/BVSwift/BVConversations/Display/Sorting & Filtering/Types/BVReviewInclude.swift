//
//  BVReviewInclude.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible includable BVQueryable objects with a
/// relation to the target BVQuestion object.
/// - Note:
/// \
/// Used for conformance with the BVConversationsQueryIncludeable protocol.
public enum BVReviewInclude: BVConversationsQueryInclude {
  
  case comments
  case products
  
  public var description: String {
    return internalDescription
  }
}

extension BVReviewInclude: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case .comments:
        return BVComment.pluralKey
      case .products:
        return BVProduct.pluralKey
      }
    }
  }
}
