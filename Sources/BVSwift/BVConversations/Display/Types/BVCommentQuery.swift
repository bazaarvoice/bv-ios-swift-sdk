//
//  BVCommentQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Public class for handling BVComment Queries
/// - Note:
/// \
/// For more information please see the [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/comments/comment-display)
public class BVCommentQuery: BVConversationsQuery<BVComment> {
  
  /// The Product identifier to query
  public let productId: String?
  
  /// The Comment identifier to query
  public let commentId: String?
  
  /// The initializer for BVAuthorQuery
  /// - Parameters:
  ///   - productId: The Product identifier to query
  ///   - commentId: The Comment identifier to query
  public init(productId: String, commentId: String) {
    self.productId = productId
    self.commentId = commentId
    
    super.init(BVComment.self)
    
    let productFilter:BVConversationsQueryParameter =
      .filter(
        BVCommentFilter.productId(productId),
        BVRelationalFilterOperator.equalTo,
        nil)
    
    let commentFilter:BVConversationsQueryParameter =
      .filter(BVCommentFilter.commentId(commentId),
              BVRelationalFilterOperator.equalTo,
              nil)
    
    add(productFilter)
    add(commentFilter)
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

// MARK: - BVCommentQuery: BVConversationsQueryFilterable
extension BVCommentQuery: BVConversationsQueryFilterable {
  public typealias Filter = BVCommentFilter
  public typealias Operator = BVRelationalFilterOperator
  
  @discardableResult
  public func filter(_ filter: Filter, op: Operator = .equalTo) -> Self {
    let internalFilter:BVConversationsQueryParameter =
      .filter(filter, op, nil)
    add(internalFilter)
    return self
  }
}

// MARK: - BVCommentQuery: BVConversationsQueryIncludeable
extension BVCommentQuery: BVConversationsQueryIncludeable {
  public typealias Include = BVCommentInclude
  
  @discardableResult
  public func include(_ include: Include, limit: UInt16 = 0) -> Self {
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

// MARK: - BVCommentQuery: BVConversationsQuerySortable
extension BVCommentQuery: BVConversationsQuerySortable {
  public typealias Sort = BVCommentSort
  public typealias Order = BVMonotonicSortOrder
  
  @discardableResult
  public func sort(_ sort: Sort, order: Order) -> Self {
    let internalSort: BVConversationsQueryParameter =
      .sort(sort, order, nil)
    add(internalSort)
    return self
  }
}
