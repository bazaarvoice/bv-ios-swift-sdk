//
//  BVBrand.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVBrand type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVBrand: BVAuxiliaryable {
  let brandId: String?
  let name: String?
  
  private enum CodingKeys: String, CodingKey {
    case brandId = "Id"
    case name = "Name"
  }
}
