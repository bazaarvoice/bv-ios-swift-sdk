//
//
//  BVRelavancySortOrder.swift
//  BVSwift
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

import Foundation
/// An enum that represents a sorting mechanism that allows for relevancy sort type by
public enum BVRelencySortType: BVQuerySortOrder {
  case a2
  
  public var description: String {
    return internalDescription
  }
}

extension BVRelencySortType: BVConversationsQueryValue {
  var internalDescription: String {
    switch self {
    case .a2:
      return BVConversationsConstants.BVConversationsSortOrder.orderTwo
    }
  }
}

