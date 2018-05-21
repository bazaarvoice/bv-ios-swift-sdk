//
//  BVSecondaryRating.swift
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVSecondaryRating: Codable {
  let displayType: String?
  let label: String?
  let maxLabel: String?
  let minLabel: String?
  let secondaryRatingId: String?
  let value: Int?
  let valueLabel: String?
  let valueRange: Int?
  
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
