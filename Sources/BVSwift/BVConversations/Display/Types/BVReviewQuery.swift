//
//
//  BVReviewQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//
//  

import Foundation

public final class BVReviewQuery: BVConversationsQuery<BVReview> {
  
  /// Private
  private static let limitKey:String =
    BVConversationsConstants.BVQueryType.Keys.limit
  private static let offsetKey:String =
    BVConversationsConstants.BVQueryType.Keys.offset
  
  private var productIdPriv: String
  private var limitPriv: UInt16
  private var offsetPriv: UInt16
  
  /// Internal
  internal override var conversationsPostflightResultsClosure:
    (([BVReview]?) -> Swift.Void)? {
    get {
      return { (results: [BVReview]?) in
        if let reviews = results,
          let firstReview = reviews.first {
          for review in reviews {
            if let id = review.reviewId,
              let product:BVProduct = review.products?
                .filter({
                  guard let id:String = $0.productId else {
                    return false
                  }
                  return id == self.productId
                }).first {
              
              let reviewImpressionEvent: BVAnalyticsEvent =
                .impression(
                  bvProduct: .reviews,
                  contentId: id,
                  contentType: .review,
                  productId: self.productId,
                  brand: product.brand?.brandId,
                  categoryId: product.categoryId,
                  additional: nil)
              
              BVPixel.track(reviewImpressionEvent)
            }
          }
          
          if let product:BVProduct = firstReview.products?
            .filter({
              guard let id:String = $0.productId else {
                return false
              }
              return id == self.productId
            }).first {
            
            let add = [ "numReviews" : reviews.count ]
            let reviewPageViewEvent: BVAnalyticsEvent =
              .pageView(
                bvProduct: .reviews,
                productId: self.productId,
                brand: product.brand?.brandId,
                categoryId: product.categoryId,
                rootCategoryId: nil,
                additional: add)
            
            BVPixel.track(reviewPageViewEvent)
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
    
    super.init(BVReview.self)
    
    let productFilter:BVConversationsQueryParameter =
      .filter(
        BVCommentFilter.productId,
        BVRelationalFilterOperator.equalTo,
        [productIdPriv],
        nil)
    
    add(parameter: productFilter)
    
    if 0 < limitPriv {
      add(parameter: .custom(BVReviewQuery.limitKey, limitPriv, nil))
    }
    
    if 0 < offsetPriv {
      add(parameter: .custom(BVReviewQuery.offsetKey, offsetPriv, nil))
    }
  }
}

// MARK: - BVReviewQuery: BVConversationsQueryFilterable
extension BVReviewQuery: BVConversationsQueryFilterable {
  public typealias Filter = BVReviewFilter
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

// MARK: - BVReviewQuery: BVConversationsQueryIncludeable
extension BVReviewQuery: BVConversationsQueryIncludeable {
  public typealias Include = BVReviewInclude
  
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

// MARK: - BVReviewQuery: BVConversationsQuerySortable
extension BVReviewQuery: BVConversationsQuerySortable {
  public typealias Sort = BVReviewSort
  public typealias Order = BVMonotonicSortOrder
  
  @discardableResult public func sort(
    _ sort: Sort, order: Order) -> Self {
    let internalSort: BVConversationsQueryParameter = .sort(sort, order, nil)
    add(parameter: internalSort)
    return self
  }
}

