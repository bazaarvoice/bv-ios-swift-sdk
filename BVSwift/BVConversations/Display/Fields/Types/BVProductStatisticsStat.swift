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
/// Used for conformance with the BVQueryStatable protocol.
public enum BVProductStatisticsStat: BVQueryStat {
  
  case nativeReviews
  case reviews
  case answers
  case questions

  
  public static var statPrefix: String {
    return BVConversationsConstants.BVQueryStat.defaultField
  }
  
  public var description: String {
    return internalDescription
  }
}

extension BVProductStatisticsStat: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .nativeReviews:
      return BVConversationsConstants.BVNativeReviews.key
    case .reviews:
      return BVReview.pluralKey
    case .answers:
      return BVAnswer.pluralKey
    case .questions:
      return BVQuestion.pluralKey

    }
  }
}
