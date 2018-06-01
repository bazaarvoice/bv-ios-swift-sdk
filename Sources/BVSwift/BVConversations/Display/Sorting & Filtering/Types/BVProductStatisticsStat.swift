//
//
//  BVProductStatisticsStat.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible representatble statistics for
/// BVQueryable objects with a relation to the target BVProductStatistics
/// object.
/// - Note:
/// \
/// Used for conformance with the BVConversationsQueryStatable protocol.
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
