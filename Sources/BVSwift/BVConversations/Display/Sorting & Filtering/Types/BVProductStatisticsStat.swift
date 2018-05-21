//
//
//  BVProductStatisticsStat.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public enum BVProductStatisticsStat: BVConversationsQueryStat {
  
  case nativeReviews
  case reviews
  
  public var description: String {
    return internalDescription
  }
}

extension BVProductStatisticsStat: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case .nativeReviews:
        return BVConversationsConstants.BVNativeReviews.key
      case .reviews:
        return BVReview.pluralKey
      }
    }
  }
}
