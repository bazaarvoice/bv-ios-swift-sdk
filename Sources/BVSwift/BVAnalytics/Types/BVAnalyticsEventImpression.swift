//
//
//  BVAnalyticsEventImpression.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent {
  internal func serializeImpression(
    _ nonPII: Bool = false) -> [String: BVAnyEncodable] {
    
    guard case .impression = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict[BVAnalyticsConstants.clKey] = "Impression"
    dict["type"] = "UGC"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
  
  internal func toImpressionDict() -> [String: Encodable] {
    switch self {
    case let .impression(
      bvProduct,
      contentId,
      contentType,
      productId,
      brand,
      categoryId,
      additional):
      let nonOptional: [String: Encodable] =
        ["bvProduct": bvProduct,
         "contentId": contentId,
         "contentType": contentType,
         "productId": productId]
      let optional: [String: Encodable] =
        [:] + brand.map { ["brand": $0] }
          + categoryId.map { ["categoryId": $0] }
          + additional
      return nonOptional + optional
    default:
      fatalError()
    }
  }
}
