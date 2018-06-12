//
//
//  BVQuestionQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//
//  

import Foundation

/// Public class for handling BVQuestion Queries
/// - Note:
/// \
/// For more information please see the [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/questions/question-display)
public class BVQuestionQuery: BVConversationsQuery<BVQuestion> {
  
  /// The Product identifier to query
  public let productId: String?
  
  /// The limit for the maximum number of results to be returned
  public let limit: UInt16?
  
  /// The offset in increments of limit to return from
  public let offset: UInt16?
  
  /// The initializer for BVAuthorQuery
  /// - Parameters:
  ///   - productId: The Product identifier to query
  ///   - limit: The limit for the maximum number of results to be returned
  ///   - offset: The offset in increments of limit to return from
  public init(productId: String, limit: UInt16 = 100, offset: UInt16 = 0) {
    self.productId = productId
    self.limit = limit
    self.offset = offset
    
    super.init(BVQuestion.self)
    
    let productFilter:BVConversationsQueryParameter =
      .filter(
        BVCommentFilter.productId(productId),
        BVRelationalFilterOperator.equalTo,
        nil)
    
    add(productFilter)
    
    if 0 < limit {
      let limitField: BVLimitQueryField = BVLimitQueryField(limit)
      add(.customField(limitField, nil))
    }
    
    if 0 < offset {
      let offsetField: BVOffsetQueryField = BVOffsetQueryField(offset)
      add(.customField(offsetField, nil))
    }
  }
}

// MARK: - BVQuestionQuery: BVConversationsQueryFilterable
extension BVQuestionQuery: BVConversationsQueryFilterable {
  public typealias Filter = BVQuestionFilter
  public typealias Operator = BVRelationalFilterOperator
  
  @discardableResult
  public func filter(_ filter: Filter, op: Operator = .equalTo) -> Self {
    let internalFilter:BVConversationsQueryParameter =
      .filter(filter, op, nil)
    add(internalFilter)
    return self
  }
}

// MARK: - BVQuestionQuery: BVConversationsQueryIncludeable
extension BVQuestionQuery: BVConversationsQueryIncludeable {
  public typealias Include = BVQuestionInclude
  
  @discardableResult
  public func include(_ include: Include, limit: UInt16 = 10) -> Self {
    let internalInclude:BVConversationsQueryParameter =
      .include(include, nil)
    add(internalInclude, coalesce: true)
    if limit > 0 {
      let internalIncludeLimit:BVConversationsQueryParameter =
        .includeLimit(include, limit, nil)
      add(internalIncludeLimit)
    }
    return self
  }
}

// MARK: - BVQuestionQuery: BVConversationsQuerySortable
extension BVQuestionQuery: BVConversationsQuerySortable {
  public typealias Sort = BVQuestionSort
  public typealias Order = BVMonotonicSortOrder
  
  @discardableResult
  public func sort(_ sort: Sort, order: Order) -> Self {
    let internalSort: BVConversationsQueryParameter = .sort(sort, order, nil)
    add(internalSort)
    return self
  }
}
