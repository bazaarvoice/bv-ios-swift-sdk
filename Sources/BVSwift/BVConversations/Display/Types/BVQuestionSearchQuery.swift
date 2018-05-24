//
//  BVQuestionSearchQuery.swift
//  BVSwift
//
//  Created by Michael Van Milligan on 5/24/18.
//  Copyright © 2018 Michael Van Milligan. All rights reserved.
//

import Foundation

public final class BVQuestionSearchQuery: BVConversationsQuery<BVQuestion> {
  
  /// Public
  public let productId: String?
  public let searchQuery: String?
  public let limit: UInt16?
  public let offset: UInt16?
  
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
    
    let productFilter:BVConversationsQueryParameter =
      .filter(
        BVCommentFilter.productId,
        BVRelationalFilterOperator.equalTo,
        [productId],
        nil)
    
    add(parameter: productFilter)
    
    let queryField: BVSearchQueryField = BVSearchQueryField(searchQuery)
    let searchField: BVConversationsQueryParameter =
      .customField(queryField, nil)
    
    add(parameter: searchField)
    
    if 0 < limit {
      let limitField: BVLimitQueryField = BVLimitQueryField(limit)
      add(parameter: .custom(limitField, limitField, nil))
    }
    
    if 0 < offset {
      let offsetField: BVOffsetQueryField = BVOffsetQueryField(offset)
      add(parameter: .custom(offsetField, offsetField, nil))
    }
  }
}

// MARK: - BVQuestionSearchQuery: BVConversationsQueryFilterable
extension BVQuestionSearchQuery: BVConversationsQueryFilterable {
  public typealias Filter = BVQuestionFilter
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

// MARK: - BVQuestionSearchQuery: BVConversationsQueryIncludeable
extension BVQuestionSearchQuery: BVConversationsQueryIncludeable {
  public typealias Include = BVQuestionInclude
  
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
