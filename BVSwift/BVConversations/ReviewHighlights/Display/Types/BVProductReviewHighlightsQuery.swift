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
        
    public let productId: String?
    
    override var reviewHighlightsPostflightResultsClosure: ((BVReviewHighlights?) -> Void)? {
        return { [weak self] (reviewHighlights: BVReviewHighlights?) in
            if nil != reviewHighlights,
              let productId = self?.productId {
              let reviewHighlightsFeatureEvent: BVAnalyticsEvent =
                .feature(
                  bvProduct: .reviews,
                  name: .reviewHighlights,
                  productId: productId,
                  brand: nil,
                  additional: nil)
                
              BVPixel.track(
                reviewHighlightsFeatureEvent,
                analyticConfiguration: self?.configuration?.analyticsConfiguration)
            }
        }
    }
    
    public init(clientId: String, productId: String) {

        BVReviewHighlights.set(clientId: clientId, productId: productId)
        
        self.productId = productId
        
        super.init(BVReviewHighlights.self)
    }
}
