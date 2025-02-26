//
//
//  BVAnalyticsProductType.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

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

  /// Type when product sentiments leveraged
  case productSentiments

  public func encode(to encoder: Encoder) throws {
    switch self {
    case .curations:
      try "Curations".encode(to: encoder)
    case .profile:
      try "Profiles".encode(to: encoder)
    case .question:
      try "AskAndAnswer".encode(to: encoder)
    case .recommendations:
      try "Personalization".encode(to: encoder)
    case .reviews:
      try "RatingsAndReviews".encode(to: encoder)
    case .productSentiments:
        try "ProductSentiments".encode(to: encoder)
    }
  }
}
