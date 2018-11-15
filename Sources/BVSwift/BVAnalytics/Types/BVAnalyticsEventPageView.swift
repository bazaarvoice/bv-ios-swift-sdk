//
//
//  BVAnalyticsEventPageView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent {
  internal func serializePageView(
    _ nonPII: Bool = false) -> [String: BVAnyEncodable] {
    
    guard case .pageView = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict[BVAnalyticsConstants.clKey] = "PageView"
    dict["type"] = "Product"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
  
  internal func toPageViewDict() -> [String: Encodable] {
    switch self {
    case let .pageView(
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
