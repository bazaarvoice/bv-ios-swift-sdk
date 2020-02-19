//
//
//  BVReviewHighlightsQueryResponse.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public protocol BVReviewHighlightsQueryMeta { }

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
  
  private enum CodingKeys: String, CodingKey {
    case reviewHighlights = "subjects"
  }
}
