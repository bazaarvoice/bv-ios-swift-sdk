//
//
//  BVReviewHighlights.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVReviewHighlights type
/// - Note:
/// \
/// It conforms to BVQueryable, therefore, it is used only for
/// BVQuery.
public struct BVReviewHighlights: BVQueryable {
    
    /// Properties required as params for the request
    private static var productId: String?
    private static var clientId: String?
    
    public static var singularKey: String {
        return BVConversationsConstants.BVReviewHighlights.pluralKey
    }
    
    public static var pluralKey: String {
        return BVConversationsConstants.BVReviewHighlights.pluralKey
    }
    
    public let positives: [BVReviewHighlight]?
    public let negatives: [BVReviewHighlight]?
    
    private enum CodingKeys: String, CodingKey {
        case positives = "positive"
        case negatives = "negative"
    }
    
    public static func set(clientId: String, productId: String) {
        BVReviewHighlights.clientId = clientId
        BVReviewHighlights.productId = productId
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Create objects of type BVReviewHighlight and add it to positives array.
        var positiveReviewHighlights: [BVReviewHighlight] = []
        if let positives = try values.decodeIfPresent([String: BVReviewHighlight].self, forKey: .positives) {
            for var positive in positives {
                positive.value.title = positive.key
                positiveReviewHighlights.append(positive.value)
            }
        }
        self.positives = positiveReviewHighlights

        // Create objects of type BVReviewHighlight and add it to negatives array.
        var negativeReviewHighlights: [BVReviewHighlight] = []
        if let negatives = try values.decodeIfPresent([String: BVReviewHighlight].self, forKey: .negatives) {
            for var negative in negatives {
                negative.value.title = negative.key
                negativeReviewHighlights.append(negative.value)
            }
        }
        self.negatives = negativeReviewHighlights
    }
}

extension BVReviewHighlights: BVQueryableInternal {
    internal static var getResource: String? {
        return BVConversationsConstants.BVReviewHighlights.getResource +
            "\(BVReviewHighlights.clientId ?? "")/" +
            "\(BVReviewHighlights.productId ?? "")"
    }
}
