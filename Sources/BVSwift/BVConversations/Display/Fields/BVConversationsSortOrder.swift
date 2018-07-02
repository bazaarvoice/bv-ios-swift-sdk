//
//  BVConversationsSortOrder.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents a sorting mechanism that allows for sorting by
/// increasing or decreasing order
public enum BVConversationsSortOrder: BVQuerySortOrder {
  case ascending
  case descending
  
  public var description: String {
    return internalDescription
  }
}

extension BVConversationsSortOrder: BVConversationsQueryValue {
  var internalDescription: String {
    switch self {
    case .ascending:
      return BVConversationsConstants.BVConversationsSortOrder.ascending
    case .descending:
      return BVConversationsConstants.BVConversationsSortOrder.descending
    }
  }
}
