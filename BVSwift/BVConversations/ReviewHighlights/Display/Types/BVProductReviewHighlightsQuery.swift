//
//
//  BVProductReviewHighlightsQuery.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVProductReviewHighlights Queries
public class BVProductReviewHighlightsQuery: BVReviewHighlightsQuery<BVReviewHighlights> {
        
    public init(clientId: String, productId: String) {

        BVReviewHighlights.set(clientId: clientId, productId: productId)
        
        super.init(BVReviewHighlights.self)
    }
}
