//
//
//  BVSummarisedFeature.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVSummarisedFeatures type
/// - Note:
/// \
/// It conforms to BVQueryable, therefore, it is used only for
/// BVQuery.

enum BVSummarisedFeaturesResourceType {
    case getSummarisedFeaturesOnly
    case getSummarisedFeaturesQuotes
}
public struct BVSummarisedFeatures: BVQueryable {
    
    /// Properties required as params for the request
    private static var featureId: String?
    private static var summarisedFeaturesResourceType: BVSummarisedFeaturesResourceType = BVSummarisedFeaturesResourceType.getSummarisedFeaturesOnly
    
    public static var singularKey: String = ""
    
    public static var pluralKey: String = ""
    
    public let bestFeatures, worstFeatures: [BVProductFeature]?
    public let status: Int?
    public let title: String?
    public let detail: String?
    public let type: String?
    public let instance: String?

    private enum CodingKeys: String, CodingKey {
        case bestFeatures = "bestFeatures"
        case worstFeatures = "worstFeatures"
        case status = "status"
        case title = "title"
        case detail = "detail"
        case type = "type"
        case instance = "instance"
    }
    
    public static func set() {
        BVSummarisedFeatures.featureId = nil
        BVSummarisedFeatures.summarisedFeaturesResourceType = .getSummarisedFeaturesOnly
    }
    
    public static func set(featureId: String) {
        BVSummarisedFeatures.featureId = featureId
        BVSummarisedFeatures.summarisedFeaturesResourceType = .getSummarisedFeaturesQuotes
    }
}

extension BVSummarisedFeatures: BVQueryableInternal {
    internal static var getResource: String? {
        switch BVSummarisedFeatures.summarisedFeaturesResourceType {
        case .getSummarisedFeaturesOnly:
            return BVProductSentimentsConstants.BVSummarisedFeatures.getResource
        case .getSummarisedFeaturesQuotes:
            return BVProductSentimentsConstants.BVSummarisedFeatures.getResource + "/" + (featureId ?? "") + "/" + BVProductSentimentsConstants.BVSummarisedFeaturesQuotes.getResource
        }
    }
}
