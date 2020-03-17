//
//
//  BVManagerReviewHighlights.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVManager: BVReviewHighlightsConfiguration
extension BVManager {
  internal static
  var reviewHighlightsConfiguration: BVReviewHighlightsConfiguration? {
    return BVManager.sharedManager.getConfiguration()
  }
}
