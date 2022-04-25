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
  public let localizedFeature: String
  
  private enum CodingKeys: String, CodingKey {
    case feature = "feature"
    case localizedFeature = "localizedFeature"
  }
}
  



