//
//
//  BVCurationsSecondaryRatingsAverage.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsSecondaryRatingsAverage type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVCurationsSecondaryRatingsAverage: BVAuxiliaryable {
  public let averageRating: Double?
  public let secondaryRatingsId: String?
  
  private enum CodingKeys: String, CodingKey {
    case averageRating = "AverageRating"
    case secondaryRatingsId = "Id"
  }
}
