//
//
//  BVCurationsDistributionValue.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsDistributionValue type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVCurationsDistributionValue: BVAuxiliaryable {
  public let count: Int?
  public let value: String?
  
  private enum CodingKeys: String, CodingKey {
    case count = "Count"
    case value = "Value"
  }
}
