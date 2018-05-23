//
//
//  BVAnalyticsEvent.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#if !DISABLE_BVSDK_IDFA
  import AdSupport
#endif

import Foundation

public enum BVAnalyticsEvent {
  
  case conversion(
    type: String,
    value: String,
    label: String?,
    additional: [String : Encodable]?)
  
  case feature(
    bvProduct: BVAnalyticsProductType,
    name: BVAnalyticsFeatureType,
    productId: String,
    brand: String?,
    additional: [String : Encodable]?)
  
  case impression(
    bvProduct: BVAnalyticsProductType,
    contentId: String,
    contentType: BVAnalyticsImpressionType,
    productId: String,
    brand: String?,
    categoryId: String?,
    additional: [String : Encodable]?)
  
  case inView(
    bvProduct: BVAnalyticsProductType,
    component: String,
    productId: String,
    brand: String?,
    additional: [String : Encodable]?)
  
  case pageView(
    bvProduct: BVAnalyticsProductType,
    productId: String,
    brand: String?,
    categoryId: String?,
    rootCategoryId: String?,
    additional: [String : Encodable]?)
  
  case personalization(
    profileId: String,
    additional: [String : Encodable]?)
  
  case transaction(
    items: [BVAnalyticsTransactionItem],
    orderId: String,
    total: Double,
    city: String?,
    country: String?,
    currency: String?,
    shipping: Double?,
    state: String?,
    tax: Double?,
    additional: [String : Encodable]?)
  
  case viewed(
    bvProduct: BVAnalyticsProductType,
    productId: String,
    brand: String?,
    categoryId: String?,
    rootCategoryId: String?,
    additional: [String : Encodable]?)
}

extension BVAnalyticsEvent {
  /// Note: make sure to keep this updated with the types that we use...
  internal static func stringifyAndTypeErase(
    _ encodableDict: [String : Encodable]?) -> [String : BVAnyEncodable] {
    
    guard let dict = encodableDict else {
      return [:]
    }
    
    return dict.mapValues {
      switch $0 {
      case let int as Int:
        return BVAnyEncodable(String(format: "%dl", int))
      case let uint as UInt:
        return BVAnyEncodable(String(format: "%ul", uint))
      case let double as Double:
        return BVAnyEncodable(String(format: "%0.2f", double))
      default:
        return BVAnyEncodable($0)
      }
    }
  }
}

extension BVAnalyticsEvent {
  internal var additional: [String : Encodable]? {
    get {
      switch self {
      case let .conversion(_,_,_, additional):
        return additional
      case let .feature(_, _, _, _, additional):
        return additional
      case let .impression(_, _, _, _, _, _, additional):
        return additional
      case let .inView(_, _, _, _, additional):
        return additional
      case let .pageView(_, _, _, _, _, additional):
        return additional
      case let .personalization(_, additional):
        return additional
      case let .transaction(_, _, _, _, _, _, _, _, _, additional):
        return additional
      case let .viewed(_, _, _, _, _, additional):
        return additional
      }
    }
  }
}

extension BVAnalyticsEvent {
  
  internal var hasPII: Bool {
    get {
      return 0 < toBlacklistDict.count
    }
  }
  
  internal var hasNonPII: Bool {
    get {
      return 0 < toWhitelistDict.count
    }
  }
  
  internal var toWhitelistDict: [String : Encodable] {
    get {
      return toDict.filter {
        BVAnalyticsEvent.whiteList.contains($0.key)
      }
    }
  }
  
  internal var toBlacklistDict: [String : Encodable] {
    get {
      return toDict.filter {
        !BVAnalyticsEvent.whiteList.contains($0.key)
      }
    }
  }
  
  internal var toDict: [String : Encodable] {
    get {
      let analyticsMirror: Mirror = Mirror(reflecting: self)
      guard let child = analyticsMirror.children.first else {
        return [:]
      }
      
      let childMirror = Mirror(reflecting: child.value)
      
      /// Super important to always have the supplimentary encodable dictionary
      /// be the last associated value in the enumeration value.
      let children = childMirror.children.dropLast(1)
      
      let core: [String : Encodable] = children.reduce([:])
      { (result: [String : Encodable],
        arg: (label: String?, value: Any)) -> [String : Encodable] in
        var copyResult: [String : Encodable] = result
        
        let (label, value) = arg
        guard let thisLabel: String = label else {
          return copyResult
        }
        
        let valueMirror = Mirror(reflecting: value)
        
        if let displayStyle = valueMirror.displayStyle,
          displayStyle == .optional,
          0 == valueMirror.children.count {
          return copyResult
        }
        
        guard let encodeValue: Encodable = value as? Encodable else {
          return copyResult
        }
        
        copyResult[thisLabel] = encodeValue
        return copyResult
      }
      
      return core + additional
    }
  }
}

extension BVAnalyticsEvent {
  
  internal static var idfaKey: String = "advertisingId"
  internal static var bvidUserDefaultsKey: String = "BVID_STORAGE_KEY"
  internal static var defaultIdfa: String = "nontracking"
  internal static var loadIdKey: String = "loadId"
  
  internal static var bvid: String {
    get {
      if let id: String =
        UserDefaults.standard.string(forKey: bvidUserDefaultsKey),
        0 < id.count {
        return id
      }
      
      let uuid: String = UUID().uuidString
      UserDefaults.standard.setValue(uuid, forKey: bvidUserDefaultsKey)
      UserDefaults.standard.synchronize()
      return uuid
    }
  }
  
  internal static var whiteList: [String] {
    get {
      return [
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
        "ref"
      ]
    }
  }
  
  internal static func commonAnalyticsValues(
    _ anonymous: () -> Bool) -> [String : String] {
    
    var id: String = defaultIdfa
    #if !DISABLE_BVSDK_IDFA
      guard !anonymous() && ASIdentifierManager.shared()
        .isAdvertisingTrackingEnabled else {
          return [idfaKey : id]
      }
      id = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    #endif
    
    return [
      "mobileSource" : "bv-ios-sdk",
      "HashedIP" : "default",
      "source" : "native-mobile-sdk",
      "UA" : bvid,
      idfaKey : id
    ]
  }
  
  internal static func clientIdentifier(
    _ clientId: String) -> [String : BVAnyEncodable] {
    return ["client" : BVAnyEncodable(clientId)]
  }
  
  internal static func loadId(_ count: UInt = 10) -> [String : String]? {
    let byteCount = Int(count) /// Yep, pedantry, recast to Int
    let align = MemoryLayout<UInt8>.alignment
    let buffer: UnsafeMutableRawPointer =
      UnsafeMutableRawPointer.allocate(
        bytes: byteCount,
        alignedTo: align)
    
    defer {
      buffer.deallocate(bytes: byteCount, alignedTo: align)
    }
    
    guard errSecSuccess ==
      SecRandomCopyBytes(kSecRandomDefault, byteCount, buffer) else {
        return nil
    }
    
    let bufferPointer =
      UnsafeRawBufferPointer(start: buffer, count: byteCount)
    
    return [
      loadIdKey : bufferPointer.reduce(String.empty)
      { (result: String, byte: UInt8) -> String in
        result + String(format: "%x", byte)
      }
    ]
  }
}

internal protocol BVAnalyticsEventable {
  func serialize(_ anonymous: Bool) -> Encodable
  mutating func augment(_ additional: [String : Encodable]?)
}

internal typealias BVAnalyticsEventInstance =
  (event: BVAnalyticsEventable,
  configuration: BVAnalyticsConfiguration,
  anonymous: Bool)

