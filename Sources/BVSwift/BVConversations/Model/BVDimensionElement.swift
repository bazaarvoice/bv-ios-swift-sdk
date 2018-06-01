//
//  BVDimensionElement.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVDimensionElement type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVDimensionElement: BVAuxiliaryable {
  let dimensionElementId: String?
  let label: String?
  let values: [String]?
  
  private enum CodingKeys: String, CodingKey {
    case dimensionElementId = "Id"
    case label = "Label"
    case values = "Values"
  }
}
