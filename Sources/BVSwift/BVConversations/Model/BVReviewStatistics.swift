//
//  BVReviewStatistics.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public struct BVReviewStatistics: Codable {
  let averageOverallRating: Double?
  var contextDataDistribution: [BVDistributionElement]? {
    get {
      return contextDataDistributionArray?.array
    }
  }
  private let contextDataDistributionArray:
  BVCodableDictionary<BVDistributionElement>?
  let featuredReviewCount: Int?
  var firstSubmissionTime: Date? {
    get {
      return firstSubmissionTimeString?.toBVDate()
    }
  }
  private let firstSubmissionTimeString: String?
  let helpfulVoteCount: Int?
  var lastSubmissionTime: Date? {
    get {
      return lastSubmissionTimeString?.toBVDate()
    }
  }
  private let lastSubmissionTimeString: String?
  let notHelpfulVoteCount: Int?
  let notRecommendedCount: Int?
  let overallRatingRange: Int?
  let ratingDistribution: BVRatingDistribution?
  let ratingsOnlyReviewCount: Int?
  let recommendedCount: Int?
  var secondaryRatingsAverages: [BVSecondaryRatingsAverage]? {
    get {
      return secondaryRatingsAveragesArray?.array
    }
  }
  let secondaryRatingsAveragesArray:
  BVCodableDictionary<BVSecondaryRatingsAverage>?
  var tagDistribution: [BVDistributionElement]? {
    get {
      return contextDataDistributionArray?.array
    }
  }
  private let tagDistributionArray:
  BVCodableDictionary<BVDistributionElement>?
  let totalReviewCount: Int?
  
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
