//
//  BVCommentQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public final class BVCommentQuery: BVConversationsQuery<BVComment> {
  
  /// Private
  private var productIdPriv: String
  private var commentIdPriv: String
  
  /// Internal
  internal override var conversationsPostflightResultsClosure:
    (([BVComment]?) -> Swift.Void)? {
    get {
      return { (results: [BVComment]?) in
        if let comments = results {
          for comment in comments {
            if let contentId: String = comment.commentId,
              let productId: String = comment.reviewId {
              let commentImpressionEvent: BVAnalyticsEvent =
                .impression(
                  bvProduct: .reviews,
                  contentId: contentId,
                  contentType: .comment,
                  productId: productId,
                  brand: nil,
                  categoryId: nil,
                  additional: nil)
              
              BVPixel.track(
                commentImpressionEvent,
                analyticConfiguration:
                self.configuration?.analyticsConfiguration)
            }
          }
        }
      }
    }
  }
  
  /// Public
  public var productId: String {
    get {
      return productIdPriv
    }
  }
  
  public var commentId: String {
    get {
      return commentIdPriv
    }
  }
  
  public init(productId: String, commentId: String) {
    productIdPriv = productId
    commentIdPriv = commentId
    
    super.init(BVComment.self)
    
    let productFilter:BVConversationsQueryParameter =
      .filter(
        BVCommentFilter.productId,
        BVRelationalFilterOperator.equalTo,
        [productIdPriv],
        nil)
    
    let commentFilter:BVConversationsQueryParameter =
      .filter(BVCommentFilter.commentId,
              BVRelationalFilterOperator.equalTo,
              [commentIdPriv],
              nil)
    
    add(parameter: productFilter)
    add(parameter: commentFilter)
  }
}

// MARK: - BVCommentQuery: BVConversationsQueryFilterable
extension BVCommentQuery: BVConversationsQueryFilterable {
  public typealias Filter = BVCommentFilter
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

// MARK: - BVCommentQuery: BVConversationsQueryIncludeable
extension BVCommentQuery: BVConversationsQueryIncludeable {
  public typealias Include = BVCommentInclude
  
  @discardableResult public func include(
    _ include: Include, limit: UInt16 = 0) -> Self {
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

// MARK: - BVCommentQuery: BVConversationsQuerySortable
extension BVCommentQuery: BVConversationsQuerySortable {
  public typealias Sort = BVCommentSort
  public typealias Order = BVMonotonicSortOrder
  
  @discardableResult public func sort(
    _ sort: Sort, order: Order) -> Self {
    let internalSort: BVConversationsQueryParameter = .sort(sort, order, nil)
    add(parameter: internalSort)
    return self
  }
}
