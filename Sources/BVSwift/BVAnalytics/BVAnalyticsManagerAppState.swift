//
//
//  BVAnalyticsManagerAppState.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation
import UIKit

extension BVAnalyticsManager {
  
  private struct BVAnalyticsAppStateEvent: BVAnalyticsEventable {
    private var event: [String : String]
    private var additional: [String : Encodable]?
    
    init(internalEvent: [String : String]) {
      self.event = internalEvent
    }
    
    mutating func augment(_ additional: [String : Encodable]?) {
      self.additional = additional
    }
    
    func serialize(_ anonymous: Bool) -> Encodable  {
      let base = BVAnalyticsEvent.stringifyAndTypeErase(event)
      let add = BVAnalyticsEvent.stringifyAndTypeErase(additional)
      return base + add
    }
  }
  
  internal static var defaultAppState: [String : String] = {
    var eventData = [
      "cl" : "Lifecycle",
      "type" : "MobileApp",
      "source" : "mobile-lifecycle",
      "mobileOS" : "ios",
      "bvSDKVersion" : sdkVersion,
      "mobileDeviceName" : UIDevice.current.machine,
      "mobileOSVersion" : UIDevice.current.systemVersion,
      "mobileAppVersion" :
      "\(Bundle.releaseVersionNumber).\(Bundle.buildVersionNumber)"
    ]
    
    if let bundleIdentifier = Bundle.main.bundleIdentifier {
      eventData += [ "mobileAppIdentifier" : bundleIdentifier ]
    }
    
    eventData += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    return eventData
  }()
  
  internal func convertToEventable(
    _ event: [String : String]) -> BVAnalyticsEventable {
    return BVAnalyticsAppStateEvent(internalEvent: event)
  }
  
  internal func registerApplicationStateNotifications() {
    NotificationCenter.default.addObserver(
      forName: NSNotification.Name.UIApplicationDidFinishLaunching,
      object: nil,
      queue: OperationQueue.main) { (notification: Notification) in
        
        var appState: [String : String] = ["appState" : "launched"]
        
        switch notification.userInfo {
        case let .some(userInfo) where
          nil != userInfo[UIApplicationLaunchOptionsKey.url]:
          appState += ["appSubState" : "url-initiated"]
          break
        case let .some(userInfo) where
          nil != userInfo[UIApplicationLaunchOptionsKey.sourceApplication]:
          appState += ["appSubState" : "other-app-initiated"]
          break
        case let .some(userInfo) where
          nil != userInfo[UIApplicationLaunchOptionsKey.remoteNotification]:
          appState += ["appSubState" : "remote-notification-initiated"]
          break
        default:
          appState += ["appSubState" : "user-initiated"]
          break
        }
        
        self.enqueueAppStateEvent(appState)
    }
    
    NotificationCenter.default.addObserver(
      forName: NSNotification.Name.UIApplicationDidBecomeActive,
      object: nil,
      queue: OperationQueue.main) { (notification: Notification) in
        self.enqueueAppStateEvent(["appState" : "active"])
    }
    
    NotificationCenter.default.addObserver(
      forName: NSNotification.Name.UIApplicationDidEnterBackground,
      object: nil,
      queue: OperationQueue.main) { (notification: Notification) in
        self.enqueueAppStateEvent(["appState" : "background"])
    }
  }
  
  private func enqueueAppStateEvent(_ event: [String : String]) {
    let eventData = event + BVAnalyticsManager.defaultAppState
    
    guard let config: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        BVLogger.sharedLogger.info(
          "No default BVAnalytics configuration was found, skipping app " +
          "state event logging.")
        return
    }
    
    enqueue(
      analyticsEventable: convertToEventable(eventData), configuration: config)
  }
}
