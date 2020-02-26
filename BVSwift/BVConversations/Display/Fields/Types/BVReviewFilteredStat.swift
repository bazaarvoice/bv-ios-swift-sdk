//
//
//  BVReviewFilteredStat.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible representatble statistics for
/// BVQueryable objects with a relation to the target BVReview object.
/// - Note:
/// \
/// Used for conformance with the BVQueryStatable protocol.
public enum BVReviewFilteredStat: BVQueryFilteredStat {
  
  case answers
  case questions
  case reviews
  
  public static var statPrefix: String {
    return BVConversationsConstants.BVQueryFilteredStat.defaultField
  }
  
  public var description: String {
    return internalDescription
  }
}

extension BVReviewFilteredStat: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .answers:
      return BVAnswer.pluralKey
    case .questions:
      return BVQuestion.pluralKey
    case .reviews:
      return BVReview.pluralKey
    }
  }
}
