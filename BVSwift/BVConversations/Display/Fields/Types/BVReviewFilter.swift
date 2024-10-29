//
//  BVReviewFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVReview[s|Search]Query
/// - Note:
/// \
/// Used for conformance with the BVQueryFilterable protocol.
public enum BVReviewFilter: BVQueryFilter {
  
  case authorId(String)
  case campaignId(String)
  case categoryAncestorId(String)
  case contentLocale(Locale)
  case hasComments(Bool)
  case hasPhotos(Bool)
  case hasTags(Bool)
  case hasVideos(Bool)
  case isFeatured(Bool)
  case isRatingsOnly(Bool)
  case isRecommended(Bool)
  case isSubjectActive(Bool)
  case isSyndicated(Bool)
  case lastModeratedTime(Date)
  case lastModificationTime(Date)
  case moderatorCode(String)
  case productId(String)
  case rating(Int)
  case reviewId(String)
  case submissionId(String)
  case submissionTime(Date)
  case totalCommentCount(Int)
  case totalInappropriateFeedbackCount(Int)
  case totalFeedbackCount(Int)
  case totalNegativeFeedbackCount(Int)
  case totalPositiveFeedbackCount(Int)
  case userLocation(String)
  case contextDataValue(id: String, value: String)
  case secondaryRating(id: String, value: String)
  case additionalField(id: String, value: String)
  case tagDimension(id: String, value: String)
  
  public static var filterPrefix: String {
    return BVConversationsConstants.BVQueryFilter.defaultField
  }
  
  public static var filterTypeSeparator: String {
    return BVConversationsConstants.BVQueryFilter.typeSeparatorField
  }
  
  public static var filterValueSeparator: String {
    return BVConversationsConstants.BVQueryFilter.valueSeparatorField
  }
  
  public var description: String {
    return internalDescription
  }
  
  public var representedValue: CustomStringConvertible {
    switch self {
    case let .authorId(filter):
      return filter
    case let .campaignId(filter):
      return filter
    case let .categoryAncestorId(filter):
      return filter
    case let .contentLocale(filter):
      return filter.identifier
    case let .hasComments(filter):
      return filter
    case let .hasPhotos(filter):
      return filter
    case let .hasTags(filter):
      return filter
    case let .hasVideos(filter):
      return filter
    case let .isFeatured(filter):
      return filter
    case let .isRatingsOnly(filter):
      return filter
    case let .isRecommended(filter):
      return filter
    case let .isSubjectActive(filter):
      return filter
    case let .isSyndicated(filter):
      return filter
    case let .lastModeratedTime(filter):
      return filter.toBVFormat
    case let .lastModificationTime(filter):
      return filter.toBVFormat
    case let .moderatorCode(filter):
      return filter
    case let .productId(filter):
      return filter
    case let .rating(filter):
      return filter
    case let .reviewId(filter):
      return filter
    case let .submissionId(filter):
      return filter
    case let .submissionTime(filter):
      return filter.toBVFormat
    case let .totalCommentCount(filter):
      return filter
    case let .totalInappropriateFeedbackCount(filter):
      return filter
    case let .totalFeedbackCount(filter):
      return filter
    case let .totalNegativeFeedbackCount(filter):
      return filter
    case let .totalPositiveFeedbackCount(filter):
      return filter
    case let .userLocation(filter):
      return filter
    case let .contextDataValue(_, filter):
      return filter
    case let .secondaryRating(_, filter):
      return filter
    case let .additionalField(_, filter):
      return filter
    case let .tagDimension(_, filter):
      return filter
    }
  }
}

extension BVReviewFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .authorId:
      return BVConversationsConstants.BVReviews.Keys.authorId
    case .campaignId:
      return BVConversationsConstants.BVReviews.Keys.campaignId
    case .categoryAncestorId:
      return BVConversationsConstants.BVReviews.Keys.categoryAncestorId
    case .contentLocale:
      return BVConversationsConstants.BVReviews.Keys.contentLocale
    case .hasComments:
      return BVConversationsConstants.BVReviews.Keys.hasComments
    case .hasPhotos:
      return BVConversationsConstants.BVReviews.Keys.hasPhotos
    case .hasTags:
      return BVConversationsConstants.BVReviews.Keys.hasTags
    case .hasVideos:
      return BVConversationsConstants.BVReviews.Keys.hasVideos
    case .isFeatured:
      return BVConversationsConstants.BVReviews.Keys.isFeatured
    case .isRatingsOnly:
      return BVConversationsConstants.BVReviews.Keys.isRatingsOnly
    case .isRecommended:
      return BVConversationsConstants.BVReviews.Keys.isRecommended
    case .isSubjectActive:
      return BVConversationsConstants.BVReviews.Keys.isSubjectActive
    case .isSyndicated:
      return BVConversationsConstants.BVReviews.Keys.isSyndicated
    case .lastModeratedTime:
      return BVConversationsConstants.BVReviews.Keys.lastModeratedTime
    case .lastModificationTime:
      return BVConversationsConstants.BVReviews.Keys.lastModificationTime
    case .moderatorCode:
      return BVConversationsConstants.BVReviews.Keys.moderatorCode
    case .productId:
      return BVConversationsConstants.BVReviews.Keys.productId
    case .rating:
      return BVConversationsConstants.BVReviews.Keys.rating
    case .reviewId:
      return BVConversationsConstants.BVReviews.Keys.reviewId
    case .submissionId:
      return BVConversationsConstants.BVReviews.Keys.submissionId
    case .submissionTime:
      return BVConversationsConstants.BVReviews.Keys.submissionTime
    case .totalCommentCount:
      return BVConversationsConstants.BVReviews.Keys.totalCommentCount
    case .totalInappropriateFeedbackCount:
      return BVConversationsConstants.BVReviews.Keys.totalInappropriateFeedbackCount
    case .totalFeedbackCount:
      return BVConversationsConstants.BVReviews.Keys.totalFeedbackCount
    case .totalNegativeFeedbackCount:
      return BVConversationsConstants.BVReviews.Keys
        .totalNegativeFeedbackCount
    case .totalPositiveFeedbackCount:
      return BVConversationsConstants.BVReviews.Keys
        .totalPositiveFeedbackCount
    case .userLocation:
      return BVConversationsConstants.BVReviews.Keys.userLocation
    case let .contextDataValue(field, _):
      return BVConversationsConstants
        .BVReviews.Keys.contextDataValue + "_" + field
    case let .secondaryRating(field, _):
      return BVConversationsConstants
        .BVReviews.Keys.secondaryRating + "_" + field
    case let .additionalField(field, _):
      return BVConversationsConstants
        .BVReviews.Keys.additionalField + "_" + field
    case let .tagDimension(field, _):
      return BVConversationsConstants
        .BVReviews.Keys.tagDimension + "_" + field
    }
  }
}
