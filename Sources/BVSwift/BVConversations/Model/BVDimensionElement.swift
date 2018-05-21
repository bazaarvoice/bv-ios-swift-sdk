//
//  BVDimensionElement.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVDimensionElement: Codable {
  let dimensionElementId: String?
  let label: String?
  let values: [String]?
  
  private enum CodingKeys: String, CodingKey {
    case dimensionElementId = "Id"
    case label = "Label"
    case values = "Values"
  }
}
