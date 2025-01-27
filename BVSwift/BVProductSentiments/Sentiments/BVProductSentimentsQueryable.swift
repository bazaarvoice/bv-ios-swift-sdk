//
//
//  BVProductSentimentsQueryable.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

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
