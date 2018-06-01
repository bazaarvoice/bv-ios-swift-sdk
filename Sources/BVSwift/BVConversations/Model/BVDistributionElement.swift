//
//  BVDistributionElement.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVDistributionElement type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVDistributionElement: BVAuxiliaryable {
  let distibutionElementId: String?
  let label: String?
  let values: [BVDistributionValue]?
  
  private enum CodingKeys: String, CodingKey {
    case distibutionElementId = "Id"
    case label = "Label"
    case values = "Values"
  }
}
