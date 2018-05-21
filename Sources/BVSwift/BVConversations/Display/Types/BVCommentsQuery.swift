//
//  BVCommentsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public class BVCommentsQuery: BVConversationsQuery<BVComment> {
  
  /// Private
  private static let limitKey:String =
    BVConversationsConstants.BVQueryType.Keys.limit
  private static let offsetKey:String =
    BVConversationsConstants.BVQueryType.Keys.offset
  
  private var productIdPriv: String
  private var reviewIdPriv: String
  private var limitPriv: UInt16
  private var offsetPriv: UInt16
  
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
              
              BVPixel.track(commentImpressionEvent)
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
  
  public var reviewId: String {
    get {
      return reviewIdPriv
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
  
  public init(
    productId: String,
    reviewId: String,
    limit: UInt16 = 100,
    offset: UInt16 = 0) {
    productIdPriv = productId
    reviewIdPriv = reviewId
    limitPriv = limit
    offsetPriv = offset
    
    super.init(BVComment.self)
    
    let productFilter:BVConversationsQueryParameter =
      .filter(
        BVCommentFilter.productId,
        BVRelationalFilterOperator.equalTo,
        [productIdPriv],
        nil)
    
    let reviewFilter:BVConversationsQueryParameter =
      .filter(BVCommentFilter.reviewId,
              BVRelationalFilterOperator.equalTo,
              [reviewIdPriv],
              nil)
    
    add(parameter: productFilter)
    add(parameter: reviewFilter)
    
    if 0 < limitPriv {
      add(parameter: .custom(BVCommentsQuery.limitKey, limitPriv, nil))
    }
    
    if 0 < offsetPriv {
      add(parameter: .custom(BVCommentsQuery.offsetKey, offsetPriv, nil))
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
