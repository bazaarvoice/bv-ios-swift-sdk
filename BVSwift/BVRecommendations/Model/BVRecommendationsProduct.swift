//
//
//  BVRecommendationsProduct.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVRecommendationsProduct type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVRecommendationsProduct: BVAuxiliaryable {
  public let averageRating: Double?
  public let categoryIds: [String]?
  public let client: String?
  public let imageURL: URL?
  public let interests: [String]?
  public let numberOfReviews: Int?
  public let productId: String?
  public let productName: String?
  public let productPageURL: URL?
  internal let RS: String?
  public let sponsored: Bool?
  internal var stats: BVRecommendationsStats?
  
  private enum CodingKeys: String, CodingKey {
    case averageRating = "avg_rating"
    case categoryIds = "category_ids"
    case client
    case imageURL = "image_url"
    case interests
    case numberOfReviews = "num_reviews"
    case productId = "product"
    case productName = "name"
    case productPageURL = "product_page_url"
    case RS
    case sponsored
  }
}

extension BVRecommendationsProduct: BVRecommendationsQueryStatsUpdateable {
  internal mutating func update(_ any: Any?) { }
  
  internal mutating
  func update(_ stats: BVRecommendationsStats) {
    self.stats = stats
  }
}

