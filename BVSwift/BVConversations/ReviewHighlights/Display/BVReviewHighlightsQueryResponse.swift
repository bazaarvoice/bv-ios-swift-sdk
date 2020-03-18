//
//
//  BVReviewHighlightsQueryResponse.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the meta-data header for queries
/// There is no meta for Review Highlights Query
public protocol BVReviewHighlightsQueryMeta { }

/// Public return type for all BVReviewHighlights Queries
/// - Note:
/// \
/// The result type must always be a BVQueryable type.
public enum BVReviewHighlightsQueryResponse<BVType: BVQueryable>: BVURLRequestableResponse {
    public typealias ResponseType = BVType
    
    public typealias MetaType = BVReviewHighlightsQueryMeta
    
    
    /// Success state of the query, a.k.a, no errors.
    public var success: Bool {
      guard case .success = self else {
        return false
      }
      return true
    }
    
    /// Failure case returned errors.
    public var errors: [Error]? {
      guard case let .failure(errors) = self else {
        return nil
      }
      return errors
    }
    
    case success(ResponseType)
    case failure([Error])
}

internal struct BVReviewHighlightsQueryResponseInternal
<BVType: BVQueryable>: Codable, BVReviewHighlightsQueryMeta {
  let reviewHighlights: BVType?
  let error: String?
    
  private enum CodingKeys: String, CodingKey {
    case reviewHighlights = "subjects"
    case error = "error"
  }
}
