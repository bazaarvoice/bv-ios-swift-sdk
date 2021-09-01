//
//
//  BVRecommendationsProfile.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVRecommendationsProfile type
/// - Note:
/// \
/// It conforms to BVQueryable and, therefore, it is used only for BVQuery.
public struct BVRecommendationsProfile: BVQueryable {
  public static var singularKey: String {
    return BVRecommendationsConstants.BVRecommendationsProfile.singularKey
  }
  
  public static var pluralKey: String {
    return BVRecommendationsConstants.BVRecommendationsProfile.singularKey
  }
  
  public let brandInterests: BVRecommendationsInterest?
  public var categories: [BVRecommendationsCategory]? {
    return categoriesDict?.array
  }
  private let categoriesDict: BVCodableDictionary<BVRecommendationsCategory>?
  public let categoryRecommendations: [String]?
  public let categoryPlan: String?
  public let interests: BVRecommendationsInterest?
  public let plan: String?
  public let products: [BVRecommendationsProduct]?
  private let productsDict: BVCodableDictionary<BVRecommendationsProduct>?
  public let recommendations: [String]?
  internal let recommendationStats: BVRecommendationsStats?
  
  private enum CodingKeys: String, CodingKey {
    case brandInterests = "brands"
    case categoriesDict = "categories"
    case categoryRecommendations = "category_recommendations"
    case categoryPlan = "category_plan"
    case interests = "interests"
    case plan = "plan"
    case productsDict = "products"
    case recommendations = "recommendations"
    case recommendationStats
  }
}

extension BVRecommendationsProfile {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.brandInterests =
      try container.decodeIfPresent(
        BVRecommendationsInterest.self, forKey: .brandInterests)
    self.categoriesDict =
      try container.decodeIfPresent(
        BVCodableDictionary<BVRecommendationsCategory>.self,
        forKey: .categoriesDict)
    self.categoryRecommendations =
      try container.decodeIfPresent(
        [String].self, forKey: .categoryRecommendations)
    self.categoryPlan =
      try container.decodeIfPresent(String.self, forKey: .categoryPlan)
    self.interests =
      try container.decodeIfPresent(
        BVRecommendationsInterest.self, forKey: .interests)
    self.plan = try container.decodeIfPresent(String.self, forKey: .plan)
    self.productsDict =
      try container.decodeIfPresent(
        BVCodableDictionary<BVRecommendationsProduct>.self,
        forKey: .productsDict)
    self.recommendations =
      try container.decodeIfPresent([String].self, forKey: .recommendations)
    self.recommendationStats =
      try container.decodeIfPresent(
        BVRecommendationsStats.self, forKey: .recommendationStats)
    
    if let products = productsDict?.array,
      let stats = self.recommendationStats {
      self.products = products.map {
        (prod: BVRecommendationsProduct) -> BVRecommendationsProduct in
        var product = prod
        product.update(stats)
        return product
      }
    } else {
      self.products = nil
    }
  }
}

extension BVRecommendationsProfile: BVQueryableInternal {
  internal static var getResource: String? {
    return BVRecommendationsConstants.BVRecommendationsProfile.getResource + "nontracking"
  }
}
