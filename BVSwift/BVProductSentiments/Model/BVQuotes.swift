//
//
//  BVQuotes.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVQuotes
public struct BVQuotes: BVQueryable {
    public static var singularKey: String = ""
    
    public static var pluralKey: String = ""
    
    public let quotes: [BVQuote]?
    public let status: Int?
    public let title: String?
    public let detail: String?
    public let type: String?
    public let instance: String?
}

extension BVQuotes: BVQueryableInternal {
    internal static var getResource: String? {
        return BVProductSentimentsConstants.BVQuotes.getResource
    }
}


// MARK: - BVQuote
public struct BVQuote: BVQueryable {
    public static var singularKey: String {
        return ""
    }
    
    public static var pluralKey: String {
        return ""
    }
    
    public let quoteID, text, emotion: String?
    public let reviewRating: Int?
    public let reviewID, reviewedAt, translatedText, nativeLanguage: String?
    public let incentivised: Bool?
    public let reviewType: String?

    enum CodingKeys: String, CodingKey {
        case quoteID = "quoteId"
        case text, emotion, reviewRating
        case reviewID = "reviewId"
        case reviewedAt, translatedText, nativeLanguage, incentivised, reviewType
    }
}
