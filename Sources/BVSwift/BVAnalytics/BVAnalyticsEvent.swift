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

/// The BVAnalytics BVAnalyticsEvent enum
///
/// This enumeration represents all the BV Analytic Objects that are currently
/// supported by our SDK.
/// - Note:
/// \
/// For more information regarding [Analytics]
/// (https://developer.bazaarvoice.com/conversations-api/tutorials/bv-pixel)
public enum BVAnalyticsEvent {
  
  /// Conversion Analytics Event
  /// - Parameters:
  ///   - type: The type of event
  ///   - value: The value related to the event
  ///   - label: The label of the event
  ///   - additional: Extra freeform [key, value] to merge into event
  case conversion(
    type: String,
    value: String,
    label: String?,
    additional: [String : Encodable]?)
  
  /// Feature Analytics Event
  /// - Parameters:
  ///   - bvProduct: The product type of event
  ///   - name: The feature type name of event
  ///   - productId: The product id of the event
  ///   - brand: The brand related to the event
  ///   - additional: Extra freeform [key, value] to merge into event
  case feature(
    bvProduct: BVAnalyticsProductType,
    name: BVAnalyticsFeatureType,
    productId: String,
    brand: String?,
    additional: [String : Encodable]?)
  
  /// Impression Analytics Event
  /// - Parameters:
  ///   - bvProduct: The product type of event
  ///   - contentId: The content id related to the event
  ///   - contentType: The impression type related to the event
  ///   - productId: The product id of the event
  ///   - brand: The brand related to the event
  ///   - categoryId: The category id related to the event
  ///   - additional: Extra freeform [key, value] to merge into event
  case impression(
    bvProduct: BVAnalyticsProductType,
    contentId: String,
    contentType: BVAnalyticsImpressionType,
    productId: String,
    brand: String?,
    categoryId: String?,
    additional: [String : Encodable]?)
  
  /// In-View Analytics Event
  /// - Parameters:
  ///   - bvProduct: The product type of event
  ///   - component: The view component related to the event
  ///   - productId: The product id of the event
  ///   - brand: The brand related to the event
  ///   - additional: Extra freeform [key, value] to merge into event
  case inView(
    bvProduct: BVAnalyticsProductType,
    component: String,
    productId: String,
    brand: String?,
    additional: [String : Encodable]?)
  
  /// Page View Analytics Event
  /// - Parameters:
  ///   - bvProduct: The product type of event
  ///   - productId: The product id of the event
  ///   - brand: The brand related to the event
  ///   - categoryId: The category id related to the event
  ///   - rootCategoryId: The root category id related to the event
  ///   - additional: Extra freeform [key, value] to merge into event
  case pageView(
    bvProduct: BVAnalyticsProductType,
    productId: String,
    brand: String?,
    categoryId: String?,
    rootCategoryId: String?,
    additional: [String : Encodable]?)
  
  /// Personalization Analytics Event
  /// - Parameters:
  ///   - profileId: The profile id for user of event
  ///   - additional: Extra freeform [key, value] to merge into event
  case personalization(
    profileId: String,
    additional: [String : Encodable]?)
  
  /// Transaction Analytics Event
  /// - Parameters:
  ///   - items: The list of items being tracked in this event
  ///   - orderId: The related order id for the event
  ///   - total: The related total for the event
  ///   - city: The related city for the event
  ///   - country: The related country for the event
  ///   - currency: The related currency for the event
  ///   - shipping: The related shipping costs for the event
  ///   - state: The related state for the event
  ///   - tax: The related taxes for the event
  ///   - additional: Extra freeform [key, value] to merge into event
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
  
  /// Viewed Analytics Event
  /// - Parameters:
  ///   - bvProduct: The product type of event
  ///   - productId: The product id of the event
  ///   - brand: The brand related to the event
  ///   - categoryId: The category id related to the event
  ///   - rootCategoryId: The root category id related to the event
  ///   - additional: Extra freeform [key, value] to merge into event
  case viewed(
    bvProduct: BVAnalyticsProductType,
    productId: String,
    brand: String?,
    categoryId: String?,
    rootCategoryId: String?,
    additional: [String : Encodable]?)
}

/// - Important:
/// We need to make sure to keep this updated with the types that we use...
extension BVAnalyticsEvent {
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
        byteCount: byteCount,
        alignment: align)
    
    defer {
      buffer.deallocate()
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
