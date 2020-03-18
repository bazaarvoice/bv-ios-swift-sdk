//
//
//  ReviewHighlightsQueryable.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVReviewHighlightsQueryValue
internal protocol BVReviewHighlightsQueryValue: BVCustomStringConvertible { }

// MARK: - BVReviewHighlightsQueryPreflightable
internal protocol BVReviewHighlightsQueryPreflightable: BVQueryActionable {
  func reviewHighlightsQueryPreflight(
    _ preflight: BVCompletionWithErrorsHandler?)
}

// MARK: - BVReviewHighlightsQueryPostflightable
internal protocol BVReviewHighlightsQueryPostflightable: BVQueryActionable {
  associatedtype ReviewHighlightsPostflightResult: BVQueryable
  func reviewHighlightsPostflight(_ reviewHighlights: ReviewHighlightsPostflightResult?)
}
