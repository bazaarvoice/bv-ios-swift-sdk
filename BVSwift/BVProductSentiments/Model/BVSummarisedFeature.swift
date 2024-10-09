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
public struct BVSummarisedFeatures: BVQueryable {
    
    /// Properties required as params for the request
    private static var productId: String?
    
    public static var singularKey: String {
        return BVProductSentimentsConstants.BVSummarisedFeatures.singularKey
    }
    
    public static var pluralKey: String {
        return BVProductSentimentsConstants.BVSummarisedFeatures.pluralKey
    }
    
    public let bestFeatures, worstFeatures: [BVReviewFeature]?

    private enum CodingKeys: String, CodingKey {
        case bestFeatures = "bestFeatures"
        case worstFeatures = "worstFeatures"
    }
    
    public static func set(productId: String) {
        BVSummarisedFeatures.productId = productId
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Create objects of type BVReviewFeature and add it to bestFeatures array.
        var bestFeatures: [BVReviewFeature] = []
        if let features = try values.decodeIfPresent([String: BVReviewFeature].self, forKey: .bestFeatures) {
            for var feature in features {
                feature.value.feature = feature.key
                bestFeatures.append(feature.value)
            }
        }
        
//        //Sort by MentionsCount
//        bestFeatures.sort {
//            guard let mentionsCount0 = $0.mentionsCount, let mentionsCount1 = $1.mentionsCount else { return false }
//            return mentionsCount0 > mentionsCount1
//        }
//        
        self.bestFeatures = bestFeatures
        
        // Create objects of type BVReviewFeature and add it to negatives array.
        var worstFeatures: [BVReviewFeature] = []
        if let features = try values.decodeIfPresent([String: BVReviewFeature].self, forKey: .worstFeatures) {
            for var feature in features {
                feature.value.feature = feature.key
                worstFeatures.append(feature.value)
            }
        }
        
//        //Sort by MentionsCount
//        negativeReviewHighlights.sort {
//            guard let mentionsCount0 = $0.mentionsCount, let mentionsCount1 = $1.mentionsCount else { return false }
//            return mentionsCount0 > mentionsCount1
//            
//        }
        
        self.worstFeatures = worstFeatures
    }
}

extension BVSummarisedFeatures: BVQueryableInternal {
    //https://[stg.]api.bazaarvoice.com/sentiment/v1/summarised-features?productId=1000004682&embed=quotes&language=de
    internal static var getResource: String? {
        return BVProductSentimentsConstants.BVSummarisedFeatures.getResource +
//        BVProductSentimentsConstants.BVSummarisedFeatures.Keys.passKey + (BVSummarisedFeatures.clientId ?? "") +
        BVProductSentimentsConstants.BVSummarisedFeatures.Keys.productId + "\(BVSummarisedFeatures.productId ?? "")/"
    }
}

// MARK: - Feature
public struct BVReviewFeature: Codable {
    var feature: String?
    let featureID: String?
    let percentPositive: Int?
    let nativeFeature: String?
    let reviewsMentioned, averageRatingReviews: AverageRatingReviews?
    let embedded: Embedded?

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

// MARK: - Embedded
public struct Embedded: Codable {
    let quotes: [Quote]?
}

// MARK: - Quote
public struct Quote: Codable {
    let quoteID, text, emotion: String?
    let reviewRating: Int?
    let reviewID, reviewedAt, translatedText, nativeLanguage: String?
    let incentivised: Bool?
    let reviewType: String?

    enum CodingKeys: String, CodingKey {
        case quoteID = "quoteId"
        case text, emotion, reviewRating
        case reviewID = "reviewId"
        case reviewedAt, translatedText, nativeLanguage, incentivised, reviewType
    }
}

// MARK: - Expressions
public struct Expressions: Codable {
    let nativeFeature: String?
    let expressions: [String]?
}
