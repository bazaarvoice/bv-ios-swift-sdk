//
//
//  BVPixel.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVPixel {
  
  // This is solely for BVSwiftTests to circumvent analytics
  internal static var skipAllPixelEvents: Bool = false
  
  @discardableResult
  public class func track(_ analyticsEvent: BVAnalyticsEvent) -> Bool {
    
    if skipAllPixelEvents {
      return true
    }
    
    switch analyticsEvent {
    case .conversion where analyticsEvent.hasPII:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent, anonymous: true)
      fallthrough
    case .conversion:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent)
      break
    case .pageView:
      fallthrough
    case .personalization:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent)
      BVAnalyticsManager.sharedManager.flush()
      break
    case .transaction where analyticsEvent.hasPII:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent, anonymous: true)
      fallthrough
    case .transaction:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent)
      break
    default:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent)
    }
    
    return true
  }
  
  private init() {}
}
