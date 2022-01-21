//
//
//  BVFeature.swift
//  BVSwift
//
//  Copyright © 2021 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVFeature: BVAuxiliaryable {
  
  

  public let feature: String
  public let localized_feature: String
  
  private enum CodingKeys: String, CodingKey {
    case feature = "feature"
    case localized_feature = "localizedFeature"
  }
}
  



