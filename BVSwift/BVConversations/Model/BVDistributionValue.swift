//
//  BVDistributionValue.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVDistributionValue type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVDistributionValue: BVAuxiliaryable {
  public let count: Int?
  public let value: String?
  public let valueLabel: String?
  
  private enum CodingKeys: String, CodingKey {
    case count = "Count"
    case value = "Value"
    case valueLabel = "ValueLabel"
  }
}
