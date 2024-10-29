//
//
//  BVProductFeatures.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVProductFeatures
public struct BVProductFeatures: BVQueryable {
    public static var singularKey: String = ""
    
    public static var pluralKey: String = ""
    
    public let features: [BVProductFeature]?
    public let status: Int?
    public let title: String?
    public let detail: String?
    public let type: String?
    public let instance: String?

}

extension BVProductFeatures: BVQueryableInternal {
    internal static var getResource: String? {
        return BVProductSentimentsConstants.BVProductFeatures.getResource
    }
}

// MARK: - BVProductFeatures
public struct BVProductFeature: Codable {
    public var feature: String?
    public let featureID: String?
    public let percentPositive: Int?
    public let nativeFeature: String?
    public let reviewsMentioned, averageRatingReviews: AverageRatingReviews?
    public let embedded: BVQuotes?

    enum CodingKeys: String, CodingKey {
        case featureID = "featureId"
        case feature, percentPositive, nativeFeature, reviewsMentioned, averageRatingReviews
        case embedded = "_embedded"
    }
}


// MARK: - AverageRatingReviews
public struct AverageRatingReviews: Codable {
    let positive: Double?
    let negative, incentivized: Int?
    let total: Int?
}
