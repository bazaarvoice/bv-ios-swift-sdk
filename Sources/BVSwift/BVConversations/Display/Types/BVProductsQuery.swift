//
//
//  BVProductsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public final class BVProductsQuery: BVConversationsQuery<BVProduct> {
  public init() {
    super.init(BVProduct.self)
  }
}

// MARK: - BVProductsQuery: BVConversationsQueryFilterable
extension BVProductsQuery: BVConversationsQueryFilterable {
  public typealias Filter = BVProductFilter
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
    
    /// We have to do *almost* the inverse of BVProductQuery
    let internalFilter:BVConversationsQueryParameter? = {
      switch filter {
      case .productId:
        if 2 > values.count {
          // TODO: Make sure to log that the values need to be greater than
          // one.
          fatalError("Adding a single Product ID will cause problems. " +
            "Please use BVProductQuery if you care to get information " +
            "about a singular product.")
        }
        return .filter(filter, op, values, nil)
      case let .answers(typeFilter):
        return .filterType(filter, typeFilter, op, values, nil)
      case let .authors(typeFilter):
        return .filterType(filter, typeFilter, op, values, nil)
      case let .comments(typeFilter):
        return .filterType(filter, typeFilter, op, values, nil)
      case let .questions(typeFilter):
        return .filterType(filter, typeFilter, op, values, nil)
      case let .reviews(typeFilter):
        return .filterType(filter, typeFilter, op, values, nil)
      default:
        return .filter(filter, op, values, nil)
      }
    }()
    
    if let subFilter = internalFilter {
      add(parameter: subFilter)
    }
    
    return self
  }
}

// MARK: - BVProductsQuery: BVConversationsQueryIncludeable
extension BVProductsQuery: BVConversationsQueryIncludeable {
  public typealias Include = BVProductInclude
  
  @discardableResult public func include(
    _ include: Include, limit: UInt16 = 10) -> Self {
    let internalInclude:BVConversationsQueryParameter = .include(include, nil)
    add(parameter: internalInclude, coalesce: true)
    if limit > 0 {
      let internalIncludeLimit:BVConversationsQueryParameter =
        .includeLimit(include, limit, nil)
      add(parameter: internalIncludeLimit)
    }
    return self
  }
}

// MARK: - BVProductsQuery: BVConversationsQuerySortable
extension BVProductsQuery: BVConversationsQuerySortable {
  public typealias Sort = BVProductSort
  public typealias Order = BVMonotonicSortOrder
  
  @discardableResult public func sort(
    _ sort: Sort, order: Order) -> Self {
    let internalSort: BVConversationsQueryParameter = {
      switch sort {
      case let .answers(by):
        return .sortType(sort, by, order, nil)
      case let .authors(by):
        return .sortType(sort, by, order, nil)
      case let .comments(by):
        return .sortType(sort, by, order, nil)
      case let .questions(by):
        return .sortType(sort, by, order, nil)
      case let .reviews(by):
        return .sortType(sort, by, order, nil)
      default:
        return .sort(sort, order, nil)
      }
    }()
    
    add(parameter: internalSort)
    return self
  }
}

// MARK: - BVProductsQuery: BVConversationsQueryStatable
extension BVProductsQuery: BVConversationsQueryStatable {
  public typealias Stat = BVProductStat
  
  @discardableResult public func stats(
    _ for: Stat) -> Self {
    let internalStat:BVConversationsQueryParameter = .stats(`for`, nil)
    add(parameter: internalStat)
    return self
  }
}
