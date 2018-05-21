//
//  BVDistributionValue.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVDistributionValue: Codable {
  let count: Int?
  let value: String?
  
  private enum CodingKeys: String, CodingKey {
    case count = "Count"
    case value = "Value"
  }
}
