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
    
    dict["cl"] = "Used"
    dict["type"] = "Feature"
    dict["name"] = "InView"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
}
