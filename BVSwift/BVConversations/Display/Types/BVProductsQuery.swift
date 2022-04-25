//
//
//  BVProductsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVProducts Queries
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/product-catalog/product-display)
public class BVProductsQuery: BVConversationsQuery<BVProduct> {
  
  /// The Product ids for the query
  public let productIds: [String]?
  
  /// The initializer for BVProductsQuery
  /// - Parameters:
  ///   - productIds: The Product ids for the query
  /// - Note:
  /// \
  /// productIds.count must be greater than 1.
  public init?(productIds: [String]) {
    
    guard 1 < productIds.count else {
      return nil
    }
    
    self.productIds = productIds
    
    super.init(BVProduct.self)
    
    let productIdFilterTuple = productIds.map {
      return (BVConversationsQueryFilter.id($0),
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

// MARK: - BVProductsQuery: BVQueryFilterable
extension BVProductsQuery: BVQueryFilterable {
  public typealias Filter = BVProductFilter
  public typealias Operator = BVConversationsFilterOperator
  
  /// The BVProductsQuery's BVQueryFilterable filter() implementation.
  /// - Parameters:
  ///   - apply: The list of filter tuples to apply to this query.
  /// - Important:
  /// \
  /// If more than one tuple is provided then it is assumed that the proper
  /// coalescing is to apply a logical OR to the supplied filter tuples.
  @discardableResult
  public func filter(_ apply: [(Filter, Operator)]) -> Self {
    
    let preflight: ((Filter, Operator) -> BVURLParameter?) = {
      /// I think we can let everything pass...
      switch $0 {
      case let .answers(typeFilter):
        return .filterType($0, typeFilter, $1, nil)
      case let .authors(typeFilter):
        return .filterType($0, typeFilter, $1, nil)
      case let .comments(typeFilter):
        return .filterType($0, typeFilter, $1, nil)
      case let .questions(typeFilter):
        return .filterType($0, typeFilter, $1, nil)
      case let .reviews(typeFilter):
        return .filterType($0, typeFilter, $1, nil)
      default:
        return .filter($0, $1, nil)
      }
    }
    
    type(of: self).groupFilters(apply).forEach { group in
      let expr: BVQueryFilterExpression<Filter, Operator> =
        1 < group.count ? .or(group) : .and(group)
      flatten(expr, preflight: preflight).forEach { add($0) }
    }
    return self
  }
    
    public func filter(_ apply: (Filter, Operator)...) -> Self {
        self.filter(apply)
    }
}

// MARK: - BVProductsQuery: BVQueryIncludeable
extension BVProductsQuery: BVQueryIncludeable {
  public typealias Include = BVProductInclude
  
  @discardableResult
  public func include(_ kind: Include, limit: UInt16 = 10) -> Self {
    let internalInclude: BVURLParameter =
      .include(kind, nil)
    add(internalInclude, coalesce: true)
    if limit > 0 {
      let internalIncludeLimit: BVURLParameter =
        .includeLimit(kind, limit, nil)
      add(internalIncludeLimit)
    }
    return self
  }
}

// MARK: - BVProductsQuery: BVQuerySortable
extension BVProductsQuery: BVQuerySortable {
  public typealias Sort = BVProductSort
  public typealias Order = BVConversationsSortOrder
  
  @discardableResult
  public func sort(_ on: Sort, order: Order) -> Self {
    let internalSort: BVURLParameter = {
      switch on {
      case let .answers(by):
        return .sortType(on, by, order, nil)
      case let .authors(by):
        return .sortType(on, by, order, nil)
      case let .comments(by):
        return .sortType(on, by, order, nil)
      case let .questions(by):
        return .sortType(on, by, order, nil)
      case let .reviews(by):
        return .sortType(on, by, order, nil)
      default:
        return .sort(on, order, nil)
      }
    }()
    
    add(internalSort)
    return self
  }
}

// MARK: - BVProductsQuery: BVQueryStatable
extension BVProductsQuery: BVQueryStatable {
  public typealias Stat = BVProductStat
  
  @discardableResult
  public func stats(_ for: Stat) -> Self {
    let internalStat: BVURLParameter = .stats(`for`, nil)
    add(internalStat, coalesce: true)
    return self
  }
}

// MARK: - BVProductsQuery: BVQueryFilteredStatable
extension BVProductsQuery: BVQueryFilteredStatable {
  public typealias FilteredStat = BVProductFilteredStat
  
  @discardableResult
  public func filter(_ by: FilteredStat) -> Self {
    let internalStat: BVURLParameter = .stats(by, nil)
    add(internalStat, coalesce: true)
    return self
  }
}

// MARK: - BVProductsQuery: BVQueryIncentivizedStatable
extension BVProductsQuery: BVQueryIncentivizedStatable {
  @discardableResult
  public func incentivizedStats(_ value: Bool) -> Self {
    let incentivizedStat: BVURLParameter = .field(BVIncentivizedStats(value), nil)
    add(incentivizedStat, coalesce: false)
    return self
  }
}

// MARK: - BVReviewQuery: BVQueryTagStatStatable
extension BVProductsQuery: BVQueryTagStatStatable {
  @discardableResult
  public func tagStats(_ value: Bool) -> Self {
    let tagStat: BVURLParameter = .field(BVTagStats(value), nil)
    add(tagStat, coalesce: false)
    return self
  }
}

// MARK: - BVProductsQuery: BVQuerySecondaryRatingstatable
extension BVProductsQuery: BVQuerySecondaryRatingstatable {
  @discardableResult
  public func secondaryRatingstats(_ value: Bool) -> Self {
    let secondaryRatingstat: BVURLParameter = .field(BVSecondaryRatingStat(value), nil)
    add(secondaryRatingstat, coalesce: false)
    return self
  }
}
