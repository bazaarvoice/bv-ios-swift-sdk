//
//
//  BVCurationsFeedItemFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation
import CoreLocation

public enum BVCurationsFeedItemFilter: BVCurationsQueryFilter {
  
  case after(Date)
  case before(Date)
  case display(String)
  case includeProductData(Bool)
  case limit(UInt16)
  case productId(BVIdentifier)
  
  public var description: String {
    return internalDescription
  }
  
  public var representedValue: CustomStringConvertible {
    get {
      switch self {
      case let .after(filter):
        return filter.timeIntervalSince1970
      case let .before(filter):
        return filter.timeIntervalSince1970
      case let .display(filter):
        return filter
      case let .includeProductData(filter):
        return filter
      case let .limit(filter):
        return filter
      case let .productId(filter):
        return filter
      }
    }
  }
}

extension BVCurationsFeedItemFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case .after:
        return BVCurationsConstants.BVCurationsFeedItem.Keys.after
      case .before:
        return BVCurationsConstants.BVCurationsFeedItem.Keys.before
      case .display:
        return BVCurationsConstants.BVCurationsFeedItem.Keys.display
      case .includeProductData:
        return BVCurationsConstants.BVCurationsFeedItem.Keys.includeProductData
      case .limit:
        return BVCurationsConstants.BVCurationsFeedItem.Keys.limit
      case .productId(_):
        return BVCurationsConstants.BVCurationsFeedItem.Keys.productId
      }
    }
  }
}
