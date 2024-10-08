//
//
//  BVFiterReviewQuery.swift
//  BVSwift
//
//  Copyright © 2021 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVFeatureQuery: BVConversationsQuery<BVFeatures> {
  
  /// The Product identifier to query
  public let productId: String?
  
 
  
  /// The initializer for BVReviewQuery
  /// - Parameters:
  ///   - productId: The Product identifier to query

  public init(productId: String) {
    self.productId = productId
   
    
    super.init(BVFeatures.self)
    
    let queryField: BVConversationsProductIdfield =
      BVConversationsProductIdfield(productId)
    let productIdField: BVURLParameter =
      .field(queryField, nil)
    add(productIdField)
  }
}

// MARK: - BVReviewQuery: BVQueryFeatureStatable
extension BVFeatureQuery: BVQueryLanguageStatable {
  @discardableResult
  public func language(_ value: String) -> Self {
    let language: BVURLParameter = .field(BVLanguageStat(value), nil)
    add(language)
    return self
  }
}








