//
//
//  BVAnalyticsTypes.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The BVAnalyticsFeatureType enum to be used within the
/// BVAnalyticsEvent feature type.
public enum BVAnalyticsFeatureType: Encodable {
  
  /// Type when conversations answer has been generated
  case answerQuestion
  
  /// Type when conversations question has been generated
  case askQuestion
  
  /// Type when content has been clicked on
  case contentClick
  
  /// Type when conversations feedback has been generated
  case feedback
  
  /// Type when conversations inappropriate feedback has been flagged
  case inappropriate
  
  /// Type when consumer-generated content is made visible
  case inView
  
  /// Type when user photo has been uploaded
  case photo
  
  /// Type when user profile has been viewed, edited, etc.
  case profile
  
  /// Type when conversations comment has been generated
  case reviewComment
  
  /// Type when content has scrolled
  case scrolled
  
  /// Type when conversations review has been generated
  case writeReview
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .answerQuestion:
      try "Answer".encode(to: encoder)
      break
    case .askQuestion:
      try "Question".encode(to: encoder)
      break
    case .contentClick:
      try "Click".encode(to: encoder)
      break
    case .feedback:
      try "Helpfulness".encode(to: encoder)
      break
    case .inappropriate:
      try "Inappropriate".encode(to: encoder)
      break
    case .inView:
      try "InView".encode(to: encoder)
      break
    case .photo:
      try "Photo".encode(to: encoder)
      break
    case .profile:
      try "Profile".encode(to: encoder)
      break
    case .reviewComment:
      try "Comment".encode(to: encoder)
      break
    case .scrolled:
      try "Scrolled".encode(to: encoder)
      break
    case .writeReview:
      try "Write".encode(to: encoder)
      break
    }
  }
}

/// The BVAnalyticsFeatureType enum to be used within the
/// BVAnalyticsEvent impression type.
public enum BVAnalyticsImpressionType: Encodable {
  
  /// Type when conversations answer has been requested
  case answer
  
  /// Type when conversations comment has been requested
  case comment
  
  /// Type when feed item(s) has been requested
  case feedItem
  
  /// Type when product recommendation has been requested
  case productRecommendation
  
  /// Type when conversations question has been requested
  case question
  
  /// Type when conversations review has been requested
  case review
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .answer:
      try "Answer".encode(to: encoder)
      break
    case .comment:
      try "Comment".encode(to: encoder)
      break
    case .feedItem:
      try "SocialPost".encode(to: encoder)
      break
    case .productRecommendation:
      try "Recommendation".encode(to: encoder)
      break
    case .question:
      try "Question".encode(to: encoder)
      break
    case .review:
      try "Review".encode(to: encoder)
      break
    }
  }
}

/// The BVAnalyticsFeatureType enum to be used within the various
/// BVAnalyticsEvent types.
public enum BVAnalyticsProductType: Encodable {
  
  /// Type when curations feature leveraged
  case curations
  
  /// Type when profile feature leveraged
  case profile
  
  /// Type when question feature leveraged
  case question
  
  /// Type when recommendations feature leveraged
  case recommendations
  
  /// Type when reviews feature leveraged
  case reviews
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .curations:
      try "Curations".encode(to: encoder)
      break
    case .profile:
      try "Profiles".encode(to: encoder)
      break
    case .question:
      try "AskAndAnswer".encode(to: encoder)
      break
    case .recommendations:
      try "Curations".encode(to: encoder)
      break
    case .reviews:
      try "Curations".encode(to: encoder)
      break
    }
  }
}

/// The BVAnalyticsTransactionItem struct to be used within the
/// BVAnalyticsEvent transaction type.
public struct BVAnalyticsTransactionItem: Codable {
  let category: String
  let imageURL: URL?
  let name: String?
  let price: Double
  let quantity: Int
  let sku: String
  
  private enum CodingKeys: String, CodingKey {
    case category = "category"
    case imageURL = "imageUrl"
    case name = "name"
    case price = "price"
    case quantity = "quantity"
    case sku = "sku"
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(category, forKey: .category)
    try container.encodeIfPresent(imageURL, forKey: .imageURL)
    try container.encodeIfPresent(name, forKey: .name)
    try container.encode(String(format: "%0.2f", price), forKey: .price)
    try container.encode(String(format: "%ld", quantity), forKey: .quantity)
    try container.encode(sku, forKey: .sku)
  }
}
