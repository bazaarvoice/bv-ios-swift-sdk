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
      BVAnalyticsConstants.EventKeys.cl: BVAnalyticsConstants.lifecycleKey,
      BVAnalyticsConstants.EventKeys.type: BVAnalyticsConstants.mobileAppKey,
      BVAnalyticsConstants.EventKeys.source:
        BVAnalyticsConstants.mobileLifeCycleKey,
      BVAnalyticsConstants.EventKeys.mobileOS: BVAnalyticsConstants.mobileOS,
      BVAnalyticsConstants.EventKeys.bvSDKVersion: Bundle.bvSdkVersion,
      BVAnalyticsConstants.EventKeys.mobileDeviceName: UIDevice.current.machine,
      BVAnalyticsConstants.EventKeys.mobileOSVersion:
        UIDevice.current.systemVersion,
      BVAnalyticsConstants.EventKeys.mobileAppVersion:
      "\(Bundle.releaseVersionNumber).\(Bundle.buildVersionNumber)"
    ]

    if let bundleIdentifier = Bundle.main.bundleIdentifier {
      eventData += [
        BVAnalyticsConstants.EventKeys.mobileAppIdentifier:
        bundleIdentifier
      ]
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
      queue: OperationQueue.main) { [weak self] (notification: Notification) in

        var appState: [String: String] =
          [BVAnalyticsConstants.AppState.state:
            BVAnalyticsConstants.AppState.launched]

        switch notification.userInfo {
        case let .some(userInfo) where
          nil != userInfo[UIApplication.LaunchOptionsKey.url]:
          appState +=
            [BVAnalyticsConstants.AppState.subState:
              BVAnalyticsConstants.AppState.urlInitiated]
        case let .some(userInfo) where
          nil != userInfo[UIApplication.LaunchOptionsKey.sourceApplication]:
          appState +=
            [BVAnalyticsConstants.AppState.subState:
              BVAnalyticsConstants.AppState.otherAppInitiated]
        case let .some(userInfo) where
          nil != userInfo[UIApplication.LaunchOptionsKey.remoteNotification]:
          appState +=
            [BVAnalyticsConstants.AppState.subState:
              BVAnalyticsConstants.AppState.remoteInitiated]
        default:
          appState +=
            [BVAnalyticsConstants.AppState.subState:
              BVAnalyticsConstants.AppState.userInitiated]
        }

        self?.enqueueAppStateEvent(appState)
    }

    _ = NotificationCenter.default.addObserver(
      forName: UIApplication.didBecomeActiveNotification,
      object: nil,
      queue: OperationQueue.main) { [weak self] (_: Notification) in
        self?.enqueueAppStateEvent(
          [BVAnalyticsConstants.AppState.state:
            BVAnalyticsConstants.AppState.active])
    }

    _ = NotificationCenter.default.addObserver(
      forName: UIApplication.didEnterBackgroundNotification,
      object: nil,
      queue: OperationQueue.main) { [weak self] (_: Notification) in
        self?.enqueueAppStateEvent(
          [BVAnalyticsConstants.AppState.state:
            BVAnalyticsConstants.AppState.background])
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
