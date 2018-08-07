//
//
//  BVAnalyticsEvent.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

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
    _ encodableDict: [String: Encodable]?) -> [String: BVAnyEncodable] {
    
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
  internal var additional: [String: Encodable]? {
    switch self {
    case let .conversion(_, _, _, additional):
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

extension BVAnalyticsEvent {
  
  internal var hasPII: Bool {
    return !toBlacklistDict.isEmpty
  }
  
  internal var hasNonPII: Bool {
    return !toWhitelistDict.isEmpty
  }
  
  internal var toWhitelistDict: [String: Encodable] {
    return toDict.filter {
      BVAnalyticsEvent.whiteList.contains($0.key)
    }
  }
  
  internal var toBlacklistDict: [String: Encodable] {
    return toDict.filter {
      !BVAnalyticsEvent.whiteList.contains($0.key)
    }
  }
  
  internal var toDict: [String: Encodable] {
    let analyticsMirror: Mirror = Mirror(reflecting: self)
    guard let child = analyticsMirror.children.first else {
      return [:]
    }
    
    let childMirror = Mirror(reflecting: child.value)
    
    /// Super important to always have the supplimentary encodable dictionary
    /// be the last associated value in the enumeration value.
    let children = childMirror.children.dropLast(1)
    
    let core: [String: Encodable] = children.reduce([:])
    { (result: [String: Encodable],
      arg: (label: String?, value: Any)) -> [String: Encodable] in
      var copyResult: [String: Encodable] = result
      
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
      
      /// This is gloriously ridiculous. It appears that when in "mirror-land"
      /// if you're more than one degree of separation from the concrete
      /// encodable type, e.g., Array, Set, Optional, etc., swift doesn't like
      /// it and gets grumpy about what type is encapsulated. So, we have to do
      /// this little dance. (29 Jun 18) Swift 4.1
      switch value {
      case let valueOptional as [BVAnyEncodable]:
        copyResult[thisLabel] = valueOptional
      case let valueOptional as [Encodable]:
        var wrapper = [BVAnyEncodable]()
        valueOptional.forEach { wrapper.append(BVAnyEncodable($0)) }
        copyResult[thisLabel] = wrapper
      case let valueOptional as Any?:
        if case let .some(thisValue) = valueOptional,
          let encoded = thisValue as? Encodable {
          copyResult[thisLabel] = encoded
        }
      }
      
      return copyResult
    }
    
    return core + additional
  }
}

extension BVAnalyticsEvent {
  
  internal static var idfaKey: String = "advertisingId"
  internal static var loadIdKey: String = "loadId"
  
  internal static var whiteList: [String] {
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
  
  internal static func commonAnalyticsValues(
    _ anonymous: () -> Bool) -> [String: String] {
    
    guard let idfa = BVFingerprint.shared.idfa, !anonymous() else {
      return [idfaKey: BVFingerprint.shared.nontrackingIDFA]
    }
    
    return [
      "mobileSource": "bv-ios-sdk",
      "HashedIP": "default",
      "source": "native-mobile-sdk",
      "UA": BVFingerprint.shared.bvid,
      idfaKey: idfa
    ]
  }
  
  internal static func clientIdentifier(
    _ clientId: String) -> [String: BVAnyEncodable] {
    return ["client": BVAnyEncodable(clientId)]
  }
  
  internal static func loadId(_ length: UInt = 10) -> [String: String]? {
    guard let randomString = String.random(length) else {
      return nil
    }
    return [loadIdKey: randomString]
  }
}

internal protocol BVAnalyticsEventable {
  func serialize(_ anonymous: Bool) -> [String: BVAnyEncodable]
  mutating func augment(_ additional: [String: BVAnyEncodable]?)
}

internal typealias BVAnalyticsEventInstance =
  (event: BVAnalyticsEventable,
  configuration: BVAnalyticsConfiguration,
  anonymous: Bool,
  overrides: [String: BVAnyEncodable]?)
