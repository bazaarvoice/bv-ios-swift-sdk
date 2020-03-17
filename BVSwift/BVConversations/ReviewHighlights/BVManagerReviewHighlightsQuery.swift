//
//
//  BVManagerReviewHighlightsQuery.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public protocol BVReviewHighlightsQueryGenerator {
    
    func query(clientId: String, productId: String) -> BVProductReviewHighlightsQuery?
}

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
