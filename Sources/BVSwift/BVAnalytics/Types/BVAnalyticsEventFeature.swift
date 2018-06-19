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
    
    dict["cl"] = "Feature"
    dict["type"] = "Used"
    dict["interaction"] = .inView == name ? "false" : "true"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
}
