//
//
//  BVProductAttribute.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVProductAttribute type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVProductAttribute: BVAuxiliaryable {
  public let productAttributeId: String?
  public let values: [BVProductAttributeValue]?
  
  private enum CodingKeys: String, CodingKey {
    case productAttributeId = "Id"
    case values = "Values"
  }
}

/// The definition for the BVProductAttributeValue type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVProductAttributeValue: BVAuxiliaryable {
  public let locale: String?
  public let value: String?
  
  private enum CodingKeys: String, CodingKey {
    case locale = "Locale"
    case value = "Value"
  }
}
