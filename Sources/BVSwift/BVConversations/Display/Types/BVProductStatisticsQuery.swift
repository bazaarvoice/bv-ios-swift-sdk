//
//
//  BVProductStatisticsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public final class BVProductStatisticsQuery:
BVConversationsQuery<BVProductStatistics> {
  /// Private
  private var productIdsPriv: [String]
  
  /// Public
  public var productIds: [String] {
    get {
      return productIdsPriv
    }
  }
  
  public init(productIds: [String]) {
    productIdsPriv = productIds
    
    super.init(BVProductStatistics.self)
    
    let productIdFilter: BVConversationsQueryParameter =
      .filter(
        BVProductStatisticsFilter.productId,
        BVRelationalFilterOperator.equalTo,
        productIdsPriv,
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
