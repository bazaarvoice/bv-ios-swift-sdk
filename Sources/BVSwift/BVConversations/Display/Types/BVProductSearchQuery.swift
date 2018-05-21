//
//
//  BVProductSearchQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public final class BVProductSearchQuery: BVConversationsQuery<BVProduct> {
  
  /// Private
  private var searchQueryPriv: String
  
  private struct BVProductSearchQueryField: CustomStringConvertible,
  BVConversationsQueryField {
    
    static var prefix: String {
      get {
        return BVConversationsConstants.BVQuerySearch.defaultField
      }
    }
    
    var internalDescription: String
    
    var description: String {
      get {
        return internalDescription
      }
    }
    
    init(searchQuery: String) {
      internalDescription = searchQuery
    }
  }
  
  /// Public
  public var searchQuery: String {
    get {
      return searchQueryPriv
    }
  }
  
  public init(searchQuery: String) {
    searchQueryPriv = searchQuery
    
    super.init(BVProduct.self)
    
    let queryField: BVProductSearchQueryField =
      BVProductSearchQueryField(searchQuery: searchQueryPriv)
    let searchField: BVConversationsQueryParameter = .custom(queryField, queryField, nil)
    
    add(parameter: searchField)
  }
}

// MARK: - BVProductSearchQuery: BVConversationsQueryFilterable
extension BVProductSearchQuery: BVConversationsQueryFilterable {
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
    
    /// I think we can let everything pass...
    let internalFilter:BVConversationsQueryParameter = {
      switch filter {
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
    
    add(parameter: internalFilter)
    return self
  }
}

// MARK: - BVProductSearchQuery: BVConversationsQueryIncludeable
extension BVProductSearchQuery: BVConversationsQueryIncludeable {
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

// MARK: - BVProductSearchQuery: BVConversationsQueryStatable
extension BVProductSearchQuery: BVConversationsQueryStatable {
  public typealias Stat = BVProductStat
  
  @discardableResult public func stats(
    _ for: Stat) -> Self {
    let internalStat:BVConversationsQueryParameter = .stats(`for`, nil)
    add(parameter: internalStat)
    return self
  }
}
