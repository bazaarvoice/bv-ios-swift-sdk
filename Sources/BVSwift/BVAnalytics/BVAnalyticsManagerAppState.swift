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
    private var event: [String: String]
    private var additional: [String: BVAnyEncodable]?
    
    init(internalEvent: [String: String]) {
      self.event = internalEvent
    }
    
    mutating func augment(_ additional: [String: BVAnyEncodable]?) {
      self.additional = additional
    }
    
    func serialize(_ anonymous: Bool) -> [String: BVAnyEncodable]  {
      let base = BVAnalyticsEvent.stringifyAndTypeErase(event)
      let add = BVAnalyticsEvent.stringifyAndTypeErase(additional)
      return base + add
    }
  }
  
  internal static var defaultAppState: [String: String] = {
    var eventData = [
      "cl": "Lifecycle",
      "type": "MobileApp",
      "source": "mobile-lifecycle",
      "mobileOS": "ios",
      "bvSDKVersion": sdkVersion,
      "mobileDeviceName": UIDevice.current.machine,
      "mobileOSVersion": UIDevice.current.systemVersion,
      "mobileAppVersion": "\(Bundle.releaseVersionNumber).\(Bundle.buildVersionNumber)"
    ]
    
    if let bundleIdentifier = Bundle.main.bundleIdentifier {
      eventData += [ "mobileAppIdentifier": bundleIdentifier ]
    }
    
    eventData += BVAnalyticsEvent.commonAnalyticsValues { return false }
    
    return eventData
  }()
  
  internal func convertToEventable(
    _ event: [String: String]) -> BVAnalyticsEventable {
    return BVAnalyticsAppStateEvent(internalEvent: event)
  }
  
  internal func registerApplicationStateNotifications() {
    _ = NotificationCenter.default.addObserver(
      forName: UIApplication.didFinishLaunchingNotification,
      object: nil,
      queue: OperationQueue.main) { (notification: Notification) in
        
        var appState: [String: String] = ["appState": "launched"]
        
        switch notification.userInfo {
        case let .some(userInfo) where
          nil != userInfo[UIApplication.LaunchOptionsKey.url]:
          appState += ["appSubState": "url-initiated"]
        case let .some(userInfo) where
          nil != userInfo[UIApplication.LaunchOptionsKey.sourceApplication]:
          appState += ["appSubState": "other-app-initiated"]
        case let .some(userInfo) where
          nil != userInfo[UIApplication.LaunchOptionsKey.remoteNotification]:
          appState += ["appSubState": "remote-notification-initiated"]
        default:
          appState += ["appSubState": "user-initiated"]
        }
        
        self.enqueueAppStateEvent(appState)
    }
    
    _ = NotificationCenter.default.addObserver(
      forName: UIApplication.didBecomeActiveNotification,
      object: nil,
      queue: OperationQueue.main) { (_: Notification) in
        self.enqueueAppStateEvent(["appState": "active"])
    }
    
    _ = NotificationCenter.default.addObserver(
      forName: UIApplication.didEnterBackgroundNotification,
      object: nil,
      queue: OperationQueue.main) { (_: Notification) in
        self.enqueueAppStateEvent(["appState": "background"])
    }
  }
  
  private func enqueueAppStateEvent(_ event: [String: String]) {
    let eventData = event + BVAnalyticsManager.defaultAppState
    
    guard let config: BVAnalyticsConfiguration =
      BVManager.sharedManager.getConfiguration() else {
        BVLogger.sharedLogger.analytics(
          "No default BVAnalytics configuration was found, skipping app " +
          "state event logging.")
        return
    }
    
    enqueue(
      analyticsEventable: convertToEventable(eventData), configuration: config)
  }
}
