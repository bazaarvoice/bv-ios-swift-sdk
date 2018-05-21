//
//  BVCommentInclude.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

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
