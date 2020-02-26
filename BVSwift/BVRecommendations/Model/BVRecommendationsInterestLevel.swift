//
//
//  BVRecommendationsInterestLevel.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public typealias BVRecommendationsInterest =
  [String: BVRecommendationsInterestLevel]

/// The definition for the BVRecommendationsInterestLevel type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public enum BVRecommendationsInterestLevel: BVAuxiliaryable {
  
  private static var lowValue = "LOW"
  private static var mediumValue = "MED"
  private static var highValue = "HIGH"
  
  case low
  case medium
  case high
  
  internal enum CodingError: Error {
    case invalidInitValue
  }
  
  internal init(_ stringValue: String) throws {
    switch stringValue.lowercased() {
    case BVRecommendationsInterestLevel.lowValue.lowercased():
      self = .low
    case BVRecommendationsInterestLevel.mediumValue.lowercased():
      self = .medium
    case BVRecommendationsInterestLevel.highValue.lowercased():
      self = .high
    default:
      throw CodingError.invalidInitValue
    }
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let stringValue: String = try container.decode(String.self)
    try self.init(stringValue)
  }
  
  public func encode(to encoder: Encoder) throws {
    switch self {
    case .low:
      try BVRecommendationsInterestLevel.lowValue.encode(to: encoder)
    case .medium:
      try BVRecommendationsInterestLevel.mediumValue.encode(to: encoder)
    case .high:
      try BVRecommendationsInterestLevel.highValue.encode(to: encoder)
    }
  }
}
