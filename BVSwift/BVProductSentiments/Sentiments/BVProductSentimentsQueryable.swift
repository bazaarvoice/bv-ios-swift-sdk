//
//
//  BVProductSentimentsQueryable.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol definition for the Summarised Features includable instances
public protocol BVSummarisedFeaturesIncludable: BVQueryable {
  var summarisedFeatures: BVSummarisedFeatures? { get }
}

/// Protocol definition for the Summarised Features Quotes includable instances
public protocol BVSummarisedFeaturesQuotesIncludable: BVQueryable {
  var summarisedFeaturesQuotes: [Quote]? { get }
}

/// Protocol definition for the Product Features includable instances
public protocol BVProductFeaturesIncludable: BVQueryable {
  var productFeatures: [BVReviewFeature]? { get }
}

/// Protocol definition for the Product Quotes includable instances
public protocol BVProductQuotesIncludable: BVQueryable {
  var productQuotes: [Quote]? { get }
}

/// Protocol definition for the Product Expressions includable instances
public protocol BVProductExpressionsIncludable: BVQueryable {
  var questions: [Expressions]? { get }
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
