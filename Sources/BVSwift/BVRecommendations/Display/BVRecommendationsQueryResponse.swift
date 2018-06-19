//
//
//  BVRecommendationsQueryResponse.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the meta-data header for queries
public protocol BVRecommendationsQueryMeta {
  
  /// The current version of the API
  var apiVersion: String? { get }
}

/// Public return type for all BVCurations Queries
/// - Note:
/// \
/// The result type must always be a BVQueryable type.
public enum
BVRecommendationsQueryResponse<BVType: BVQueryable>: BVURLRequestableResponse {
  public typealias MetaType = BVRecommendationsQueryMeta
  public typealias ResponseType = [BVType]
  
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
  
  case success(MetaType, ResponseType)
  case failure([Error])
}

internal struct BVRecommendationsQueryResponseInternal
<BVType: BVQueryable>: Codable, BVRecommendationsQueryMeta {
  let apiVersion: String?
  let profile: BVType?
  
  private enum CodingKeys: String, CodingKey {
    case apiVersion = "api_version"
    case profile
  }
}
