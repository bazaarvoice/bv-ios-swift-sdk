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
    return BVConversationsConstants.BVProductStatistics.singularKey
  }
  
  public static var pluralKey: String {
    return BVConversationsConstants.BVProductStatistics.pluralKey
  }
  
  public var productId: String? {
    return productStatisticsInternal?.productId
  }
  
  public var reviewStatistics: BVReviewStatistics? {
    return productStatisticsInternal?.reviewStatistics
  }
  
  public var nativeReviewStatistics: BVReviewStatistics? {
    return productStatisticsInternal?.nativeReviewStatistics
  }
  
  public var qaStatistics: BVQAStatistics? {
    return productStatisticsInternal?.qaStatistics
  }

  
  private let productStatisticsInternal: BVProductStatisticsInternal?
  private struct BVProductStatisticsInternal: Codable {
    
    let productId: String?
    let reviewStatistics: BVReviewStatistics?
    let nativeReviewStatistics: BVReviewStatistics?
    let qaStatistics: BVQAStatistics?
    
    internal enum CodingKeys: String, CodingKey {
      case productId = "ProductId"
      case reviewStatistics = "ReviewStatistics"
      case nativeReviewStatistics = "NativeReviewStatistics"
      case qaStatistics = "QAStatistics"
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
    return BVConversationsConstants.BVProductStatistics.getResource
  }
}
