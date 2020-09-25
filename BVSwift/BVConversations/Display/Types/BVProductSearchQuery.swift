//
//
//  BVProductSearchQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVProduct Text Search Queries
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/product-catalog/product-display)
public class BVProductSearchQuery: BVConversationsQuery<BVProduct> {
  
  /// The Product text search query
  public let searchQuery: String?
  
  /// The initializer for BVProductSearchQuery
  /// - Parameters:
  ///   - searchQuery: The Product text search query
  public init(searchQuery: String) {
    self.searchQuery = searchQuery
    
    super.init(BVProduct.self)
    
    let queryField: BVConversationsQuerySearchField =
      BVConversationsQuerySearchField(searchQuery)
    let searchField: BVURLParameter =
      .field(queryField, nil)
    
    add(searchField)
  }
}

// MARK: - BVProductSearchQuery: BVQueryFilterable
extension BVProductSearchQuery: BVQueryFilterable {
  public typealias Filter = BVProductFilter
  public typealias Operator = BVConversationsFilterOperator
  
  /// The BVProductSearchQuery's BVQueryFilterable filter() implementation.
  /// - Parameters:
  ///   - apply: The list of filter tuples to apply to this query.
  /// - Important:
  /// \
  /// If more than one tuple is provided then it is assumed that the proper
  /// coalescing is to apply a logical OR to the supplied filter tuples.
  @discardableResult
  public func filter(_ apply: (Filter, Operator)...) -> Self {
    
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
}

// MARK: - BVProductSearchQuery: BVQueryIncludeable
extension BVProductSearchQuery: BVQueryIncludeable {
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

// MARK: - BVProductSearchQuery: BVQueryStatable
extension BVProductSearchQuery: BVQueryStatable {
  public typealias Stat = BVProductStat
  
  @discardableResult
  public func stats(_ for: Stat) -> Self {
    let internalStat: BVURLParameter = .stats(`for`, nil)
    add(internalStat)
    return self
  }
}

// MARK: - BVProductSearchQuery: BVQueryFilteredStatable
extension BVProductSearchQuery: BVQueryFilteredStatable {
  public typealias FilteredStat = BVProductFilteredStat
  
  @discardableResult
  public func filter(_ by: FilteredStat) -> Self {
    let internalStat: BVURLParameter = .stats(by, nil)
    add(internalStat, coalesce: true)
    return self
  }
}

