//
//
//  BVReviewHighlights.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVReviewHighlights: BVQueryable {
    
    static var productId: String?
    static var clientId: String?
    
    public static var singularKey: String {
        return "subjects"
    }
    
    public static var pluralKey: String {
        return "subjects"
    }
    
    public let positive: [String: BVReviewHighlight]
    public let negative: [String: BVReviewHighlight]
    
    private enum CodingKeys: String, CodingKey {
        case positive = "positive"
        case negative = "negative"
    }
}

extension BVReviewHighlights: BVQueryableInternal {
    internal static var getResource: String? {
        return BVReviewHighlightsConstants.BVReviewHighlights.getResource + "\(clientId ?? "")/" + "\(productId ?? "")"
    }
}
