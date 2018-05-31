//
//
//  BVProductStatisticsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Public class for handling BVProductStatistics Queries
/// - Note:
/// \
/// For more information please see the [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/statistics/statistics-display)
public class
BVProductStatisticsQuery: BVConversationsQuery<BVProductStatistics> {
  
  /// The Product ids for the query
  public let productIds: [String]?
  
  /// The initializer for BVProductStatisticsQuery
  /// - Parameters:
  ///   - productIds: The Product ids for the query
  public init(productIds: [String]) {
    self.productIds = productIds
    
    super.init(BVProductStatistics.self)
    
    let productIdFilter: BVConversationsQueryParameter =
      .filter(
        BVProductStatisticsFilter.productId,
        BVRelationalFilterOperator.equalTo,
        productIds,
        nil)
    
    add(parameter: productIdFilter)
  }
}

// MARK: - BVProductStatisticsQuery: BVConversationsQueryFilterable
extension BVProductStatisticsQuery: BVConversationsQueryFilterable {
  public typealias Filter = BVProductStatisticsFilter
  public typealias Operator = BVRelationalFilterOperator
  
  @discardableResult public func filter(
    _ filter: Filter,
    op: Operator,
    value: CustomStringConvertible) -> Self {
    return self.filter(filter, op: op, values: [value])
  }
  
  @discardableResult public func filter(
    _ filter: Filter,
    op: Operator,
    values: [CustomStringConvertible]) -> Self {
    let internalFilter:BVConversationsQueryParameter =
      .filter(filter, op, values, nil)
    add(parameter: internalFilter)
    return self
  }
}

// MARK: - BVProductStatisticsQuery: BVConversationsQueryStatable
extension BVProductStatisticsQuery: BVConversationsQueryStatable {
  public typealias Stat = BVProductStatisticsStat
  
  @discardableResult public func stats(
    _ for: Stat) -> Self {
    let internalStat:BVConversationsQueryParameter = .stats(`for`, nil)
    add(parameter: internalStat, coalesce: true)
    return self
  }
}
