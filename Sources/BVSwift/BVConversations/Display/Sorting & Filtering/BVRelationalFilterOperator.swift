//
//  BVRelationalFilterOperator.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents a filtering mechanism that allows for filtering by
/// the usual relational operators that we all know and love.
public enum BVRelationalFilterOperator: BVConversationsQueryFilterOperator {
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

extension BVRelationalFilterOperator: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case .greaterThan:
        return
          BVConversationsConstants
            .BVRelationalFilterOperator.Keys.greaterThan
      case .greaterThanOrEqualTo:
        return
          BVConversationsConstants
            .BVRelationalFilterOperator.Keys.greaterThanOrEqualTo
      case .lessThan:
        return
          BVConversationsConstants
            .BVRelationalFilterOperator.Keys.lessThan
      case .lessThanOrEqualTo:
        return
          BVConversationsConstants
            .BVRelationalFilterOperator.Keys.lessThanOrEqualTo
      case .equalTo:
        return
          BVConversationsConstants
            .BVRelationalFilterOperator.Keys.equalTo
      case .notEqualTo:
        return
          BVConversationsConstants
            .BVRelationalFilterOperator.Keys.notEqualTo
      }
    }
  }
}
