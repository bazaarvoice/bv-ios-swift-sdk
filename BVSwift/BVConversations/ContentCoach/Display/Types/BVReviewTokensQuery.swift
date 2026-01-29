//
//
//  BVReviewTokensQuery.swift
//  BVSwift
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVReviewTokensQuery: BVContentCoachQuery<BVReviewTokens> {
    
    /// The Product identifier to query
    public let productId: String?
    
    /// The initializer for BVReviewTokensQuery
    /// - Parameters:
    ///   - productId: The Product identifier to query
    
    public init(productId: String) {
        self.productId = productId
        
        
        super.init(BVReviewTokens.self)
        
        let queryField: BVContentCoachProductIdfield =
        BVContentCoachProductIdfield(productId)
        let productIdField: BVURLParameter =
            .field(queryField, nil)
        add(productIdField)
    }
}
