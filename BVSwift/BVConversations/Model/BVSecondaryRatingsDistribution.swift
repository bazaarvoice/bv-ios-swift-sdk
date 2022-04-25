//
//
//  BVSecondaryRatingsDistribution.swift
//  BVSwift
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVSecondaryRatingsDistribution type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVSecondaryRatingsDistribution: BVAuxiliaryable {
  public let secondaryDistributionId: String?
  public let values: [BVSecondaryRatingsDistributionValue]?
  public let label: String?
  
  private enum CodingKeys: String, CodingKey {
    case secondaryDistributionId = "Id"
    case values = "Values"
    case label = "Label"
  }
}
