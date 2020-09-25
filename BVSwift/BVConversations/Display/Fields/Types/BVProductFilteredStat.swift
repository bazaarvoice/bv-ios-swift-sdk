//
//
//  BVProductFilteredStat.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible representatble statistics for
/// BVQueryable objects with a relation to the target BVProduct object.
/// - Note:
/// \
/// Used for conformance with the BVQueryStatable protocol.
public enum BVProductFilteredStat: BVQueryFilteredStat {
  
  case reviews
  
  public static var statPrefix: String {
    return BVConversationsConstants.BVQueryFilteredStat.defaultField
  }
  
  public var description: String {
    return internalDescription
  }
}

extension BVProductFilteredStat: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .reviews:
      return BVReview.pluralKey
    }
  }
}
