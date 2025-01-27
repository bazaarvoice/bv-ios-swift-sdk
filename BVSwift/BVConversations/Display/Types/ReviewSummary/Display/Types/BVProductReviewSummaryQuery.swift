//
//
//  BVProductReviewSummaryQuery.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVProductReviewHighlights Queries
public class BVProductReviewSummaryQuery: BVReviewSummaryQuery<BVReviewSummary> {
        
    public let productId: String?
    
    override var reviewSummaryPostflightResultsClosure: ((BVReviewSummary?) -> Void)? {
        return { [weak self] (reviewSummary: BVReviewSummary?) in
                let reviewHighlightsFeatureEvent: BVAnalyticsEvent =
                    .feature(
                        bvProduct: .reviews,
                        name: .reviewSummary,
                        productId: self?.productId ?? "",
                        brand: nil,
                        additional: nil)
                
                BVPixel.track(
                    reviewHighlightsFeatureEvent,
                    analyticConfiguration: self?.configuration?.analyticsConfiguration)
        }
    }
    
    public init(productId: String) {

        self.productId = productId
        
        super.init(BVReviewSummary.self)
        
        let queryField: BVConversationsProductIdfield =
          BVConversationsProductIdfield(productId)
        let productIdField: BVURLParameter =
          .field(queryField, nil)
        add(productIdField)
    }
}
