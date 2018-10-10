//
//
//  BVAnalyticsConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVAnalyticsConstants {
  static let localeKey: String = "analyticsLocaleIdentifier"
  static let dryRunKey: String = "dryRunAnalytics"
  static let key: String = "bvanalytics"
  static let eu: String = "eu"
  static let productionEndpoint: String =
  "https://network.bazaarvoice.com/"
  static let stagingEndpoint: String =
  "https://network-stg.bazaarvoice.com/"
  static let productionEndpointEU: String =
  "https://network-eu.bazaarvoice.com/"
  static let stagingEndpointEU: String =
  "https://network-eu-stg.bazaarvoice.com/"
  static let lifecycleKey: String = "Lifecycle"
  static let mobileAppKey: String = "MobileApp"
  static let mobileLifeCycleKey: String = "mobile-lifecycle"
  static let mobileOS: String = "ios"
  
  struct AppState {
    static let active: String = "active"
    static let background: String = "background"
    static let launched: String = "launched"
    static let state: String = "appState"
    static let subState: String = "appSubState"
    static let otherAppInitiated: String = "other-app-initiated"
    static let remoteInitiated: String = "remote-notification-initiated"
    static let urlInitiated: String = "url-initiated"
    static let userInitiated: String = "user-initiated"
  }
  
  struct EventKeys {
    static let cl: String = "cl"
    static let type: String = "type"
    static let source: String = "source"
    static let mobileOS: String = "mobileOS"
    static let bvSDKVersion: String = "bvSDKVersion"
    static let mobileDeviceName: String = "mobileDeviceName"
    static let mobileOSVersion: String = "mobileOSVersion"
    static let mobileAppVersion: String = "mobileAppVersion"
    static let mobileAppIdentifier: String = "mobileAppIdentifier"
  }
}
