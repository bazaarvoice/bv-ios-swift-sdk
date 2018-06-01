//
//
//  BVProductStatistics.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVProductStatistics type
/// - Note:
/// \
/// It conforms to BVQueryable and, therefore, it is used only for BVQuery.
public struct BVProductStatistics: BVQueryable {
  
  public static var singularKey: String {
    get {
      return BVConversationsConstants.BVProductStatistics.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVConversationsConstants.BVProductStatistics.pluralKey
    }
  }
  
  var productId: String? {
    get {
      return productStatisticsInternal?.productId
    }
  }
  
  var reviewStatistics: BVReviewStatistics? {
    get {
      return productStatisticsInternal?.reviewStatistics
    }
  }
  
  var nativeReviewStatistics: BVReviewStatistics? {
    get {
      return productStatisticsInternal?.nativeReviewStatistics
    }
  }
  
  private let productStatisticsInternal: BVProductStatisticsInternal?
  private struct BVProductStatisticsInternal: Codable {
    
    let productId: String?
    let reviewStatistics: BVReviewStatistics?
    let nativeReviewStatistics: BVReviewStatistics?
    
    internal enum CodingKeys: String, CodingKey {
      case productId = "ProductId"
      case reviewStatistics = "ReviewStatistics"
      case nativeReviewStatistics = "NativeReviewStatistics"
    }
  }
  
  private enum CodingKeys: String, CodingKey {
    case productStatisticsInternal = "ProductStatistics"
  }
  
  public init(from decoder: Decoder) throws {
    let container =
      try decoder.container(keyedBy: CodingKeys.self)
    
    productStatisticsInternal =
      try container.decode(
        BVProductStatisticsInternal.self,
        forKey: .productStatisticsInternal)
  }
}

extension BVProductStatistics: BVQueryableInternal {
  public static var getResource: String? {
    get {
      return BVConversationsConstants.BVProductStatistics.getResource
    }
  }
}
