//
//
//  ReviewHighlightsQueryable.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVRecommendationsQueryValue
internal protocol BVReviewHighlightsQueryValue: BVCustomStringConvertible { }

// MARK: - BVRecommendationsQueryPreflightable
internal protocol BVReviewHighlightsQueryPreflightable: BVQueryActionable {
  func reviewHighlightsQueryPreflight(
    _ preflight: BVCompletionWithErrorsHandler?)
}

// MARK: - BVRecommendationsQueryPostflightable
internal protocol BVReviewHighlightsQueryPostflightable: BVQueryActionable {
  associatedtype ReviewHighlightsPostflightResult: BVQueryable
  func reviewHighlightsPostflight(_ results: [ReviewHighlightsPostflightResult]?)
}
