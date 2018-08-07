//
//
//  BVProductQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVProduct Queries
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/product-catalog/product-display)
public class BVProductQuery: BVConversationsQuery<BVProduct> {
  
  /// The Product identifier to query
  public let productId: String?
  
  /// The initializer for BVProductQuery
  /// - Parameters:
  ///   - productId: The Product identifier to query
  public init(productId: String) {
    self.productId = productId
    
    super.init(BVProduct.self)
    
    let productFilter: BVURLParameter =
      .filter(
        BVProductFilter.productId(productId),
        BVConversationsfiltererator.equalTo,
        nil)
    
    add(productFilter)
  }
  
  /// Internal
  final internal override var queryPostflightResultsClosure: (([BVProduct]?) -> Swift.Void)? {
    return { (results: [BVProduct]?) in
      if let product = results?.first,
        let productId = self.productId {
        
        if let reviews = product.reviews {
          for review in reviews {
            if let productId = review.productId,
              let reviewId = review.reviewId,
              let product = review.products?.filter({
                guard let id = $0.productId else {
                  return false
                }
                return productId == id
              }).first {
              
              let reviewImpressionEvent: BVAnalyticsEvent =
                .impression(
                  bvProduct: .reviews,
                  contentId: reviewId,
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
        }
        
        if let questions = product.questions {
          for question in questions {
            if let productId = question.productId,
              let questionId = question.questionId,
              let categoryId = question.categoryId {
              
              let questionImpressionEvent: BVAnalyticsEvent =
                .impression(
                  bvProduct: .question,
                  contentId: questionId,
                  contentType: .question,
                  productId: productId,
                  brand: nil,
                  categoryId: categoryId,
                  additional: nil)
              
              BVPixel.track(
                questionImpressionEvent,
                analyticConfiguration:
                self.configuration?.analyticsConfiguration)
            }
          }
        }
        
        let productPageView: BVAnalyticsEvent =
          .pageView(
            bvProduct: .reviews,
            productId: productId,
            brand: product.brand?.brandId,
            categoryId: nil,
            rootCategoryId: nil,
            additional: nil)
        
        BVPixel.track(
          productPageView,
          analyticConfiguration: self.configuration?.analyticsConfiguration)
      }
    }
  }
}

// MARK: - BVProductQuery: BVQueryFilterable
extension BVProductQuery: BVQueryFilterable {
  public typealias Filter = BVProductFilter
  public typealias Operator = BVConversationsfiltererator
  
  @discardableResult
  public func filter(_ by: Filter, op: Operator = .equalTo) -> Self {
    
    /// We don't allow regular product filters since that wouldn't make sense
    /// for a product display request.
    let internalFilter: BVURLParameter? = {
      switch by {
      case let .answers(typeFilter):
        return .filterType(by, typeFilter, op, nil)
      case let .authors(typeFilter):
        return .filterType(by, typeFilter, op, nil)
      case let .comments(typeFilter):
        return .filterType(by, typeFilter, op, nil)
      case let .questions(typeFilter):
        return .filterType(by, typeFilter, op, nil)
      case let .reviews(typeFilter):
        return .filterType(by, typeFilter, op, nil)
      default:
        return nil
      }
    }()
    
    if let subFilter = internalFilter {
      add(subFilter)
    }
    
    return self
  }
}

// MARK: - BVProductQuery: BVQueryIncludeable
extension BVProductQuery: BVQueryIncludeable {
  public typealias Include = BVProductInclude
  
  @discardableResult
  public func include(_ kind: Include, limit: UInt16 = 10) -> Self {
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

// MARK: - BVProductQuery: BVQuerySortable
extension BVProductQuery: BVQuerySortable {
  public typealias Sort = BVProductSort
  public typealias Order = BVConversationsSortOrder
  
  @discardableResult
  public func sort(_ on: Sort, order: Order) -> Self {
    let internalSort: BVURLParameter = {
      switch on {
      case let .answers(by):
        return .sortType(on, by, order, nil)
      case let .authors(by):
        return .sortType(on, by, order, nil)
      case let .comments(by):
        return .sortType(on, by, order, nil)
      case let .questions(by):
        return .sortType(on, by, order, nil)
      case let .reviews(by):
        return .sortType(on, by, order, nil)
      default:
        return .sort(on, order, nil)
      }
    }()
    
    add(internalSort)
    return self
  }
}

// MARK: - BVProductQuery: BVQueryStatable
extension BVProductQuery: BVQueryStatable {
  public typealias Stat = BVProductStat
  
  @discardableResult
  public func stats(_ for: Stat) -> Self {
    let internalStat: BVURLParameter = .stats(`for`, nil)
    add(internalStat)
    return self
  }
}
