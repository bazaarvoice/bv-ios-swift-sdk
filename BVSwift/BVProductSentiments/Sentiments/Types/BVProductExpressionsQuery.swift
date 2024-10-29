//
//
//  BVProductExpressionsQuery.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVProductExpressionsQuery Queries
public class BVProductExpressionsQuery: BVProductSentimentsQuery<BVExpressions> {
        
    /// The product for results to be returned
    public let productId: String?
    /// The feature for results to be returned
    public let feature: String?
    /// The limit for the maximum number of results to be returned
    public var limit: Int? = nil

    override var productSentimentsPostflightResultsClosure: ((BVProductSentimentsQuery<BVExpressions>.ProductSentimentsPostflightResult?) -> Void)? {
        return { [weak self] (expressions: BVExpressions?) in
            if nil != expressions,
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
    
    public init(productId: String, feature: String, limit: Int) {

        self.productId = productId
        self.feature = feature
        self.limit = limit
        
        super.init(BVExpressions.self)
        
        let productIdField: BVProductSentimentsQueryProductField =
        BVProductSentimentsQueryProductField(productId)
        add(.field(productIdField, nil))
       
        let featureField: BVProductSentimentsQueryFeatureField =
        BVProductSentimentsQueryFeatureField(feature)
        add(.field(featureField, nil))
        
        let limitField: BVProductSentimentsQueryLimitField =
        BVProductSentimentsQueryLimitField(limit)
        add(.field(limitField, nil))
    }
}

// MARK: - BVSummarisedFeaturesQuotesQuery: BVQueryLanguageStatable
extension BVProductExpressionsQuery: BVQueryLanguageStatable {
    @discardableResult
    public func language(_ value: String) -> Self {
        let language: BVURLParameter = .field(BVLanguageStat(value), nil)
        add(language)
        return self
    }
}
