//
//  BVReviewStatistics.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// The definition for the BVReviewStatistics type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVReviewStatistics: BVAuxiliaryable {
  public let averageOverallRating: Double?
  public var contextDataDistribution: [BVDistributionElement]? {
    get {
      return contextDataDistributionArray?.array
    }
  }
  private let contextDataDistributionArray:
  BVCodableDictionary<BVDistributionElement>?
  public let featuredReviewCount: Int?
  public var firstSubmissionTime: Date? {
    get {
      return firstSubmissionTimeString?.toBVDate()
    }
  }
  private let firstSubmissionTimeString: String?
  public let helpfulVoteCount: Int?
  public var lastSubmissionTime: Date? {
    get {
      return lastSubmissionTimeString?.toBVDate()
    }
  }
  private let lastSubmissionTimeString: String?
  public let notHelpfulVoteCount: Int?
  public let notRecommendedCount: Int?
  public let overallRatingRange: Int?
  public let ratingDistribution: BVRatingDistribution?
  public let ratingsOnlyReviewCount: Int?
  public let recommendedCount: Int?
  public var secondaryRatingsAverages: [BVSecondaryRatingsAverage]? {
    get {
      return secondaryRatingsAveragesArray?.array
    }
  }
  private let secondaryRatingsAveragesArray:
  BVCodableDictionary<BVSecondaryRatingsAverage>?
  public var tagDistribution: [BVDistributionElement]? {
    get {
      return contextDataDistributionArray?.array
    }
  }
  private let tagDistributionArray:
  BVCodableDictionary<BVDistributionElement>?
  public let totalReviewCount: Int?
  
  private enum CodingKeys: String, CodingKey {
    case averageOverallRating = "AverageOverallRating"
    case contextDataDistributionArray = "ContextDataDistribution"
    case featuredReviewCount = "FeaturedReviewCount"
    case firstSubmissionTimeString = "FirstSubmissionTime"
    case helpfulVoteCount = "HelpfulVoteCount"
    case lastSubmissionTimeString = "LastSubmissionTime"
    case notHelpfulVoteCount = "NotHelpfulVoteCount"
    case notRecommendedCount = "NotRecommendedCount"
    case overallRatingRange = "OverallRatingRange"
    case ratingDistribution = "RatingDistribution"
    case ratingsOnlyReviewCount = "RatingsOnlyReviewCount"
    case recommendedCount = "RecommendedCount"
    case secondaryRatingsAveragesArray = "SecondaryRatingsAverages"
    case tagDistributionArray = "TagDistribution"
    case totalReviewCount = "TotalReviewCount"
  }
}
