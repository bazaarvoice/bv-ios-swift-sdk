//
//
//  BVRecommendationsQueryable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the primitive query filter types
public protocol BVRecommendationsQueryFilter: CustomStringConvertible {
  var representedValue: CustomStringConvertible { get }
}

// MARK: - BVRecommendationsQueryValue
internal protocol BVRecommendationsQueryValue:
BVInternalCustomStringConvertible { }

// MARK: - BVRecommendationsQueryPostflightable
internal protocol BVRecommendationsQueryPostflightable: BVQueryActionable {
  associatedtype RecommendationsPostflightResult: BVQueryable
  func recommendationsPostflight(_ results: [RecommendationsPostflightResult]?)
}

// MARK: - BVRecommendationsQueryUpdateable
internal protocol BVRecommendationsQueryUpdateable: BVAuxiliaryable {
  mutating func update(_ any: Any?)
}

// MARK: - BVRecommendationsStatsUpdateable
internal protocol BVRecommendationsQueryStatsUpdateable: BVRecommendationsQueryUpdateable {
  mutating func update(_ stats: BVRecommendationsStats)
}
