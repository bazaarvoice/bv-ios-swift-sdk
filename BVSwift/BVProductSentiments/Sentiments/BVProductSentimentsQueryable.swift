//
//
//  BVProductSentimentsQueryable.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation
//todo
/// Protocol definition for the Summarised Features includable instances
public protocol BVSummarisedFeaturesIncludable: BVQueryable {
  var summarisedFeatures: BVSummarisedFeatures? { get }
}

/// Protocol definition for the Summarised Features Quotes includable instances
public protocol BVSummarisedFeaturesQuotesIncludable: BVQueryable {
  var summarisedFeaturesQuotes: [BVQuote]? { get }
}

/// Protocol definition for the Product Features includable instances
public protocol BVProductFeaturesIncludable: BVQueryable {
  var productFeatures: [BVProductFeatures]? { get }
}

/// Protocol definition for the Product Quotes includable instances
public protocol BVProductQuotesIncludable: BVQueryable {
  var productQuotes: [BVQuote]? { get }
}

/// Protocol definition for the Product Expressions includable instances
public protocol BVProductExpressionsIncludable: BVQueryable {
  var questions: [BVExpressions]? { get }
}

// MARK: - BVProductSentimentsQueryValue
internal protocol BVProductSentimentsQueryValue: BVCustomStringConvertible { }

// MARK: - BVProductSentimentsQueryPreflightable
internal protocol BVProductSentimentsQueryPreflightable: BVQueryActionable {
  func productSentimentsQueryPreflight(
    _ preflight: BVCompletionWithErrorsHandler?)
}

// MARK: - BVProductSentimentsQueryPostflightable
internal protocol BVProductSentimentsQueryPostflightable: BVQueryActionable {
  associatedtype ProductSentimentsPostflightResult: BVQueryable
  func productSentimentsPostflight(_ productSentiments: ProductSentimentsPostflightResult?)
}

// MARK: - BVProductSentimentsQueryProductField
internal struct BVProductSentimentsQueryProductField: BVQueryField {
  private let value: CustomStringConvertible
  
  var internalDescription: String {
      return BVProductSentimentsConstants.BVQueryType.Keys.productId
  }
  
  var representedValue: CustomStringConvertible {
    return value
  }
  
  var description: String {
    return internalDescription
  }
  
  init(_ productId: String) {
    value = productId
  }
}

// MARK: - BVProductSentimentsQueryLimitField
internal struct BVProductSentimentsQueryLimitField: BVQueryField {
  private let value: CustomStringConvertible
  
  var internalDescription: String {
      return BVProductSentimentsConstants.BVQueryType.Keys.limit
  }
  
  var representedValue: CustomStringConvertible {
    return value
  }
  
  var description: String {
    return internalDescription
  }
  
  init(_ limit: Int) {
    value = limit
  }
}

// MARK: - BVProductSentimentsQueryFeatureField
internal struct BVProductSentimentsQueryFeatureField: BVQueryField {
  private let value: CustomStringConvertible
  
  var internalDescription: String {
      return BVProductSentimentsConstants.BVQueryType.Keys.feature
  }
  
  var representedValue: CustomStringConvertible {
    return value
  }
  
  var description: String {
    return internalDescription
  }
  
  init(_ limit: String) {
    value = limit
  }
}
