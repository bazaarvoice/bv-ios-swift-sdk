//
//  BVConversationsfiltererator.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents a filtering mechanism that allows for filtering by
/// the usual relational operators that we all know and love.
public enum BVConversationsfiltererator: BVQueryfiltererator {
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

extension BVConversationsfiltererator: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .greaterThan:
      return
        BVConversationsConstants
          .BVConversationsfiltererator.Keys.greaterThan
    case .greaterThanOrEqualTo:
      return
        BVConversationsConstants
          .BVConversationsfiltererator.Keys.greaterThanOrEqualTo
    case .lessThan:
      return
        BVConversationsConstants
          .BVConversationsfiltererator.Keys.lessThan
    case .lessThanOrEqualTo:
      return
        BVConversationsConstants
          .BVConversationsfiltererator.Keys.lessThanOrEqualTo
    case .equalTo:
      return
        BVConversationsConstants
          .BVConversationsfiltererator.Keys.equalTo
    case .notEqualTo:
      return
        BVConversationsConstants
          .BVConversationsfiltererator.Keys.notEqualTo
    }
  }
}
