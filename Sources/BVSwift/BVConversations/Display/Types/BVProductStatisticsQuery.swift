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
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/statistics/statistics-display)
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
      let productIdFilter: BVURLParameter =
        .filter(
          BVProductStatisticsFilter.productId(id),
          BVConversationsFilterOperator.equalTo,
          nil)
      
      add(productIdFilter)
    }
  }
}

// MARK: - BVProductStatisticsQuery: BVQueryFilterable
extension BVProductStatisticsQuery: BVQueryFilterable {
  public typealias Filter = BVProductStatisticsFilter
  public typealias Operator = BVConversationsFilterOperator
  
  /// The BVProductStatisticsQuery's BVQueryFilterable filter() implementation.
  /// - Parameters:
  ///   - apply: The list of filter tuples to apply to this query.
  /// - Important:
  /// \
  /// If more than one tuple is provided then it is assumed that the proper
  /// coalescing is to apply a logical OR to the supplied filter tuples.
  @discardableResult
  public func filter(_ apply: (Filter, Operator)...) -> Self {
    let expr: BVQueryFilterExpression<Filter, Operator> =
      1 < apply.count ? .or(apply) : .and(apply)
    flatten(expr).forEach { add($0) }
    return self
  }
}

// MARK: - BVProductStatisticsQuery: BVQueryStatable
extension BVProductStatisticsQuery: BVQueryStatable {
  public typealias Stat = BVProductStatisticsStat
  
  @discardableResult
  public func stats(_ for: Stat) -> Self {
    let internalStat: BVURLParameter = .stats(`for`, nil)
    add(internalStat, coalesce: true)
    return self
  }
}
