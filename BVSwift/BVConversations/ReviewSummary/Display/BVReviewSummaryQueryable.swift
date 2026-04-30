//
//
//  BVReviewSummaryQueryable.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVReviewSummaryQueryPreflightable
internal protocol BVReviewSummaryQueryPreflightable: BVQueryActionable {
  func reviewSummaryQueryPreflight(
    _ preflight: BVCompletionWithErrorsHandler?)
}

// MARK: - BVReviewSummaryQueryPostflightable
internal protocol BVReviewSummaryQueryPostflightable: BVQueryActionable {
  associatedtype ReviewSummaryPostflightResult: BVQueryable
  func reviewSummaryPostflight(_ reviewSummary: ReviewSummaryPostflightResult?)
}

// MARK: - BVReviewSummaryProductIdfield
internal struct BVReviewSummaryProductIdfield: BVQueryField {
  private let value: CustomStringConvertible
  
  var internalDescription: String {
    return BVConversationsConstants.BVQueryType.Keys.productId
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
