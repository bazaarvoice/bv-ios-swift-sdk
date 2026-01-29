//
//
//  BVMatchedTokens.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
//
//

/// The definition for the BVMatchedTokens type
/// - Note:
/// \
/// It conforms to BVSubmissionable and, therefore, it is used only for BVSubmission.
///


public struct BVMatchedTokens: BVSubmissionable {
    
    public static var singularKey: String {
        return ""
    }
    
    public static var pluralKey: String {
        return ""
    }
    
    public let productId: String?
    public let reviewText: String?
    public let tokens: [String]?
    let status: Int?
    let type: String?
    let title: String?
    let detail: String?
    
    private enum CodingKeys: String, CodingKey {
        case tokens = "data"
        case status = "status"
        case type = "type"
        case title = "title"
        case detail = "detail"
    }
    public func encode(to encoder: Encoder) throws {
        fatalError("What are you doing? This isn't implemented yet.")
    }
    
    public init(from decoder: Decoder) throws {
        productId = nil
        reviewText = nil
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tokens = try container.decodeIfPresent([String].self, forKey: .tokens)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        detail = try container.decodeIfPresent(String.self, forKey: .detail)
    }
    
    public init(productId: String, reviewText: String) {
        self.productId = productId
        self.reviewText = reviewText
        self.tokens = nil
        self.status = nil
        self.type = nil
        self.title = nil
        self.detail = nil
    }
}

// MARK: - BVMatchedTokens: BVSubmissionableInternal
extension BVMatchedTokens: BVSubmissionableInternal {
    
    internal static var postResource: String? {
        return BVConversationsConstants.BVContentCoach.matchedTokensResource
    }
    
    internal func update(_ values: [String: Encodable]?) { }
}
