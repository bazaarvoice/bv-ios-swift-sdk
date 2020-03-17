//
//
//  BVManagerReviewHighlightsQuery.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public protocol BVReviewHighlightsQueryGenerator {
    
    func query(productId: String) -> BVProductReviewHighlightsQuery?
}

extension BVManager: BVReviewHighlightsQueryGenerator {
    
    public func query(productId: String) -> BVProductReviewHighlightsQuery? {
        guard let config = BVManager.reviewHighlightsConfiguration else {
          return nil
        }
        
        return
          BVProductReviewHighlightsQuery(productId: productId)
            .configure(config)
    }
}
