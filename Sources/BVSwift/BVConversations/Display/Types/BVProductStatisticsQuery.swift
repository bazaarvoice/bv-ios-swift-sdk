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
    
    for id in productIds {
      let productIdFilter: BVConversationsQueryParameter =
        .filter(
          BVProductStatisticsFilter.productId(id),
          BVRelationalFilterOperator.equalTo,
          nil)
      
      add(productIdFilter)
    }
  }
}

// MARK: - BVProductStatisticsQuery: BVConversationsQueryFilterable
extension BVProductStatisticsQuery: BVConversationsQueryFilterable {
  public typealias Filter = BVProductStatisticsFilter
  public typealias Operator = BVRelationalFilterOperator
  
  @discardableResult
  public func filter(_ filter: Filter, op: Operator = .equalTo) -> Self {
    let internalFilter: BVConversationsQueryParameter =
      .filter(filter, op, nil)
    add(internalFilter)
    return self
  }
}

// MARK: - BVProductStatisticsQuery: BVConversationsQueryStatable
extension BVProductStatisticsQuery: BVConversationsQueryStatable {
  public typealias Stat = BVProductStatisticsStat
  
  @discardableResult
  public func stats(_ for: Stat) -> Self {
    let internalStat:BVConversationsQueryParameter = .stats(`for`, nil)
    add(internalStat, coalesce: true)
    return self
  }
}
