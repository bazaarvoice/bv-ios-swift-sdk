//
//
//  BVAnalyticsImpressionType.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

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
    case .comment:
      try "Comment".encode(to: encoder)
    case .feedItem:
      try "SocialPost".encode(to: encoder)
    case .productRecommendation:
      try "Recommendation".encode(to: encoder)
    case .question:
      try "Question".encode(to: encoder)
    case .review:
      try "Review".encode(to: encoder)
    }
  }
}
