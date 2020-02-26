//
//
//  BVRecommendationsStats.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVRecommendationsStats type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
internal struct BVRecommendationsStats: BVAuxiliaryable {
  public let activeUser: Bool?
  public let RKB: Int?
  public let RKC: Int?
  public let RKI: Int?
  public let RKN: Int?
  public let RKP: Int?
  public let RKR: Int?
  public let RKT: Int?
  
  internal subscript(stat: CodingKeys) -> Int? {
    switch stat {
    case .RKB:
      return RKB
    case .RKC:
      return RKC
    case .RKI:
      return RKI
    case .RKN:
      return RKN
    case .RKP:
      return RKP
    case .RKR:
      return RKR
    case .RKT:
      return RKT
    default:
      return nil
    }
  }
  
  internal enum CodingKeys: String, CodingKey {
    case activeUser
    case RKB
    case RKC
    case RKI
    case RKN
    case RKP
    case RKR
    case RKT
    
    static internal var all: [CodingKeys] {
      return [
        .RKB,
        .RKC,
        .RKI,
        .RKN,
        .RKP,
        .RKR,
        .RKT
      ]
    }
  }
}
