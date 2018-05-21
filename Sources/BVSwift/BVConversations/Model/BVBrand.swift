//
//  BVBrand.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVBrand: Codable {
  let brandId: String?
  let name: String?
  
  private enum CodingKeys: String, CodingKey {
    case brandId = "Id"
    case name = "Name"
  }
}
