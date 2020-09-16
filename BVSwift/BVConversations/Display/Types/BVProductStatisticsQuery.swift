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
  /// - Note:
  /// \
  /// productIds.count must be greater than 0.
  public init?(productIds: [String]) {
    
    guard !productIds.isEmpty else {
      return nil
    }
    
    self.productIds = productIds
    
    super.init(BVProductStatistics.self)
    
    let productIdFilterTuple = productIds.map {
      return (BVConversationsQueryFilter.productId($0),
              BVConversationsFilterOperator.equalTo)
    }
    
    type(of: self).groupFilters(productIdFilterTuple).forEach { group in
      let expr: BVQueryFilterExpression<BVConversationsQueryFilter,
        BVConversationsFilterOperator> =
        1 < group.count ? .or(group) : .and(group)
      flatten(expr).forEach { add($0) }
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
    type(of: self).groupFilters(apply).forEach { group in
      let expr: BVQueryFilterExpression<Filter, Operator> =
        1 < group.count ? .or(group) : .and(group)
      flatten(expr).forEach { add($0) }
    }
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

// MARK: - BVProductStatisticsQuery: BVQueryIncentivizedStatable
extension BVProductStatisticsQuery: BVQueryIncentivizedStatable {
  @discardableResult
  public func incentivizedStats(_ value: Bool) -> Self {
    let incentivizedStat: BVURLParameter = .field(BVIncentivizedStats(value), nil)
    add(incentivizedStat, coalesce: false)
    return self
  }
}

