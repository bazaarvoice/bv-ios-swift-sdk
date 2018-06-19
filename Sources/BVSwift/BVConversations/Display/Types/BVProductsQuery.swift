//
//
//  BVProductsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVProducts Queries
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/product-catalog/product-display)
public class BVProductsQuery: BVConversationsQuery<BVProduct> {
  
  /// The initializer for BVProductSearchQuery
  public init() {
    super.init(BVProduct.self)
    
    preflightHandler =
      { (completion: BVCompletionWithErrorsHandler?) -> Swift.Void in
        
        /// Here we gather all the product filters that we've already added and
        /// check to make sure that we've added at least 2 unique product
        /// identifiers else we have to error out.
        let productFilters: [String] =
          self.parameters.reduce([]) {
            (result: [String],
            next: BVURLParameter) -> [String] in
            guard case let .filter(filter, _, _) = next,
              let productFilter: BVProductFilter =
              filter as? BVProductFilter,
              case let .productId(id) = productFilter,
              !result.contains(id) else {
                return result
            }
            return result + [id]
        }
        
        if 2 > productFilters.count {
          let errorMessage: String =
            "Adding a single Product ID will cause problems. Please use " +
              "BVProductQuery if you care to get information about a " +
          "singular product."
          let tooFewError: BVConversationsError = .tooFew(errorMessage)
          completion?(tooFewError)
          BVLogger.sharedLogger.error(errorMessage)
          return
        }
        
        completion?(nil)
    }
  }
}

// MARK: - BVProductsQuery: BVQueryFilterable
extension BVProductsQuery: BVQueryFilterable {
  public typealias Filter = BVProductFilter
  public typealias Operator = BVConversationsfiltererator
  
  @discardableResult
  public func filter(_ filter: Filter, op: Operator = .equalTo) -> Self {
    
    /// We have to do *almost* the inverse of BVProductQuery
    let internalFilter: BVURLParameter? = {
      switch filter {
      case .productId:
        return .filter(filter, op, nil)
      case let .answers(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      case let .authors(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      case let .comments(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      case let .questions(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      case let .reviews(typeFilter):
        return .filterType(filter, typeFilter, op, nil)
      default:
        return .filter(filter, op, nil)
      }
    }()
    
    if let subFilter = internalFilter {
      add(subFilter)
    }
    
    return self
  }
}

// MARK: - BVProductsQuery: BVQueryIncludeable
extension BVProductsQuery: BVQueryIncludeable {
  public typealias Include = BVProductInclude
  
  @discardableResult
  public func include(_ include: Include, limit: UInt16 = 10) -> Self {
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

// MARK: - BVProductsQuery: BVQuerySortable
extension BVProductsQuery: BVQuerySortable {
  public typealias Sort = BVProductSort
  public typealias Order = BVConversationsSortOrder
  
  @discardableResult
  public func sort(_ sort: Sort, order: Order) -> Self {
    let internalSort: BVURLParameter = {
      switch sort {
      case let .answers(by):
        return .sortType(sort, by, order, nil)
      case let .authors(by):
        return .sortType(sort, by, order, nil)
      case let .comments(by):
        return .sortType(sort, by, order, nil)
      case let .questions(by):
        return .sortType(sort, by, order, nil)
      case let .reviews(by):
        return .sortType(sort, by, order, nil)
      default:
        return .sort(sort, order, nil)
      }
    }()
    
    add(internalSort)
    return self
  }
}

// MARK: - BVProductsQuery: BVQueryStatable
extension BVProductsQuery: BVQueryStatable {
  public typealias Stat = BVProductStat
  
  @discardableResult
  public func stats(_ for: Stat) -> Self {
    let internalStat: BVURLParameter = .stats(`for`, nil)
    add(internalStat)
    return self
  }
}
