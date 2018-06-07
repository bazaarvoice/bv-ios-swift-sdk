//
//  BVContextDataValue.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVContextDataValue type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVContextDataValue: BVAuxiliaryable {
  public let value: String?
  public let valueLabel: String?
  public let contextDataValueId: String?
  public let dimensionLabel: String?
  
  private enum CodingKeys: String, CodingKey {
    case value = "Value"
    case valueLabel = "ValueLabel"
    case contextDataValueId = "Id"
    case dimensionLabel = "DimensionLabel"
  }
}
