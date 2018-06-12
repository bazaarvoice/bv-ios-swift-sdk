//
//
//  BVManagerCurationsQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the gestalt of query requests. To be used as a vehicle to
/// generate types which are likely generative of all of the query types.
public protocol BVCurationsQueryGenerator {
  
  /// Generator for BVAuthorQuery
  /// - Parameters:
  ///   - authorId: Author id to query against
  func query(
    _ displayTags: [String]?, limit: UInt16) -> BVCurationsFeedItemQuery?
}


/// BVManager's conformance to the BVCurationsQueryGenerator protocol
/// - Note:
/// \
/// This is a convenience extension to generate already preconfigured
/// query types. It's also an abstraction layer to allow for easier
/// integration with any future advamcements made in the configuration layer
/// instead of having to manually configure each type.
extension BVManager: BVCurationsQueryGenerator {
  public func query(
    _ displayTags: [String]? = nil,
    limit: UInt16 = 10) -> BVCurationsFeedItemQuery? {
    guard let config: BVCurationsConfiguration =
      BVManager.curationsConfiguration else {
        return nil
    }
    return BVCurationsFeedItemQuery(displayTags, limit: limit)
      .configure(config)
  }
}
