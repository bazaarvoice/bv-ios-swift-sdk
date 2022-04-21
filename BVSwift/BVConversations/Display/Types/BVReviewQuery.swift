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
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/reviews)
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
    
    let productFilter: BVURLParameter =
      .filter(
        BVCommentFilter.productId(productId),
        BVConversationsFilterOperator.equalTo,
        nil)
    
    add(productFilter)
    
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
  final internal override
  var queryPreflightResultsClosure: BVURLRequestablePreflightHandler? {
    return {
      [weak self] (completion: BVCompletionWithErrorsHandler?) -> Void in
      
      guard let parameters = self?.parameters else {
        /// Should we error here?
        completion?(nil)
        return
      }
      
      var hasProductInclude: Bool = false
      var hasFilteredInclude: Bool = false
      
      parameters.forEach {
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
    ([BVReview]?) -> Void)? {
    return { [weak self] (results: [BVReview]?) in
      if let reviews = results,
        let firstReview = reviews.first,
        let productId = self?.productId {
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
              self?.configuration?.analyticsConfiguration)
          }
        }
        
        if let product: BVProduct = firstReview.products?
          .filter({
            guard let id: String = $0.productId else {
              return false
            }
            return id == self?.productId
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
            self?.configuration?.analyticsConfiguration)
        }
      }
    }
  }
}

// MARK: - BVReviewQuery: BVQueryFilterable
extension BVReviewQuery: BVQueryFilterable {
  public typealias Filter = BVReviewFilter
  public typealias Operator = BVConversationsFilterOperator
  
  /// The BVReviewQuery's BVQueryFilterable filter() implementation.
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

// MARK: - BVReviewQuery: BVQueryFilteredStatable
extension BVReviewQuery: BVQueryFilteredStatable {
  public typealias FilteredStat = BVReviewFilteredStat
  
  @discardableResult
  public func filter(_ by: FilteredStat) -> Self {
    let internalStat: BVURLParameter = .stats(by, nil)
    add(internalStat, coalesce: true)
    return self
  }
}

// MARK: - BVReviewQuery: BVQueryIncludeable
extension BVReviewQuery: BVQueryIncludeable {
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

// MARK: - BVReviewQuery: BVQuerySortable
extension BVReviewQuery: BVQuerySortable {
  public typealias Sort = BVReviewSort
  public typealias Order = BVConversationsSortOrder
  
  @discardableResult
  public func sort(_ on: Sort, order: Order) -> Self {
    let internalSort: BVURLParameter = .sort(on, order, nil)
    add(internalSort)
    return self
  }
}

// MARK: - BVReviewQuery: BVQueryStatable
extension BVReviewQuery: BVQueryStatable {
  public typealias Stat = BVReviewStat
  
  @discardableResult
  public func stats(_ for: BVReviewStat) -> Self {
    let internalStat: BVURLParameter = .stats(`for`, nil)
    add(internalStat)
    return self
  }
}

// MARK: - BVReviewQuery: BVQueryIncentivizedStatable
extension BVReviewQuery: BVQueryIncentivizedStatable {
  @discardableResult
  public func incentivizedStats(_ value: Bool) -> Self {
    let incentivizedStat: BVURLParameter = .field(BVIncentivizedStats(value), nil)
    add(incentivizedStat, coalesce: false)
    return self
  }
}

// MARK: - BVReviewQuery: BVQueryFeatureStatable
extension BVReviewQuery: BVQueryFeatureStatable {
  @discardableResult
  public func feature(_ value: String) -> Self {
    let featureStat: BVURLParameter = .field(BVFeaturesStats(value), nil)
    add(featureStat)
    return self
  }
}

// MARK: - BVReviewQuery: BVQueryTagStatStatable
extension BVReviewQuery: BVQueryTagStatStatable {
  @discardableResult
  public func tagStats(_ value: Bool) -> Self {
    let tagStat: BVURLParameter = .field(BVTagStats(value), nil)
    add(tagStat, coalesce: false)
    return self
  }
}

// MARK: - BVReviewQuery: BVQuerySecondaryRatingstatable
extension BVReviewQuery: BVQuerySecondaryRatingstatable {
  @discardableResult
  public func secondaryRatingstats(_ value: Bool) -> Self {
    let secondaryRatingstat: BVURLParameter = .field(BVSecondaryRatingStat(value), nil)
    add(secondaryRatingstat, coalesce: false)
    return self
  }
}
