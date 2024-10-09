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
        
    public let productId: String?
    
    override var productSentimentsPostflightResultsClosure: ((BVProductSentimentsQuery<BVSummarisedFeatures>.ProductSentimentsPostflightResult?) -> Void)? {
        return { [weak self] (summarisedFeatures: BVSummarisedFeatures?) in
            if nil != summarisedFeatures,
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
    
    public init(productId: String) {

        BVSummarisedFeatures.set(productId: productId)
        
        self.productId = productId
        
        super.init(BVSummarisedFeatures.self)
    }
}

// MARK: - BVSummarisedFeaturesQuery: BVQueryLanguageStatable
extension BVSummarisedFeaturesQuery: BVQueryLanguageStatable {
    @discardableResult
    public func language(_ value: String) -> Self {
        let language: BVURLParameter = .field(BVLanguageStat(value), nil)
        add(language)
        return self
    }
}

// MARK: - BVSummarisedFeaturesQuery: BVQueryEmbedStatable
extension BVSummarisedFeaturesQuery: BVQueryEmbedStatable {
    @discardableResult
    public func embed(_ value: String) -> Self {
        let embed: BVURLParameter = .field(BVEmbedStats(value), nil)
        add(embed)
        return self
    }
}

internal struct BVEmbedStats: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
        return BVConversationsConstants.BVQueryType.Keys.tagStats
    }
    
    var representedValue: CustomStringConvertible {
        return value
    }
    
    var description: String {
        return internalDescription
    }
    
    init(_ _value: String) {
        value = "\(_value)"
    }
}
