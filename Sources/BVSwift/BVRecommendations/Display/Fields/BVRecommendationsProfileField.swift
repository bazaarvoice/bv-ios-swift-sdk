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
  
  case allowInactiveProducts(Bool)
  case avgRating(Double)
  case brandId(String)
  case include(BVRecommendationsProfileInclude)
  case interest(String)
  case locale(String)
  case lookback(Date)
  case preferredCategory(String)
  case product(String)
  case purpose(BVRecommendationsProfilePurpose)
  case requiredCategory(String)
  case strategies(String)
  
  public var description: String {
    return internalDescription
  }
  
  public var representedValue: CustomStringConvertible {
    switch self {
    case let .allowInactiveProducts(value):
      return value
    case let .avgRating(value):
      return value
    case let .brandId(value):
      return value
    case let .preferredCategory(value):
      return value
    case let .include(value):
      return value.rawValue
    case let .interest(value):
      return value
    case let .locale(value):
      return value
    case let .lookback(value):
      return value.timeIntervalSinceNow
    case let .product(value):
      return value
    case let .purpose(value):
      return value.rawValue
    case let .requiredCategory(value):
      return value
    case let .strategies(value):
      return value
    }
  }
}

extension BVRecommendationsProfileField: BVRecommendationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .allowInactiveProducts:
      return
        BVRecommendationsConstants
          .BVRecommendationsQueryField.allowInactiveProducts
    case .avgRating:
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
    case .lookback:
      return BVRecommendationsConstants.BVRecommendationsQueryField.lookback
    case .product:
      return BVRecommendationsConstants.BVRecommendationsQueryField.product
    case .purpose:
      return BVRecommendationsConstants.BVRecommendationsQueryField.purpose
    case .requiredCategory:
      return
        BVRecommendationsConstants
          .BVRecommendationsQueryField.requiredCategory
    case .strategies:
      return
        BVRecommendationsConstants.BVRecommendationsQueryField.strategies
    }
  }
}

// MARK: - BVRecommendationsProfileField: BVRecommendationsProfileField
extension BVRecommendationsProfileField: Hashable {
  public var hashValue: Int {
    return description.hashValue ^ "\(representedValue)".djb2hash
  }
  
  public static func == (lhs: BVRecommendationsProfileField,
                         rhs: BVRecommendationsProfileField) -> Bool {
    return lhs.description == rhs.description
      && "\(lhs.representedValue)" == "\(rhs.representedValue)"
  }
}
