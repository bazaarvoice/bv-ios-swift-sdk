//
//  BVReviewSearchQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Public class for handling BVReview Text Search Queries
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/reviews)
public class BVReviewSearchQuery: BVConversationsQuery<BVReview> {
  
  /// The Product identifier to query
  public let productId: String?
  
  /// The text search query
  public let searchQuery: String?
  
  /// The limit for the maximum number of results to be returned
  public let limit: UInt16?
  
  /// The offset in increments of limit to return from
  public let offset: UInt16?
  
  /// The initializer for BVReviewQuery
  /// - Parameters:
  ///   - productId: The Product identifier to query
  ///   - searchQuery: The text search query
  ///   - limit: The limit for the maximum number of results to be returned
  ///   - offset: The offset in increments of limit to return from
  public init(
    productId: String,
    searchQuery: String,
    limit: UInt16 = 100,
    offset: UInt16 = 0) {
    
    self.productId = productId
    self.searchQuery = searchQuery
    self.limit = limit
    self.offset = offset
    
    super.init(BVReview.self)
    
    let productFilter: BVURLParameter =
      .filter(
        BVCommentFilter.productId(productId),
        BVConversationsfiltererator.equalTo,
        nil)
    
    add(productFilter)
    
    let queryField: BVConversationsQuerySearchField =
      BVConversationsQuerySearchField(searchQuery)
    let searchField: BVURLParameter =
      .field(queryField, nil)
    
    add(searchField)
    
    if 0 < limit {
      let limitField: BVConversationsQueryLimitField =
        BVConversationsQueryLimitField(limit)
      add(.field(limitField, nil))
    }
    
    if 0 < offset {
      let offsetField: BVConversationsQueryOffsetField =
        BVConversationsQueryOffsetField(offset)
      add(.field(offsetField, nil))
    }
  }
  
  /// Internal
  final internal override var queryPreflightResultsClosure: BVURLRequestablePreflightHandler? {
    return { (completion: BVCompletionWithErrorsHandler?) -> Swift.Void in
      var hasProductInclude: Bool = false
      var hasFilteredInclude: Bool = false
      
      self.parameters.forEach {
        switch $0 {
        case .stats(_ as BVQueryFilteredStat, _):
          hasFilteredInclude = true
        case let .include(include as BVReviewInclude, _)
          where .products == include:
          hasProductInclude = true
        default:
          break
        }
      }
      
      if hasFilteredInclude && !hasProductInclude {
        completion?(
          BVConversationsError.badRequest("Must include product include"))
        return
      }
      
      completion?(nil)
    }
  }
  
  final internal override var queryPostflightResultsClosure: (
    ([BVReview]?) -> Swift.Void)? {
    return { (results: [BVReview]?) in
      if let reviews = results,
        let firstReview = reviews.first,
        let productId = self.productId {
        for review in reviews {
          if let id = review.reviewId,
            let product: BVProduct = review.products?
              .filter({
                guard let id: String = $0.productId else {
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
        
        if let product: BVProduct = firstReview.products?
          .filter({
            guard let id: String = $0.productId else {
              return false
            }
            return id == self.productId
          }).first {
          
          let add = [ "numReviews": reviews.count ]
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

// MARK: - BVReviewSearchQuery: BVQueryFilterable
extension BVReviewSearchQuery: BVQueryFilterable {
  public typealias Filter = BVReviewFilter
  public typealias Operator = BVConversationsfiltererator
  
  @discardableResult
  public func filter(_ by: Filter, op: Operator = .equalTo) -> Self {
    let internalFilter: BVURLParameter =
      .filter(by, op, nil)
    add(internalFilter)
    return self
  }
}

// MARK: - BVReviewSearchQuery: BVQueryFilteredStatable
extension BVReviewSearchQuery: BVQueryFilteredStatable {
  public typealias FilteredStat = BVReviewFilteredStat
  
  @discardableResult
  public func filter(_ by: FilteredStat) -> Self {
    let internalStat: BVURLParameter = .stats(by, nil)
    add(internalStat, coalesce: true)
    return self
  }
}

// MARK: - BVReviewSearchQuery: BVQueryIncludeable
extension BVReviewSearchQuery: BVQueryIncludeable {
  public typealias Include = BVReviewInclude
  
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

// MARK: - BVReviewSearchQuery: BVQueryStatable
extension BVReviewSearchQuery: BVQueryStatable {
  public typealias Stat = BVReviewStat
  
  @discardableResult
  public func stats(_ for: BVReviewStat) -> Self {
    let internalStat: BVURLParameter = .stats(`for`, nil)
    add(internalStat)
    return self
  }
}
