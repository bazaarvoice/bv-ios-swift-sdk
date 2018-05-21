//
//  BVDistributionElement.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVDistributionElement: Codable {
  let distibutionElementId: String?
  let label: String?
  let values: [BVDistributionValue]?
  
  private enum CodingKeys: String, CodingKey {
    case distibutionElementId = "Id"
    case label = "Label"
    case values = "Values"
  }
}
