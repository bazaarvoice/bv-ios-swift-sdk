//
//
//  BVCurationsReviewStatistics.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsReviewStatistics type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVCurationsReviewStatistics: BVAuxiliaryable {
  public let averageOverallRating: Double?
  public var contextDataDistribution: [BVCurationsDistributionElement]? {
    return contextDataDistributionArray?.array
  }
  private let contextDataDistributionArray: BVCodableDictionary<BVCurationsDistributionElement>?
  public let featuredReviewCount: Int?
  public var firstSubmissionTime: Date? {
    return firstSubmissionTimeString?.toBVDate()
  }
  private let firstSubmissionTimeString: String?
  public let helpfulVoteCount: Int?
  public var lastSubmissionTime: Date? {
    return lastSubmissionTimeString?.toBVDate()
  }
  private let lastSubmissionTimeString: String?
  public let notHelpfulVoteCount: Int?
  public let notRecommendedCount: Int?
  public let overallRatingRange: Int?
  public let ratingDistribution: BVCurationsRatingDistribution?
  public let ratingsOnlyReviewCount: Int?
  public let recommendedCount: Int?
  public var secondaryRatingsAverages: [BVCurationsSecondaryRatingsAverage]? {
    return secondaryRatingsAveragesArray?.array
  }
  private let secondaryRatingsAveragesArray: BVCodableDictionary<BVCurationsSecondaryRatingsAverage>?
  public var tagDistribution: [BVCurationsDistributionElement]? {
    return tagDistributionArray?.array
  }
  private let tagDistributionArray: BVCodableDictionary<BVCurationsDistributionElement>?
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
