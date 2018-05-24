//
//
//  BVPixel.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The BVPixel singleton class for tracking analytic events.
///
/// This singleton is used to track all the various BVAnalyticsEvent types
/// - Note:
///   \
///   For more information regarding [Analytics]
///   (https://developer.bazaarvoice.com/conversations-api/tutorials/bv-pixel)
public class BVPixel {
  
  // This is solely for BVSwiftTests to circumvent analytics
  internal static var skipAllPixelEvents: Bool = false
  
  /// Main method used to track a BVAnalyticsEvent type
  /// - Parameters:
  ///   - analyticsEvent: The event to track
  ///   - analyticConfiguration: The BVAnalyticsConfiguration to be assigned
  ///     to the event to be tracked.
  /// - Note:
  ///   \
  ///   If you do not pass in a valid BVAnalyticsConfiguration then the module
  ///   will attempt to acquire one through the BVManager. If nothing is found
  ///   at the BVManager level then this call will fail fatally.
  @discardableResult
  public class func track(
    _ analyticsEvent: BVAnalyticsEvent,
    analyticConfiguration: BVAnalyticsConfiguration? = nil) -> Bool {
    
    if skipAllPixelEvents {
      return true
    }
    
    let configuration: BVAnalyticsConfiguration? =
      analyticConfiguration ?? BVManager.sharedManager.getConfiguration()
    
    guard let config = configuration  else {
      fatalError(
        "No BVAnalyticsConfiguration is set for analytics, please refer to " +
        "the documentation.")
    }
    
    switch analyticsEvent {
    case .conversion where analyticsEvent.hasPII:
      BVAnalyticsManager.sharedManager
        .enqueue(
          analyticsEvent: analyticsEvent,
          configuration: config,
          anonymous: true)
      fallthrough
    case .conversion:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent, configuration: config)
      break
    case .pageView:
      fallthrough
    case .personalization:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent, configuration: config)
      BVAnalyticsManager.sharedManager.flush()
      break
    case .transaction where analyticsEvent.hasPII:
      BVAnalyticsManager.sharedManager
        .enqueue(
          analyticsEvent: analyticsEvent,
          configuration: config,
          anonymous: true)
      fallthrough
    case .transaction:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent, configuration: config)
      break
    default:
      BVAnalyticsManager.sharedManager
        .enqueue(analyticsEvent: analyticsEvent, configuration: config)
    }
    
    return true
  }
  
  private init() {}
}
