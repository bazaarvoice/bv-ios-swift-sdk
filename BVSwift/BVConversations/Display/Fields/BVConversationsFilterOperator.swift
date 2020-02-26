//
//  BVConversationsFilterOperator.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents a filtering mechanism that allows for filtering by
/// the usual relational operators that we all know and love.
public enum BVConversationsFilterOperator: BVQueryFilterOperator {
  case greaterThan
  case greaterThanOrEqualTo
  case lessThan
  case lessThanOrEqualTo
  case equalTo
  case notEqualTo
  
  public var description: String {
    return internalDescription
  }
}

extension BVConversationsFilterOperator: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .greaterThan:
      return
        BVConversationsConstants
          .BVConversationsFilterOperator.Keys.greaterThan
    case .greaterThanOrEqualTo:
      return
        BVConversationsConstants
          .BVConversationsFilterOperator.Keys.greaterThanOrEqualTo
    case .lessThan:
      return
        BVConversationsConstants
          .BVConversationsFilterOperator.Keys.lessThan
    case .lessThanOrEqualTo:
      return
        BVConversationsConstants
          .BVConversationsFilterOperator.Keys.lessThanOrEqualTo
    case .equalTo:
      return
        BVConversationsConstants
          .BVConversationsFilterOperator.Keys.equalTo
    case .notEqualTo:
      return
        BVConversationsConstants
          .BVConversationsFilterOperator.Keys.notEqualTo
    }
  }
}
