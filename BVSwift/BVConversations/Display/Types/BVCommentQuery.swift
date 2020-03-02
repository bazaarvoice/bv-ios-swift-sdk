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
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/comments/comment-display)
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
    
    let productFilter: BVURLParameter =
      .filter(
        BVCommentFilter.productId(productId),
        BVConversationsFilterOperator.equalTo,
        nil)
    
    let commentFilter: BVURLParameter =
      .filter(BVCommentFilter.commentId(commentId),
              BVConversationsFilterOperator.equalTo,
              nil)
    
    add(productFilter)
    add(commentFilter)
  }
  
  /// Internal
  final internal override var queryPostflightResultsClosure: (
    ([BVComment]?) -> Void)? {
    return { [weak self] (results: [BVComment]?) in
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
              self?.configuration?.analyticsConfiguration)
          }
        }
      }
    }
  }
}

// MARK: - BVCommentQuery: BVQueryFilterable
extension BVCommentQuery: BVQueryFilterable {
  public typealias Filter = BVCommentFilter
  public typealias Operator = BVConversationsFilterOperator
  
  /// The BVCommentQuery's BVQueryFilterable filter() implementation.
  /// - Parameters:
  ///   - apply: The list of filter tuples to apply to this query.
  /// - Important:
  /// \
  /// If more than one tuple is provided then it is assumed that the proper
  /// coalescing is to apply a logical OR to the supplied filter tuples.
  @discardableResult
  public func filter(_ apply: (Filter, Operator)...) -> Self {
    type(of: self).groupFilters(apply).forEach { group in
      let expr: BVQueryFilterExpression<Filter, Operator> =
        1 < group.count ? .or(group) : .and(group)
      flatten(expr).forEach { add($0) }
    }
    return self
  }
}

// MARK: - BVCommentQuery: BVQueryIncludeable
extension BVCommentQuery: BVQueryIncludeable {
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

// MARK: - BVCommentQuery: BVQuerySortable
extension BVCommentQuery: BVQuerySortable {
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
