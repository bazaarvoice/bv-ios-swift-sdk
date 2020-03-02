//
//
//  BVAnalyticsEventInView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent {
  internal func serializeInView(
    _ nonPII: Bool = false) -> [String: BVAnyEncodable] {
    
    guard case .inView = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict[BVAnalyticsConstants.clKey] = "Used"
    dict["type"] = "Feature"
    dict["name"] = "InView"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
  
  internal func toInViewDict() -> [String: Encodable] {
    switch self {
    case let .inView(
      bvProduct, component, productId, brand, additional):
      let nonOptional: [String: Encodable] =
        ["bvProduct": bvProduct,
         "component": component,
         "productId": productId]
      let optional: [String: Encodable] =
        [:] + brand.map { ["brand": $0] } + additional
      return nonOptional + optional
    default:
      fatalError()
    }
  }
}
