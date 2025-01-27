//
//
//  BVProductFeaturesQuery.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVProductFeaturesQuery Queries
public class BVProductFeaturesQuery: BVProductSentimentsQuery<BVProductFeatures> {
        
    /// The product for results to be returned
    public let productId: String?
    /// The limit for the maximum number of results to be returned
    public var limit: Int? = nil

    override var productSentimentsPostflightResultsClosure: ((BVProductSentimentsQuery<BVProductFeatures>.ProductSentimentsPostflightResult?) -> Void)? {
        return { [weak self] (features: BVProductFeatures?) in
            if nil != features,
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
    
    public init(productId: String, limit: Int) {

        self.productId = productId
        self.limit = limit
        
        super.init(BVProductFeatures.self)
        
        let productIdField: BVProductSentimentsQueryProductField =
        BVProductSentimentsQueryProductField(productId)
        add(.field(productIdField, nil))
        
        let limitField: BVProductSentimentsQueryLimitField =
        BVProductSentimentsQueryLimitField(limit)
        add(.field(limitField, nil))
    }
}

// MARK: - BVSummarisedFeaturesQuotesQuery: BVQueryLanguageStatable
extension BVProductFeaturesQuery: BVQueryLanguageStatable {
    @discardableResult
    public func language(_ value: String) -> Self {
        let language: BVURLParameter = .field(BVLanguageStats(value), nil)
        add(language)
        return self
    }
}
