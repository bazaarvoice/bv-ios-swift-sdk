//
//
//  BVRecommendationsCategory.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVRecommendationsCategory type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVRecommendationsCategory: BVAuxiliaryable {
  public let category: String?
  public let client: String?
  public let name: String?
}
