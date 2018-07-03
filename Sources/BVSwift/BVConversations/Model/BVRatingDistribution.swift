//
//  BVRatingDistribution.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVRatingDistribution type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVRatingDistribution: BVAuxiliaryable {

  public let oneStarCount: Int?
  public let twoStarCount: Int?
  public let threeStarCount: Int?
  public let fourStarCount: Int?
  public let fiveStarCount: Int?

  private struct BVRating: Codable {
    let ratingValue: Int?
    let count: Int?

    private enum CodingKeys: String, CodingKey {
      case ratingValue = "RatingValue"
      case count = "Count"
    }
  }

  public init(from decoder: Decoder) throws {
    var unkeyedContainer = try decoder.unkeyedContainer()
    let ratingArray: [BVRating] =
      try unkeyedContainer.decodeArray(BVRating.self)

    /// This is ridiculous that we have to do this but for whatever reason
    /// Swift currently doesn't like any closure/loop where let constants can
    /// be initialized. So we have to zip up the objects into a dictionary. I
    /// could have walked these using container API but I think the code would
    /// look even worse.
    let ratingDict: [Int: Int] =
      ratingArray.reduce([:])
      { (result: [Int: Int], rating: BVRating) -> [Int: Int] in
        var new: [Int: Int] = result
        if let value: Int = rating.ratingValue,
          let count: Int = rating.count {
          new[value] = count
        }
        return new
    }

    oneStarCount = ratingDict[1].map { $0 } ?? 0
    twoStarCount = ratingDict[2].map { $0 } ?? 0
    threeStarCount = ratingDict[3].map { $0 } ?? 0
    fourStarCount = ratingDict[4].map { $0 } ?? 0
    fiveStarCount = ratingDict[5].map { $0 } ?? 0
  }
}
