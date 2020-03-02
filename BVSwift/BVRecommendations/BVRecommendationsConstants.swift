//
//
//  BVRecommendationsConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVRecommendationsConstants {
  static let bvProduct: String = "Personalization"
  static let apiKey: String = "apiKeyShopperAdvertising"
  static let stagingEndpoint: String =
  "https://my.network-stg.bazaarvoice.com/"
  static let productionEndpoint: String =
  "https://my.network.bazaarvoice.com/"
  static let clientKey: String = "client"
  static let parameterKey: String = "passKey"
  
  internal struct BVRecommendationsProfile {
    static let singularKey: String = "profile"
    static let pluralKey: String = "profiles"
    static let getResource: String = "recommendations/magpie_idfa_"
  }
  
  internal struct BVRecommendationsQueryField {
    static let allowInactiveProducts: String = "allow_inactive_products"
    static let averageRating: String = "min_avg_rating"
    static let brandId: String = "bvbrandid"
    static let preferredCategory: String = "category"
    static let include: String = "include"
    static let interest: String = "interest"
    static let locale: String = "locale"
    static let lookback: String = "lookback"
    static let product: String = "product"
    static let purpose: String = "purpose"
    static let requiredCategory: String = "required_category"
    static let strategies: String = "strategies"
  }
  
  internal struct BVRecommendationsQueryInclude {
    static let defaultField: String = "include"
  }
}
