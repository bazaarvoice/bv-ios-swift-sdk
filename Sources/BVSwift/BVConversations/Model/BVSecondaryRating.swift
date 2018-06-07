//
//  BVSecondaryRating.swift
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVSecondaryRating type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVSecondaryRating: BVAuxiliaryable {
  public let displayType: String?
  public let label: String?
  public let maxLabel: String?
  public let minLabel: String?
  public let secondaryRatingId: String?
  public let value: Int?
  public let valueLabel: String?
  public let valueRange: Int?
  
  private enum CodingKeys: String, CodingKey {
    case displayType = "DisplayType"
    case label = "Label"
    case maxLabel = "MaxLabel"
    case minLabel = "MinLabel"
    case secondaryRatingId = "Id"
    case value = "Value"
    case valueLabel = "ValueLabel"
    case valueRange = "ValueRange"
  }
}
