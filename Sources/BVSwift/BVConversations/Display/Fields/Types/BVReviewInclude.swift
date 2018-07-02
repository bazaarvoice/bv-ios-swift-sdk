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
/// Used for conformance with the BVQueryIncludeable protocol.
public enum BVReviewInclude: BVQueryInclude {
  
  case comments
  case products
  
  public static var includePrefix: String {
    return BVConversationsConstants.BVQueryInclude.defaultField
  }
  
  public static var includeLimitSeparator: String {
    return BVConversationsConstants.BVQueryInclude.limitSeparatorField
  }
  
  public var description: String {
    return internalDescription
  }
}

extension BVReviewInclude: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .comments:
      return BVComment.pluralKey
    case .products:
      return BVProduct.pluralKey
    }
  }
}
