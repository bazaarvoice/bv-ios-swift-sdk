//
//
//  BVProductStatisticsFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVProductStatisticsFilter: BVConversationsQueryFilter {
  case contentLocale
  case productId
  
  public var description: String {
    return internalDescription
  }
}

extension BVProductStatisticsFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case .contentLocale:
        return BVConversationsConstants.BVProductStatistics.Keys.contentLocale
      case .productId:
        return BVConversationsConstants.BVProductStatistics.Keys.productId
      }
    }
  }
}
