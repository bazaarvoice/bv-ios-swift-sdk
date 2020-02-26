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
    _ nonPII: Bool = false) -> [String: BVAnyEncodable] {
    
    guard case .personalization = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict[BVAnalyticsConstants.clKey] = "Personalization"
    dict["type"] = "ProfileMobile"
    dict["source"] = "ProfileMobile"
    
    /// We may want to add this to types?
    dict["bvProduct"] = "ShopperMarketing"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
  
  internal func toPersonalizationDict() -> [String: Encodable] {
    switch self {
    case let .personalization(profileId, additional):
      let nonOptional: [String: Encodable] = ["profileId": profileId]
      let optional: [String: Encodable] = [:] + additional
      return nonOptional + optional
    default:
      fatalError()
    }
  }
}
