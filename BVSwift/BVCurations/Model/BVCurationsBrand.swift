//
//
//  BVCurationsBrand.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsBrand type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVCurationsBrand: BVAuxiliaryable {
  public let brandId: String?
  public let name: String?
  
  private enum CodingKeys: String, CodingKey {
    case brandId = "Id"
    case name = "Name"
  }
}
