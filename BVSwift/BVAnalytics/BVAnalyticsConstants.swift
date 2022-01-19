//
//
//  BVAnalyticsConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVAnalyticsConstants {
  static let clKey: String = "cl"
  static let typeKey: String = "type"
  static let bvProduct: String = "Analytics"
  static let localeKey: String = "analyticsLocaleIdentifier"
  static let hadPIIKey: String = "hadPII"
  static let dryRunKey: String = "dryRunAnalytics"
  static let idfaKey: String = "advertisingId"
  static let userAgentKey: String = "UA"
  static let mobileSourceKey: String = "mobileSource"
  static let mobileSource: String = "bv-ios-sdk"
  static let sourceKey: String = "source"
  static let source: String = "native-mobile-sdk"
  static let hashedIPKey: String = "HashedIP"
  static let hashedIP: String = "default"
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
  static let mobileOS: String = "ios-swift"
  static let whiteList = [
    "orderId",
    "affiliation",
    "total",
    "tax",
    "shipping",
    "city",
    "state",
    "country",
    "currency",
    "items",
    "locale",
    "type",
    "label",
    "value",
    "proxy",
    "partnerSource",
    "TestCase",
    "TestSession",
    "dc",
    "ref",
    "deploymentZone",
    "discount"
  ]
  
  static let commonValues: [String: String] = [
    mobileSourceKey: mobileSource,
    hashedIPKey: hashedIP,
    sourceKey: source,
    userAgentKey: BVFingerprint.shared.bvid
  ]
  
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
    static let mobileOS: String = "mobileOS"
    static let bvSDKVersion: String = "bvSDKVersion"
    static let mobileDeviceName: String = "mobileDeviceName"
    static let mobileOSVersion: String = "mobileOSVersion"
    static let mobileAppVersion: String = "mobileAppVersion"
    static let mobileAppIdentifier: String = "mobileAppIdentifier"
  }
}
