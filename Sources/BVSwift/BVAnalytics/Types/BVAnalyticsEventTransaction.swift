//
//
//  BVAnalyticsEventTransaction.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent {
  internal func serializeTransaction(
    _ nonPII: Bool = false) -> [String: BVAnyEncodable] {
    
    guard case .transaction = self else {
      fatalError()
    }
    
    var dict = nonPII ? toWhitelistDict : toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return hasPII }
    
    if let loadId = BVAnalyticsEvent.loadId() {
      dict += loadId
    }
    
    dict["cl"] = "Conversion"
    dict["type"] = "Transaction"
    
    if hasPII {
      dict["hadPII"] = "true"
      if !nonPII {
        dict["cl"] = "PIIConversion"
      }
    }
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
}
