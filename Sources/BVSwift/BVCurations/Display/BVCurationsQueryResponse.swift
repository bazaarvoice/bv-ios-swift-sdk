//
//
//  BVCurationsQueryResponse.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Protocol defining the meta-data header for queries
public protocol BVCurationsQueryMetaData {
  
  /// The code for the result of the query
  var code: Int? { get }
  
  /// The limit used in the query
  var limit: UInt16? { get }
  
  /// The offset used in the query
  var offset: UInt16? { get }
  
  /// The total returned results of the query
  var returnedResults: UInt16? { get }
  
  /// The status for the request
  var status: String? { get }
  
  /// The total returned results of the query
  var totalResults: UInt? { get }
}

/// Public return type for all BVCurations Queries
/// - Note:
/// \
/// The result type must always be a BVQueryable type.
public enum
BVCurationsQueryResponse<BVType: BVQueryable>: BVURLRequestableResponse {
  public typealias ResponseType = [BVType]
  public typealias MetaType = BVCurationsQueryMetaData
  
  /// Success state of the query, a.k.a, no errors.
  public var success: Bool {
    get {
      guard case .success = self else {
        return false
      }
      return true
    }
  }
  
  /// Failure case returned errors.
  public var errors: [Error]? {
    get {
      guard case let .failure(errors) = self else {
        return nil
      }
      return errors
    }
  }
  
  case success(MetaType, ResponseType)
  case failure([Error])
}

internal struct BVCurationsQueryResponseInternal
<BVType: BVQueryable>: Codable, BVCurationsQueryMetaData {
  let code: Int?
  let errors: [BVCurationsError]?
  let limit: UInt16?
  let offset: UInt16?
  private let productData: BVCodableDictionary<BVCurationsProduct>?
  let results: [BVType]?
  let returnedResults: UInt16?
  let status: String?
  let totalResults: UInt?
  
  private enum CodingKeys: String, CodingKey {
    case code = "code"
    case errors = "errors"
    case options = "options"
    case productData = "productData"
    case returnedResults = "results"
    case status = "status"
    case statusCode
    case totalResults = "total"
    case updates = "updates"
  }
  
  private enum OptionCodingKeys: String, CodingKey {
    case limit = "limit"
    case offset = "offset"
  }
  
  private enum ResultCodingKeys: String, CodingKey {
    case data = "data"
  }
  
  func encode(to encoder: Encoder) throws {
    fatalError()
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    /// Do the top level elements
    if let statusCode =
      try container.decodeIfPresent(Int.self, forKey: .statusCode) {
      code = statusCode
    } else {
      code = try container.decodeIfPresent(Int.self, forKey: .code)
    }
    
    errors =
      try container.decodeIfPresent([BVCurationsError].self, forKey: .errors)
    productData =
      try container.decodeIfPresent(
        BVCodableDictionary<BVCurationsProduct>.self,
        forKey: .productData)
    returnedResults =
      try container.decodeIfPresent(UInt16.self, forKey: .returnedResults)
    status = try container.decodeIfPresent(String.self, forKey: .status)
    totalResults =
      try container.decodeIfPresent(UInt.self, forKey: .totalResults)
    
    /// Do the nested level meta-data
    let optionsContainer =
      try container.nestedContainer(
        keyedBy: OptionCodingKeys.self, forKey: .options)
    limit = try optionsContainer.decodeIfPresent(UInt16.self, forKey: .limit)
    offset =
      try optionsContainer.decodeIfPresent(UInt16.self, forKey: .offset)
    
    /// Do the results
    var resultsArray: [BVType] = []
    
    var resultsContainer =
      try container.nestedUnkeyedContainer(forKey: .updates)
    
    guard let count = resultsContainer.count,
      0 < count else {
        results = nil
        return
    }
    
    /// This is how much I trust any language...
    var ceiling: Int = resultsContainer.count ?? 0
    ceiling = 0 > ceiling ? 0 : ceiling
    
    while !resultsContainer.isAtEnd && 0 < ceiling {
      
      ceiling -= 1
      
      guard let internalContainer =
        try? resultsContainer.nestedContainer(
          keyedBy: ResultCodingKeys.self),
        /// Rip the type out while we're at it...
        let result: BVType =
        try internalContainer.decodeIfPresent(
          BVType.self, forKey: .data) else {
            continue
      }
      
      /// If we don't have any product details or an object that doesn't follow
      /// the protocol, then we bail
      if var resultUpdateProductDetails: BVCurationsProductUpdatable =
        result as? BVCurationsProductUpdatable,
        let product = productData?.array {
        
        resultUpdateProductDetails.update(product)
        
        guard let backToQueryableType: BVType =
          resultUpdateProductDetails as? BVType else {
            /// Should never ever get here but we'll just add the original
            /// result object
            resultsArray.append(result)
            continue
        }
        
        resultsArray.append(backToQueryableType)
        continue
      }
      
      resultsArray.append(result)
    }
    
    results = resultsArray
  }
}
