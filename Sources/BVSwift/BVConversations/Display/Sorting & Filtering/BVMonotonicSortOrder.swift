//
//  BVMonotonicSortOrder.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public enum BVMonotonicSortOrder: BVConversationsQuerySortOrder {
  case ascending
  case descending
  
  public var description: String {
    get {
      return internalDescription
    }
  }
}

extension BVMonotonicSortOrder: BVConversationsQueryValue {
  var internalDescription: String {
    get {
      switch self {
      case .ascending:
        return BVConversationsConstants.BVMonotonicSortOrder.ascending
      case .descending:
        return BVConversationsConstants.BVMonotonicSortOrder.descending
      }
    }
  }
}
