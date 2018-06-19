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
        BVConversationsfiltererator.equalTo,
        nil)
    
    let commentFilter: BVURLParameter =
      .filter(BVCommentFilter.commentId(commentId),
              BVConversationsfiltererator.equalTo,
              nil)
    
    add(productFilter)
    add(commentFilter)
  }
  
  /// Internal
  internal override var conversationsPostflightResultsClosure: (([BVComment]?) -> Swift.Void)? {
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

// MARK: - BVCommentQuery: BVQueryFilterable
extension BVCommentQuery: BVQueryFilterable {
  public typealias Filter = BVCommentFilter
  public typealias Operator = BVConversationsfiltererator
  
  @discardableResult
  public func filter(_ filter: Filter, op: Operator = .equalTo) -> Self {
    let internalFilter: BVURLParameter =
      .filter(filter, op, nil)
    add(internalFilter)
    return self
  }
}

// MARK: - BVCommentQuery: BVQueryIncludeable
extension BVCommentQuery: BVQueryIncludeable {
  public typealias Include = BVCommentInclude
  
  @discardableResult
  public func include(_ include: Include, limit: UInt16 = 0) -> Self {
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

// MARK: - BVCommentQuery: BVQuerySortable
extension BVCommentQuery: BVQuerySortable {
  public typealias Sort = BVCommentSort
  public typealias Order = BVConversationsSortOrder
  
  @discardableResult
  public func sort(_ sort: Sort, order: Order) -> Self {
    let internalSort: BVURLParameter =
      .sort(sort, order, nil)
    add(internalSort)
    return self
  }
}
