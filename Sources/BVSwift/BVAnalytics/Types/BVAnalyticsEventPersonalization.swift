//
//
//  BVAnalyticsEventPersonalization.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent {
  internal func serializePersonalization(
    _ nonPII: Bool = false) -> [String : BVAnyEncodable] {
    
    guard case .personalization = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict["cl"] = "Personalization"
    dict["type"] = "ProfileMobile"
    dict["source"] = "ProfileMobile"
    
    /// We may want to add this to types?
    dict["bvProduct"] = "ShopperMarketing"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
}
