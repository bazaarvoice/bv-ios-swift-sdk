//
//
//  BVQuestionQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//
//  

import Foundation

public final class BVQuestionQuery: BVConversationsQuery<BVQuestion> {
  /// Private
  private static let limitKey:String =
    BVConversationsConstants.BVQueryType.Keys.limit
  private static let offsetKey:String =
    BVConversationsConstants.BVQueryType.Keys.offset
  
  private var productIdPriv: String
  private var limitPriv: UInt16
  private var offsetPriv: UInt16
  
  /// Public
  public var productId: String {
    get {
      return productIdPriv
    }
  }
  
  public var limit: UInt16 {
    get {
      return limitPriv
    }
  }
  
  public var offset: UInt16 {
    get {
      return offsetPriv
    }
  }
  
  public init(productId: String, limit: UInt16 = 100, offset: UInt16 = 0) {
    productIdPriv = productId
    limitPriv = limit
    offsetPriv = offset
    
    super.init(BVQuestion.self)
    
    let productFilter:BVConversationsQueryParameter =
      .filter(
        BVCommentFilter.productId,
        BVRelationalFilterOperator.equalTo,
        [productIdPriv],
        nil)
    
    add(parameter: productFilter)
    
    if 0 < limitPriv {
      add(parameter: .custom(BVQuestionQuery.limitKey, limitPriv, nil))
    }
    
    if 0 < offsetPriv {
      add(parameter: .custom(BVQuestionQuery.offsetKey, offsetPriv, nil))
    }
  }
}

// MARK: - BVQuestionQuery: BVConversationsQueryFilterable
extension BVQuestionQuery: BVConversationsQueryFilterable {
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

// MARK: - BVQuestionQuery: BVConversationsQueryIncludeable
extension BVQuestionQuery: BVConversationsQueryIncludeable {
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

// MARK: - BVQuestionQuery: BVConversationsQuerySortable
extension BVQuestionQuery: BVConversationsQuerySortable {
  public typealias Sort = BVQuestionSort
  public typealias Order = BVMonotonicSortOrder
  
  @discardableResult public func sort(
    _ sort: Sort, order: Order) -> Self {
    let internalSort: BVConversationsQueryParameter = .sort(sort, order, nil)
    add(parameter: internalSort)
    return self
  }
}
