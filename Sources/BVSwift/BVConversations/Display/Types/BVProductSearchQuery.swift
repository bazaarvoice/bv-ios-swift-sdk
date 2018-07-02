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
    
    let queryField: BVConversationsSearchQueryField = BVConversationsSearchQueryField(searchQuery)
    let searchField: BVURLParameter =
      .field(queryField, nil)
    
    add(searchField)
  }
}

// MARK: - BVProductSearchQuery: BVQueryFilterable
extension BVProductSearchQuery: BVQueryFilterable {
  public typealias Filter = BVProductFilter
  public typealias Operator = BVConversationsfiltererator
  
  @discardableResult
  public func filter(_ filter: Filter, op: Operator = .equalTo) -> Self {
    
    /// I think we can let everything pass...
    let internalFilter: BVURLParameter = {
      switch filter {
      case let .answers(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      case let .authors(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      case let .comments(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      case let .questions(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      case let .reviews(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      default:
        return .filter(filter, op, nil)
      }
    }()
    
    add(internalFilter)
    return self
  }
}

// MARK: - BVProductSearchQuery: BVQueryIncludeable
extension BVProductSearchQuery: BVQueryIncludeable {
  public typealias Include = BVProductInclude
  
  @discardableResult
  public func include(_ include: Include, limit: UInt16 = 10) -> Self {
    let internalInclude: BVURLParameter =
      .include(include, nil)
    add(internalInclude, coalesce: true)
    if limit > 0 {
      let internalIncludeLimit: BVURLParameter =
        .includeLimit(include, limit, nil)
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
