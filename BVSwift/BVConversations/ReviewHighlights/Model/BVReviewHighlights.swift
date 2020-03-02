//
//
//  BVReviewHighlights.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVReviewHighlights: BVQueryable {
    
    // TODO:- Added as a workaround. Need to figure out a way to pass these properties.
    static var productId: String?
    static var clientId: String?
    
    public static var singularKey: String {
        return "subjects"
    }
    
    public static var pluralKey: String {
        return "subjects"
    }
    
    public let positives: [BVReviewHighlight]?
    public let negatives: [BVReviewHighlight]?
    
    private enum CodingKeys: String, CodingKey {
        case positives = "positive"
        case negatives = "negative"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // TODO:- Review from Cameron on using BVCodableDictionary instead. Need to check on how to set the title though.
        var positiveReviewHighlights: [BVReviewHighlight] = []
        if let positives = try values.decodeIfPresent([String: BVReviewHighlight].self, forKey: .positives) {
            for var positive in positives {
                positive.value.title = positive.key
                positiveReviewHighlights.append(positive.value)
            }
        }
        self.positives = positiveReviewHighlights

        // TODO:- Review from Cameron on using BVCodableDictionary instead. Need to check on how to set the title though.
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
        return BVConversationsConstants.BVReviewHighlights.getResource + "\(clientId ?? "")/" + "\(productId ?? "")"
    }
}
