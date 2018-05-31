//
//
//  BVReviewQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//
//  

import Foundation

/// Public class for handling BVReview Queries
/// - Note:
/// \
/// For more information please see the [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/reviews)
public class BVReviewQuery: BVConversationsQuery<BVReview> {
  
  /// The Product identifier to query
  public let productId: String?
  
  /// The limit for the maximum number of results to be returned
  public let limit: UInt16?
  
  /// The offset in increments of limit to return from
  public let offset: UInt16?
  
  /// The initializer for BVReviewQuery
  /// - Parameters:
  ///   - productId: The Product identifier to query
  ///   - limit: The limit for the maximum number of results to be returned
  ///   - offset: The offset in increments of limit to return from
  public init(productId: String, limit: UInt16 = 100, offset: UInt16 = 0) {
    self.productId = productId
    self.limit = limit
    self.offset = offset
    
    super.init(BVReview.self)
    
    let productFilter:BVConversationsQueryParameter =
      .filter(
        BVCommentFilter.productId,
        BVRelationalFilterOperator.equalTo,
        [productId],
        nil)
    
    add(parameter: productFilter)
    
    if 0 < limit {
      let limitField: BVLimitQueryField = BVLimitQueryField(limit)
      add(parameter: .customField(limitField, nil))
    }
    
    if 0 < offset {
      let offsetField: BVOffsetQueryField = BVOffsetQueryField(offset)
      add(parameter: .customField(offsetField, nil))
    }
  }
  
  /// Internal
  internal override var conversationsPostflightResultsClosure:
    (([BVReview]?) -> Swift.Void)? {
    get {
      return { (results: [BVReview]?) in
        if let reviews = results,
          let firstReview = reviews.first,
          let productId = self.productId {
          for review in reviews {
            if let id = review.reviewId,
              let product:BVProduct = review.products?
                .filter({
                  guard let id:String = $0.productId else {
                    return false
                  }
                  return id == productId
                }).first {
              
              let reviewImpressionEvent: BVAnalyticsEvent =
                .impression(
                  bvProduct: .reviews,
                  contentId: id,
                  contentType: .review,
                  productId: productId,
                  brand: product.brand?.brandId,
                  categoryId: product.categoryId,
                  additional: nil)
              
              BVPixel.track(
                reviewImpressionEvent,
                analyticConfiguration:
                self.configuration?.analyticsConfiguration)
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
                productId: productId,
                brand: product.brand?.brandId,
                categoryId: product.categoryId,
                rootCategoryId: nil,
                additional: add)
            
            BVPixel.track(
              reviewPageViewEvent,
              analyticConfiguration:
              self.configuration?.analyticsConfiguration)
          }
        }
      }
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

