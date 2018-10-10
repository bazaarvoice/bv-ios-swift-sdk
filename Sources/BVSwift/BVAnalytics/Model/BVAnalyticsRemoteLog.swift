//
//
//  BVAnalyticsRemoteLog.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import UIKit

internal struct BVAnalyticsRemoteLog: BVSubmissionable {
  static let typeKey: String = "record"
  static let nameKey: String = "Error"
  
  static var singularKey: String {
    return "log"
  }
  static var pluralKey: String {
    return "logs"
  }
  
  private enum ErrorKey: String {
    case bvid
    case bvsid
    case bvbrandid
    case bvbrandsid
    case hasheduaip
    case browser = "ua_browser"
    case browserVersion = "ua_browser_version"
    case platform = "ua_platform"
    case platformVersion = "ua_platform_version"
    case mobile = "ua_mobile"
    case dt
    case loadid
    case page
    case source
    case client
    case audience
    case dc
    case lang
    case tz
    case name
    case detail1
    case detail2
    case bvproductversion
    case ua
    case locale
    case bvproduct
  }
  
  private enum CodingKeys: CodingKey {
    init?(stringValue: String) {
      return nil
    }
    
    var intValue: Int? {
      return nil
    }
    
    init?(intValue: Int) {
      return nil
    }
    
    case commonKey(String)
    case key(ErrorKey)
    
    var stringValue: String {
      switch self {
      case let .commonKey(key):
        return key
      case let .key(key):
        return key.rawValue
      }
    }
  }
  
  internal private(set) var client: String?
  internal private(set) var error: String?
  internal private(set) var locale: Locale?
  internal private(set) var log: String?
  internal private(set) var bvProduct: String?
  
  internal init(
    client: String?,
    error: String? = nil,
    locale: Locale? = nil,
    log: String?,
    bvProduct: String? = nil) {
    self.client = client
    self.error = error
    self.locale = locale
    self.log = log
    self.bvProduct = bvProduct
  }
  
  public init(from decoder: Decoder) throws { }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(Bundle.bvSdkVersion, forKey: .key(.bvproductversion))
    try container.encode(
      BVAnalyticsRemoteLog.nameKey,
      forKey: .commonKey(BVAnalyticsConstants.clKey))
    try container.encode(true, forKey: .key(.mobile))
    try container.encode(BVAnalyticsRemoteLog.nameKey, forKey: .key(.name))
    try container.encode(
      BVAnalyticsConstants.mobileOS, forKey: .key(.platform))
    try container.encode(
      UIDevice.current.systemVersion, forKey: .key(.platformVersion))
    try container.encode(BVAnalyticsConstants.source, forKey: .key(.source))
    try container.encode(
      BVAnalyticsRemoteLog.typeKey,
      forKey: .commonKey(BVAnalyticsConstants.typeKey))
    try container.encode(
      BVFingerprint.shared.nontrackingIDFA,
      forKey: .commonKey(BVAnalyticsConstants.idfaKey))
    try container.encode(
      "false",
      forKey: .commonKey(BVAnalyticsConstants.hadPIIKey))
    
    for (key, value) in BVAnalyticsConstants.commonValues {
      try container.encode(value, forKey: .commonKey(key))
    }
    
    try container.encodeIfPresent(client, forKey: .key(.client))
    try container.encodeIfPresent(error, forKey: .key(.detail2))
    try container.encodeIfPresent(locale?.identifier, forKey: .key(.locale))
    try container.encodeIfPresent(log, forKey: .key(.detail1))
    try container.encodeIfPresent(bvProduct, forKey: .key(.bvproduct))
  }
}

extension BVAnalyticsRemoteLog: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return "event"
  }
  
  internal mutating func update(_ values: [String: Encodable]?) { }
}
