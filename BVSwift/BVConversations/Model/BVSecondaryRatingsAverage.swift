//
//  BVSecondaryRatingsAverage.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVSecondaryRatingsAverage type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVSecondaryRatingsAverage: BVAuxiliaryable {
  public let averageRating: Double?
  public let secondaryRatingsId: String?
  public let valueRange: Int?
  public let displayType: String?
  public let minLabel: String?
  public let maxLabel: String?
  public let label: String?
  public let valueLabel: [String]?
  
  private enum CodingKeys: String, CodingKey {
    case averageRating = "AverageRating"
    case secondaryRatingsId = "Id"
    case valueRange = "ValueRange"
    case displayType = "DisplayType"
    case minLabel = "MinLabel"
    case maxLabel = "MaxLabel"
    case label = "Label"
    case valueLabel = "ValueLabel"
  }
}
