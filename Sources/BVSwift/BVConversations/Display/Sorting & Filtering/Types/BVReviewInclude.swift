//
//  BVReviewInclude.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

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
