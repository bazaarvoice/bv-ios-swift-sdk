//
//
//  BVProductReviewHighlightsQuery.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

class BVProductReviewHighlightsQuery: BVReviewHighlightsQuery<BVReviewHighlights> {
    
    public var productId: String?
    
    public init(productId: String) {
        self.productId = productId
        
        BVReviewHighlights.productId = productId
        BVReviewHighlights.clientId = "1800petmeds"
        
        super.init(BVReviewHighlights.self)
    }
}
