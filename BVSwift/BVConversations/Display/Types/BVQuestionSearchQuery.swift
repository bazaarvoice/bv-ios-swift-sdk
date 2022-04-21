//
//  BVQuestionSearchQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Public class for handling BVQuestion Search Queries
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/questions/question-display)
public class BVQuestionSearchQuery: BVConversationsQuery<BVQuestion> {
  
  /// The Product identifier to query
  public let productId: String?
  
  /// The text search query
  public let searchQuery: String?
  
  /// The limit for the maximum number of results to be returned
  public let limit: UInt16?
  
  /// The offset in increments of limit to return from
  public let offset: UInt16?
  
  /// The initializer for BVAuthorQuery
  /// - Parameters:
  ///   - productId: The Product identifier to query
  ///   - searchQuery: The text search query
  ///   - limit: The limit for the maximum number of results to be returned
  ///   - offset: The offset in increments of limit to return from
  public init(
    productId: String,
    searchQuery: String,
    limit: UInt16 = 100,
    offset: UInt16 = 0) {
    
    self.productId = productId
    self.searchQuery = searchQuery
    self.limit = limit
    self.offset = offset
    
    super.init(BVQuestion.self)
    
    let productFilter: BVURLParameter =
      .filter(
        BVCommentFilter.productId(productId),
        BVConversationsFilterOperator.equalTo,
        nil)
    
    add(productFilter)
    
    let queryField: BVConversationsQuerySearchField =
      BVConversationsQuerySearchField(searchQuery)
    let searchField: BVURLParameter =
      .field(queryField, nil)
    
    add(searchField)
    
    if 0 < limit {
      let limitField: BVConversationsQueryLimitField =
        BVConversationsQueryLimitField(limit)
      add(.field(limitField, nil))
    }
    
    if 0 < offset {
      let offsetField: BVConversationsQueryOffsetField =
        BVConversationsQueryOffsetField(offset)
      add(.field(offsetField, nil))
    }
  }
}

// MARK: - BVQuestionSearchQuery: BVQueryFilterable
extension BVQuestionSearchQuery: BVQueryFilterable {
  public typealias Filter = BVQuestionFilter
  public typealias Operator = BVConversationsFilterOperator
  
  /// The BVQuestionSearchQuery's BVQueryFilterable filter() implementation.
  /// - Parameters:
  ///   - apply: The list of filter tuples to apply to this query.
  /// - Important:
  /// \
  /// If more than one tuple is provided then it is assumed that the proper
  /// coalescing is to apply a logical OR to the supplied filter tuples.
  @discardableResult
  public func filter(_ apply: [(Filter, Operator)]) -> Self {
    type(of: self).groupFilters(apply).forEach { group in
      let expr: BVQueryFilterExpression<Filter, Operator> =
        1 < group.count ? .or(group) : .and(group)
      flatten(expr).forEach { add($0) }
    }
    return self
  }
    
    public func filter(_ apply: (Filter, Operator)...) -> Self {
        self.filter(apply)
    }
}

// MARK: - BVQuestionSearchQuery: BVQueryIncludeable
extension BVQuestionSearchQuery: BVQueryIncludeable {
  public typealias Include = BVQuestionInclude
  
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
