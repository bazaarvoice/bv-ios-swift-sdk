//
//
//  BVAnalyticsEventFeature.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent {
  internal func serializeFeature(
    _ nonPII: Bool = false) -> [String: BVAnyEncodable] {
    
    guard case let .feature(_, name, _, _, _) = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict[BVAnalyticsConstants.clKey] = "Feature"
    dict["type"] = "Used"
    dict["interaction"] = .inView == name ? "false" : "true"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
  
  internal func toFeatureDict() -> [String: Encodable] {
    switch self {
    case let .feature(bvProduct, name, productId, brand, additional):
      let nonOptional: [String: Encodable] =
        ["bvProduct": bvProduct, "name": name, "productId": productId]
      let optional: [String: Encodable] =
        [:] + brand.map { ["brand": $0] } + additional
      return nonOptional + optional
    default:
      fatalError()
    }
  }
}
