//
//  BVContextDataValue.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVContextDataValue: Codable {
  let value: String?
  let valueLabel: String?
  let contextDataValueId: String?
  let dimensionLabel: String?
  
  private enum CodingKeys: String, CodingKey {
    case value = "Value"
    case valueLabel = "ValueLabel"
    case contextDataValueId = "Id"
    case dimensionLabel = "DimensionLabel"
  }
}
