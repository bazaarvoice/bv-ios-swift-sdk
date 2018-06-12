//
//
//  BVProductStat.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible representatble statistics for
/// BVQueryable objects with a relation to the target BVProduct object.
/// - Note:
/// \
/// Used for conformance with the BVConversationsQueryStatable protocol.
public enum BVProductStat: BVConversationsQueryStat {
  
  case answers
  case questions
  case reviews
  
  public var description: String {
    return internalDescription
  }
}

extension BVProductStat: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
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
}
