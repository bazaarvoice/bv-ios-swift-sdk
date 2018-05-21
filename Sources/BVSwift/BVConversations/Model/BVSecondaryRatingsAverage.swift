//
//  BVSecondaryRatingsAverage.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVSecondaryRatingsAverage: Codable {
  let averageRating: Double?
  let secondaryRatingsId: String?
  
  private enum CodingKeys: String, CodingKey {
    case averageRating = "AverageRating"
    case secondaryRatingsId = "Id"
  }
}
