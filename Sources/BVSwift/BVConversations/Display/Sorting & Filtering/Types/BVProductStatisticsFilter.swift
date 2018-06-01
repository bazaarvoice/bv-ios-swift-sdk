//
//
//  BVProductStatisticsFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVProductStatisticsQuery
/// - Note:
/// \
/// Used for conformance with the BVConversationsQueryFilterable protocol.
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
