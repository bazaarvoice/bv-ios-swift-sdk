//
//  BVCommentsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public class BVCommentsQuery: BVConversationsQuery<BVComment> {
  
  /// Public
  public let productId: String?
  public let reviewId: String?
  public let limit: UInt16?
  public let offset: UInt16?
  
  public init(
    productId: String,
    reviewId: String,
    limit: UInt16 = 100,
    offset: UInt16 = 0) {
    self.productId = productId
    self.reviewId = reviewId
    self.limit = limit
    self.offset = offset
    
    super.init(BVComment.self)
    
    let productFilter:BVConversationsQueryParameter =
      .filter(
        BVCommentFilter.productId,
        BVRelationalFilterOperator.equalTo,
        [productId],
        nil)
    
    let reviewFilter:BVConversationsQueryParameter =
      .filter(BVCommentFilter.reviewId,
              BVRelationalFilterOperator.equalTo,
              [reviewId],
              nil)
    
    add(parameter: productFilter)
    add(parameter: reviewFilter)
    
    if 0 < limit {
      let limitField: BVLimitQueryField = BVLimitQueryField(limit)
      add(parameter: .custom(limitField, limitField, nil))
    }
    
    if 0 < offset {
      let offsetField: BVOffsetQueryField = BVOffsetQueryField(offset)
      add(parameter: .custom(offsetField, offsetField, nil))
    }
  }
  
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
}

// MARK: - BVCommentsQuery: BVConversationsQueryFilterable
extension BVCommentsQuery: BVConversationsQueryFilterable {
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

// MARK: - BVCommentsQuery: BVConversationsQueryIncludeable
extension BVCommentsQuery: BVConversationsQueryIncludeable {
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

// MARK: - BVCommentsQuery: BVConversationsQuerySortable
extension BVCommentsQuery: BVConversationsQuerySortable {
  public typealias Sort = BVCommentSort
  public typealias Order = BVMonotonicSortOrder
  
  @discardableResult public func sort(
    _ sort: Sort, order: Order) -> Self {
    let internalSort: BVConversationsQueryParameter = .sort(sort, order, nil)
    add(parameter: internalSort)
    return self
  }
}
