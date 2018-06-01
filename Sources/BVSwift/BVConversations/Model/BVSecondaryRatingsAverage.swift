//
//  BVSecondaryRatingsAverage.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVSecondaryRatingsAverage type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVSecondaryRatingsAverage: BVAuxiliaryable {
  let averageRating: Double?
  let secondaryRatingsId: String?
  
  private enum CodingKeys: String, CodingKey {
    case averageRating = "AverageRating"
    case secondaryRatingsId = "Id"
  }
}
