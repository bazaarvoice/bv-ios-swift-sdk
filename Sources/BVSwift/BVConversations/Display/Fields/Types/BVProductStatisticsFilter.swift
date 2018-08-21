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
/// Used for conformance with the BVQueryFilterable protocol.
public enum BVProductStatisticsFilter: BVQueryFilter {
  
  case contentLocale(Locale)
  case productId(String)
  
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
    case let .contentLocale(filter):
      return filter.identifier
    case let .productId(filter):
      return filter
    }
  }
}

extension BVProductStatisticsFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .contentLocale:
      return BVConversationsConstants.BVProductStatistics.Keys.contentLocale
    case .productId:
      return BVConversationsConstants.BVProductStatistics.Keys.productId
    }
  }
}
