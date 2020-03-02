//
//
//  BVRecommendationsProfileField.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// BVRecommendation supported fields
/// - Note:
/// \
/// These are passed as query items to HTTPS requests.
public enum BVRecommendationsProfileField: BVQueryField {
  
  case averageRating(Double)
  case brandId(String)
  case include(BVRecommendationsProfileInclude)
  case interest(String)
  case locale(Locale)
  case preferredCategory(String)
  case product(String)
  case purpose(BVRecommendationsProfilePurpose)
  case requiredCategory(String)
  
  public var description: String {
    return internalDescription
  }
  
  public var representedValue: CustomStringConvertible {
    switch self {
      /*
       case let .allowInactiveProducts(value):
       return value
       */
    case let .averageRating(value):
      return String(format: "%.5f", value)
    case let .brandId(value):
      return value
    case let .preferredCategory(value):
      return value
    case let .include(value):
      return value.rawValue
    case let .interest(value):
      return value
    case let .locale(value):
      return value.identifier
      /*
       case let .lookback(value):
       let seconds = { () -> Int in
       let secondsComponent: DateComponents =
       Calendar.current.dateComponents(
       Set<Calendar.Component>([.second]), from: value, to: Date())
       let inSeconds: Int = (secondsComponent.second ?? 0)
       return (0 < inSeconds) ? inSeconds : 0
       }()
       return "\(seconds)s"
       */
    case let .product(value):
      return value
    case let .purpose(value):
      return value.rawValue
    case let .requiredCategory(value):
      return value
      /*
       case let .strategy(value):
       return value
       */
    }
  }
}

extension BVRecommendationsProfileField: BVRecommendationsQueryValue {
  internal var internalDescription: String {
    switch self {
      /*
       case .allowInactiveProducts:
       return
       BVRecommendationsConstants
       .BVRecommendationsQueryField.allowInactiveProducts
       */
    case .averageRating:
      return
        BVRecommendationsConstants.BVRecommendationsQueryField.averageRating
    case .brandId:
      return BVRecommendationsConstants.BVRecommendationsQueryField.brandId
    case .preferredCategory:
      return
        BVRecommendationsConstants
          .BVRecommendationsQueryField.preferredCategory
    case .include:
      return BVRecommendationsConstants.BVRecommendationsQueryField.include
    case .interest:
      return BVRecommendationsConstants.BVRecommendationsQueryField.interest
    case .locale:
      return BVRecommendationsConstants.BVRecommendationsQueryField.locale
      /*
       case .lookback:
       return BVRecommendationsConstants.BVRecommendationsQueryField.lookback
       */
    case .product:
      return BVRecommendationsConstants.BVRecommendationsQueryField.product
    case .purpose:
      return BVRecommendationsConstants.BVRecommendationsQueryField.purpose
    case .requiredCategory:
      return
        BVRecommendationsConstants
          .BVRecommendationsQueryField.requiredCategory
      /*
       case .strategy:
       return
       BVRecommendationsConstants.BVRecommendationsQueryField.strategies
       */
    }
  }
}

extension BVRecommendationsProfileField {
  internal static func % (lhs: BVRecommendationsProfileField,
                          rhs: BVRecommendationsProfileField) -> Bool {
    return { () -> Bool in
      switch (lhs, rhs) {
        /*
         case (.allowInactiveProducts, .allowInactiveProducts):
         fallthrough
         */
      case (.averageRating, .averageRating):
        fallthrough
      case (.brandId, .brandId):
        fallthrough
      case (.include, .include):
        fallthrough
      case (.interest, .interest):
        fallthrough
      case (.locale, .locale):
        fallthrough
        /*
         case (.lookback, .lookback):
         fallthrough
         */
      case (.preferredCategory, .preferredCategory):
        fallthrough
      case (.product, .product):
        fallthrough
      case (.purpose, .purpose):
        fallthrough
      case (.requiredCategory, .requiredCategory):
        return true
        /*
         case (.strategy, .strategy):
         return true
         */
      default:
        return false
      }
      }()
  }
}

// MARK: - BVRecommendationsProfileField: Hashable
extension BVRecommendationsProfileField: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(description)
    hasher.combine("\(representedValue)")
  }
  
  public static func == (lhs: BVRecommendationsProfileField,
                         rhs: BVRecommendationsProfileField) -> Bool {
    return (lhs % rhs) && "\(lhs.representedValue)" == "\(rhs.representedValue)"
  }
}
