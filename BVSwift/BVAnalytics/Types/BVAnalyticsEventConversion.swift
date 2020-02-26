//
//
//  BVAnalyticsEventConversion.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent {
  internal func serializeConversion(
    _ nonPII: Bool = false) -> [String: BVAnyEncodable] {
    
    guard case .conversion = self else {
      fatalError()
    }
    
    var dict = nonPII ? toWhitelistDict : toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return hasPII }
    if let loadId = BVAnalyticsEvent.loadId() {
      dict += loadId
    }
    
    dict[BVAnalyticsConstants.clKey] = "Conversion"
    
    if hasPII {
      dict[BVAnalyticsConstants.hadPIIKey] = "true"
      if !nonPII {
        dict[BVAnalyticsConstants.clKey] = "PIIConversion"
      }
    }
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
  
  internal func toConversionDict() -> [String: Encodable] {
    switch self {
    case let .conversion(type, value, label, additional):
      let nonOptional: [String: Encodable] = ["type": type, "value": value]
      let optional: [String: Encodable] =
        [:] + label.map { ["label": $0] } + additional
      return nonOptional + optional
    default:
      fatalError()
    }
  }
}
