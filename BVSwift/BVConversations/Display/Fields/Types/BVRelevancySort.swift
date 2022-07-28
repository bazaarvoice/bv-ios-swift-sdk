//
//
//  BVRelavancySort.swift
//  BVSwift
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible relevancy sorting comparators to filter on for
/// the BVReviewQuery
/// - Note:
/// \
/// Used for conformance with the BVQuerySortable protocol.
public enum BVRelevancySort: BVQuerySort {
  
  case relevancy
  
  public static var sortPrefix: String {
    return BVConversationsConstants.BVQuerySort.defaultField
  }
  
  public static var sortTypeSeparator: String {
    return BVConversationsConstants.BVQuerySort.typeSeparatorField
  }
  
  public static var sortValueSeparator: String {
    return BVConversationsConstants.BVQuerySort.valueSeparatorField
  }
  
  public var description: String {
    return internalDescription
  }
}

extension BVRelevancySort: BVConversationsQueryValue {
  var internalDescription: String {
    switch self {
    case .relevancy:
      return BVConversationsConstants.BVReviews.Keys.relavancy
    }
  }
}

