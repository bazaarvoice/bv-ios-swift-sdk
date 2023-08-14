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
    
    dict[BVAnalyticsConstants.clKey] = "Conversion"
    dict["type"] = "Transaction"
    
    if hasPII {
      dict[BVAnalyticsConstants.hadPIIKey] = "true"
      if !nonPII {
        dict[BVAnalyticsConstants.clKey] = "PIIConversion"
      }
    }
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
  
  internal func toTransactionDict() -> [String: Encodable] {
    switch self {
    case let .transaction(
      items,
      orderId,
      total,
      city,
      country,
      currency,
      shipping,
      state,
      tax,
      additional):
      let nonOptional: [String: Encodable] =
        ["items": items, "orderId": orderId, "total": total]
      let optional: [String: Encodable] =
        [:] + city.map { ["city": $0] }
          + country.map { ["country": $0] }
          + currency.map { ["currency": $0] }
          + shipping.map { ["shipping": $0] }
          + state.map { ["state": $0] }
          + tax.map { ["tax": $0] }
          + additional
      return nonOptional + optional
    default:
      fatalError()
    }
  }
}
