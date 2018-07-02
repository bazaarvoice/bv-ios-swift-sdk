//
//
//  BVCurationsDistributionElement.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsDistributionElement type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVCurationsDistributionElement: BVAuxiliaryable {
  public let distibutionElementId: String?
  public let label: String?
  public let values: [BVCurationsDistributionValue]?
  
  private enum CodingKeys: String, CodingKey {
    case distibutionElementId = "Id"
    case label = "Label"
    case values = "Values"
  }
}
