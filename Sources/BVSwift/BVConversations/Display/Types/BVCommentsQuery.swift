//
//  BVCommentsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Public class for handling BVComment Queries
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/comments/comment-display)
public class BVCommentsQuery: BVConversationsQuery<BVComment> {
  
  /// The Product identifier to query
  public let productId: String?
  
  /// The Review identifier to query
  public let reviewId: String?
  
  /// The limit for the maximum number of results to be returned
  public let limit: UInt16?
  
  /// The offset in increments of limit to return from
  public let offset: UInt16?
  
  /// The initializer for BVAuthorQuery
  /// - Parameters:
  ///   - productId: The Product identifier to query
  ///   - reviewId: The Review identifier to query
  ///   - limit: The limit for the maximum number of results to be returned
  ///   - offset: The offset in increments of limit to return from
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
    
    let productFilter: BVURLParameter =
      .filter(
        BVCommentFilter.productId(productId),
        BVConversationsFilterOperator.equalTo,
        nil)
    
    let reviewFilter: BVURLParameter =
      .filter(BVCommentFilter.reviewId(reviewId),
              BVConversationsFilterOperator.equalTo,
              nil)
    
    add(productFilter)
    add(reviewFilter)
    
    if 0 < limit {
      let limitField: BVConversationsQueryLimitField = BVConversationsQueryLimitField(limit)
      add(.field(limitField, nil))
    }
    
    if 0 < offset {
      let offsetField: BVConversationsQueryOffsetField = BVConversationsQueryOffsetField(offset)
      add(.field(offsetField, nil))
    }
  }
  
  /// Internal
  final internal override var queryPostflightResultsClosure: (([BVComment]?) -> Swift.Void)? {
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

// MARK: - BVCommentsQuery: BVQueryFilterable
extension BVCommentsQuery: BVQueryFilterable {
  public typealias Filter = BVCommentFilter
  public typealias Operator = BVConversationsFilterOperator
  
  /// The BVCommentsQuery's BVQueryFilterable filter() implementation.
  /// - Parameters:
  ///   - apply: The list of filter tuples to apply to this query.
  /// - Important:
  /// \
  /// If more than one tuple is provided then it is assumed that the proper
  /// coalescing is to apply a logical OR to the supplied filter tuples.
  @discardableResult
  public func filter(_ apply: (Filter, Operator)...) -> Self {
    let expr: BVQueryFilterExpression<Filter, Operator> =
      1 < apply.count ? .or(apply) : .and(apply)
    flatten(expr).forEach { add($0) }
    return self
  }
}

// MARK: - BVCommentsQuery: BVQueryIncludeable
extension BVCommentsQuery: BVQueryIncludeable {
  public typealias Include = BVCommentInclude
  
  @discardableResult
  public func include(_ kind: Include, limit: UInt16 = 0) -> Self {
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

// MARK: - BVCommentsQuery: BVQuerySortable
extension BVCommentsQuery: BVQuerySortable {
  public typealias Sort = BVCommentSort
  public typealias Order = BVConversationsSortOrder
  
  @discardableResult
  public func sort(_ on: Sort, order: Order) -> Self {
    let internalSort: BVURLParameter =
      .sort(on, order, nil)
    add(internalSort)
    return self
  }
}
