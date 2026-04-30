//
//
//  BVReviewSummary.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVReviewSummary type
/// - Note:
/// \
/// It conforms to BVQueryable and, therefore, it is used only for BVQuery.
///

public struct BVReviewSummary: BVQueryable {
  
  public static var singularKey: String {
    return BVConversationsConstants.BVReviewSummary.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVReviewSummary.pluralKey
  }
    
  public let summary: String?
  public let status: Int?
  public let type, title, detail, disclaimer: String?

  private enum CodingKeys: String, CodingKey {
    case summary = "summary"
    case status = "status"
    case type = "type"
    case title = "title"
    case detail = "detail"
    case disclaimer = "disclaimer"
  }
}

// MARK: - BVReviewSummary: BVQueryableInternal
extension BVReviewSummary: BVQueryableInternal {
  internal static var getResource: String? {
    return BVConversationsConstants.BVReviewSummary.getResource
  }
}
