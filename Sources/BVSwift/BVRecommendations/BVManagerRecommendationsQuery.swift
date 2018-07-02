//
//
//  BVManagerRecommendationsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the gestalt of query requests. To be used as a vehicle to
/// generate types which are likely generative of all of the query types.
public protocol BVRecommendationsQueryGenerator {
  
  /// Generator for BVRecommendationsProfileQuery
  /// - Parameters:
  ///   - limit: The max amout of results to return
  func query(_ limit: UInt16) -> BVRecommendationsProfileQuery?
}


/// BVManager's conformance to the BVRecommendationsQueryGenerator protocol
/// - Note:
/// \
/// This is a convenience extension to generate already preconfigured
/// query types. It's also an abstraction layer to allow for easier
/// integration with any future advamcements made in the configuration layer
/// instead of having to manually configure each type.
extension BVManager: BVRecommendationsQueryGenerator {
  public func query(_ limit: UInt16 = 10) -> BVRecommendationsProfileQuery? {
    guard let config: BVRecommendationsConfiguration =
      BVManager.recommendationsConfiguration else {
        return nil
    }
    return BVRecommendationsProfileQuery(limit)
      .configure(config)
  }
}
