//
//
//  BVProductReviewHighlightsQuery.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

class BVProductReviewHighlightsQuery: BVReviewHighlightsQuery<BVReviewHighlight> {
    
    public var productId: String?
    
    public init(productId: String) {
        self.productId = productId
        super.init(BVReviewHighlights.self)
    } 
}
