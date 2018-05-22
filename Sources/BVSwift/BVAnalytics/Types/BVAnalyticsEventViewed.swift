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
    _ nonPII: Bool = false) -> [String : BVAnyEncodable] {
    
    guard case .viewed = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict["cl"] = "Feature"
    dict["type"] = "UsedViewedUGC"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
}
