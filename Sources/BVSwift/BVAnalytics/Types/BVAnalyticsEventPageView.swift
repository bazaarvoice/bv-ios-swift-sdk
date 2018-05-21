//
//
//  BVAnalyticsEventPageView.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

extension BVAnalyticsEvent {
  internal func serializePageView(
    _ nonPII: Bool = false) -> [String : BVAnyEncodable] {
    
    guard case .pageView = self else {
      fatalError()
    }
    
    var dict = toDict
    dict += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    dict["cl"] = "PageView"
    dict["type"] = "Product"
    
    /// Convert everything to strings and type erase.
    return BVAnalyticsEvent.stringifyAndTypeErase(dict)
  }
}
