//
//
//  BVProductSentimentsResponse.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the meta-data header for queries
/// There is no meta for Review Highlights Query
public protocol BVProductSentimentsQueryMeta { }

/// Public return type for all BVProductSentiments Queries
/// - Note:
/// \
/// The result type must always be a BVQueryable type.
public enum BVProductSentimentsQueryResponse<BVType: BVQueryable>: BVURLRequestableResponse {
    public typealias ResponseType = BVType
    
    public typealias MetaType = BVProductSentimentsQueryMeta
    
    
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

internal struct BVProductSentimentsQueryResponseInternal
<BVType: BVQueryable>: Codable, BVProductSentimentsQueryMeta {
  let productSentiments: BVType?
  let error: String?
    
  private enum CodingKeys: String, CodingKey {
    case productSentiments = "subjects"
    case error = "error"
  }
}
