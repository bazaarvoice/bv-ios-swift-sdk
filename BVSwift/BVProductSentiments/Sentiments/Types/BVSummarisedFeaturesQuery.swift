//
//
//  BVSummarisedFeaturesQuery.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation


/// Public class for handling BVSummarisedFeatures Queries
public class BVSummarisedFeaturesQuery: BVProductSentimentsQuery<BVSummarisedFeatures> {
        
    /// The product for results to be returned
    public let productId: String?

    override var productSentimentsPostflightResultsClosure: ((BVProductSentimentsQuery<BVSummarisedFeatures>.ProductSentimentsPostflightResult?) -> Void)? {
        return { [weak self] (summarisedFeatures: BVSummarisedFeatures?) in
            if nil != summarisedFeatures,
              let productId = self?.productId {
              let reviewHighlightsFeatureEvent: BVAnalyticsEvent =
                .feature(
                  bvProduct: .productSentiments,
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
    
    public init(productId: String) {

        BVSummarisedFeatures.set()
        
        self.productId = productId
        
        super.init(BVSummarisedFeatures.self)
        
        let productIdField: BVProductSentimentsQueryProductField =
        BVProductSentimentsQueryProductField(productId)
        add(.field(productIdField, nil))
    }
}

// MARK: - BVSummarisedFeaturesQuery: BVQueryLanguageStatable
extension BVSummarisedFeaturesQuery: BVQueryLanguageStatable {
    @discardableResult
    public func language(_ value: String) -> Self {
        let language: BVURLParameter = .field(BVLanguageStats(value), nil)
        add(language)
        return self
    }
}

extension BVSummarisedFeaturesQuery {
    public func embed(_ value: BVEmbedStatsType) -> Self {
        let embed: BVURLParameter = .field(BVEmbedStats(value), nil)
        add(embed)
        return self
    }
}
