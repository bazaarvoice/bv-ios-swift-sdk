//
//
//  BVSummarisedFeaturesQuotesQuery.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVSummarisedFeaturesQuotesQuery Queries
public class BVSummarisedFeaturesQuotesQuery: BVProductSentimentsQuery<BVQuotes> {
        
    /// The product for results to be returned
    public let productId: String?
    /// The feature for results to be returned
    public var featureId: String? = nil
    /// The limit for the maximum number of results to be returned
    public var limit: Int? = nil

    override var productSentimentsPostflightResultsClosure: ((BVProductSentimentsQuery<BVQuotes>.ProductSentimentsPostflightResult?) -> Void)? {
        return { [weak self] (quotes: BVQuotes?) in
            if nil != quotes,
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
    
    public init(productId: String, featureId: String, limit: Int) {

        BVSummarisedFeatures.set(featureId: featureId)

        self.productId = productId
        self.featureId = featureId
        self.limit = limit
        
        super.init(BVSummarisedFeatures.self)
        
        let productIdField: BVProductSentimentsQueryProductField =
        BVProductSentimentsQueryProductField(productId)
        add(.field(productIdField, nil))
        
        let limitField: BVProductSentimentsQueryLimitField =
        BVProductSentimentsQueryLimitField(limit)
        add(.field(limitField, nil))
    }
}

// MARK: - BVSummarisedFeaturesQuotesQuery: BVQueryLanguageStatable
extension BVSummarisedFeaturesQuotesQuery: BVQueryLanguageStatable {
    @discardableResult
    public func language(_ value: String) -> Self {
        let language: BVURLParameter = .field(BVLanguageStat(value), nil)
        add(language)
        return self
    }
}
