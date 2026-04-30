//
//
//  BVReviewSummaryQueryResponse.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the meta-data header for ReviewSummaryQuery
public protocol BVReviewSummaryQueryResponseMetaData { }

/// Public return type for all BVConversation Queries
/// - Note:
/// \
/// The result type must always be a BVQueryable type.
public enum BVReviewSummaryQueryResponse
<BVType: BVQueryable>: BVURLRequestableResponse {
    public typealias ResponseType = BVType
    public typealias MetaType = BVReviewSummaryQueryResponseMetaData
    
    public var success: Bool {
        guard case .success = self else {
            return false
        }
        return true
    }
    
    public var errors: [Error]? {
        guard case let .failure(errors) = self else {
            return nil
        }
        return errors
    }
    
    case success(ResponseType)
    case failure([Error])
}
