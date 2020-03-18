//
//
//  BVManagerReviewHighlightsQuery.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the gestalt of query requests. To be used as a vehicle to
/// generate types which are likely generative of all of the query types.
public protocol BVReviewHighlightsQueryGenerator {
    
    /// Generator for BVProductReviewHighlightsQuery
    /// - Parameters:
    ///   - clientId: Client id to query against
    ///   - productId: Product id to query against
    func query(clientId: String, productId: String) -> BVProductReviewHighlightsQuery?
}

/// BVManager's conformance to the BVReviewHighlightsQueryGenerator protocol
/// - Note:
/// \
/// This is a convenience extension to generate already preconfigured
/// query types. It's also an abstraction layer to allow for easier
/// integration with any future advamcements made in the configuration layer
/// instead of having to manually configure each type.
extension BVManager: BVReviewHighlightsQueryGenerator {
    
    public func query(clientId: String, productId: String) -> BVProductReviewHighlightsQuery? {
        guard let config = BVManager.reviewHighlightsConfiguration else {
          return nil
        }
        
        return
            BVProductReviewHighlightsQuery(clientId: clientId, productId: productId)
            .configure(config)
    }
}
