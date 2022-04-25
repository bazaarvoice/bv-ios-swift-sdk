//
//
//  BVSecondaryRatingsDistributionValue.swift
//  BVSwift
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVSecondaryDistribution type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVSecondaryRatingsDistributionValue: BVAuxiliaryable {
  public let count: Int?
  public let value: Int?
  public let valueLabel: String?
  
  private enum CodingKeys: String, CodingKey {
    case count = "Count"
    case value = "Value"
    case valueLabel = "ValueLabel"
  }
}
