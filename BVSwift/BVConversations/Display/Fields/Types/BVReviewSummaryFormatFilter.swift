//
//
//  BVReviewSummaryFormatFilter.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVComment[s]Query.
/// - Note:
/// \
/// Used for conformance with the BVQueryFilterable protocol.
///
internal struct BVReviewSummaryFormatStats: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
        return BVConversationsConstants.BVReviewSummary.Keys.formatType
    }
    
    var representedValue: CustomStringConvertible {
        return value
    }
    
    var description: String {
        return internalDescription
    }
    
    init(_ _value: BVReviewSummaryFormatFilter) {
        value = "\(_value.internalDescription)"
    }
}

public enum BVReviewSummaryFormatFilter: BVQueryFilter {
  
  case bullet
  case paragraph
  
  public static var filterPrefix: String {
    return BVConversationsConstants.BVQueryFilter.defaultField
  }
  
  public static var filterTypeSeparator: String {
    return BVConversationsConstants.BVQueryFilter.typeSeparatorField
  }
  
  public static var filterValueSeparator: String {
    return BVConversationsConstants.BVQueryFilter.valueSeparatorField
  }
  
  public var description: String {
    return internalDescription
  }
  
  public var representedValue: CustomStringConvertible {
    switch self {
    case .bullet:
        return BVConversationsConstants.BVReviewSummary.Keys.bullet
    case .paragraph:
        return BVConversationsConstants.BVReviewSummary.Keys.paragraph
    }
  }
}

extension BVReviewSummaryFormatFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .bullet:
      return BVConversationsConstants.BVReviewSummary.Keys.bullet
    case .paragraph:
      return BVConversationsConstants.BVReviewSummary.Keys.paragraph
    }
  }
}
