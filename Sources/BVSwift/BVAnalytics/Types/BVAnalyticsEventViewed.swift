//
//
//  BVAnalyticsEventViewed.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent {
  internal func serializeViewed(
    _ nonPII: Bool = false) -> [String: BVAnyEncodable] {
    
    guard case .viewed = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict[BVAnalyticsConstants.clKey] = "Feature"
    dict["type"] = "UsedViewedUGC"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
  
  internal func toViewedDict() -> [String: Encodable] {
    switch self {
    case let .viewed(
      bvProduct,
      productId,
      brand,
      categoryId,
      rootCategoryId,
      additional):
      let nonOptional: [String: Encodable] =
        ["bvProduct": bvProduct, "productId": productId]
      let optional: [String: Encodable] =
        [:] + brand.map { ["brand": $0] }
          + categoryId.map { ["categoryId": $0] }
          + rootCategoryId.map { ["rootCategoryId": $0] }
          + additional
      return nonOptional + optional
    default:
      fatalError()
    }
  }
}
