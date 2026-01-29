//
//
//  BVReviewTokens.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
//

/// The definition for the BVReviewTokens type
/// - Note:
/// \
/// It conforms to BVQueryable and, therefore, it is used only for BVQuery.
///


public struct BVReviewTokens: BVQueryable {
    
    public static var singularKey: String {
        return ""
    }
    
    public static var pluralKey: String {
        return ""
    }
    
    public let data: [String]?
    public let status: Int?
    public let type, title, detail: String?
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
        case status = "status"
        case type = "type"
        case title = "title"
        case detail = "detail"
    }
}

// MARK: - BVContentCoach: BVQueryableInternal
extension BVReviewTokens: BVQueryableInternal {
    internal static var getResource: String? {
        return BVConversationsConstants.BVContentCoach.reviewTokensResource
    }
}
