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
    _ nonPII: Bool = false) -> [String : BVAnyEncodable] {
    
    guard case .impression = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict["cl"] = "Impression"
    dict["type"] = "UGC"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
}
