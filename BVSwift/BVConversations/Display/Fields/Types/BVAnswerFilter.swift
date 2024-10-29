//
//
//  BVAnswerFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVAnswerQuery
/// - Note:
/// \
/// Used for conformance with the BVQueryFilterable protocol.
public enum BVAnswerFilter: BVQueryFilter {
  
  case answerId(String)
  case authorId(String)
  case campaignId(String)
  case categoryAncestorId(String)
  case contentLocale(Locale)
  case hasPhotos(Bool)
  case isBestAnswer(Bool)
  case isBrandAnswer(Bool)
  case isFeatured(Bool)
  case lastModeratedTime(Date)
  case lastModificationTime(Date)
  case moderatorCode(String)
  case productId(String)
  case reviewId(String)
  case submissionId(String)
  case submissionTime(Date)
  case totalInappropriateFeedbackCount(Int)
  case totalFeedbackCount(Int)
  case totalNegativeFeedbackCount(Int)
  case totalPositiveFeedbackCount(Int)
  case userLocation(String)
  
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
    case let .answerId(filter):
      return filter
    case let .authorId(filter):
      return filter
    case let .campaignId(filter):
      return filter
    case let .categoryAncestorId(filter):
      return filter
    case let .contentLocale(filter):
      return filter.identifier
    case let .hasPhotos(filter):
      return filter
    case let .isBestAnswer(filter):
      return filter
    case let .isBrandAnswer(filter):
      return filter
    case let .isFeatured(filter):
      return filter
    case let .lastModeratedTime(filter):
      return filter.toBVFormat
    case let .lastModificationTime(filter):
      return filter.toBVFormat
    case let .moderatorCode(filter):
      return filter
    case let .productId(filter):
      return filter
    case let .reviewId(filter):
      return filter
    case let .submissionId(filter):
      return filter
    case let .submissionTime(filter):
      return filter.toBVFormat
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
    }
  }
}

extension BVAnswerFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .answerId:
      return BVConversationsConstants.BVAnswers.Keys.answerId
    case .authorId:
      return BVConversationsConstants.BVAnswers.Keys.authorId
    case .campaignId:
      return BVConversationsConstants.BVAnswers.Keys.campaignId
    case .categoryAncestorId:
      return BVConversationsConstants.BVAnswers.Keys.categoryAncestorId
    case .contentLocale:
      return BVConversationsConstants.BVAnswers.Keys.contentLocale
    case .hasPhotos:
      return BVConversationsConstants.BVAnswers.Keys.hasPhotos
    case .isBestAnswer:
      return BVConversationsConstants.BVAnswers.Keys.isBestAnswer
    case .isBrandAnswer:
      return BVConversationsConstants.BVAnswers.Keys.isBrandAnswer
    case .isFeatured:
      return BVConversationsConstants.BVAnswers.Keys.isFeatured
    case .lastModeratedTime:
      return BVConversationsConstants.BVAnswers.Keys.lastModeratedTime
    case .lastModificationTime:
      return BVConversationsConstants
        .BVAnswers.Keys.lastModificationTime
    case .moderatorCode:
      return BVConversationsConstants.BVAnswers.Keys.moderatorCode
    case .productId:
      return BVConversationsConstants.BVAnswers.Keys.productId
    case .reviewId:
      return BVConversationsConstants.BVComments.Keys.reviewId
    case .submissionId:
      return BVConversationsConstants.BVAnswers.Keys.submissionId
    case .submissionTime:
      return BVConversationsConstants.BVAnswers.Keys.submissionTime
    case .totalInappropriateFeedbackCount:
      return BVConversationsConstants
        .BVAnswers.Keys.totalInappropriateFeedbackCount
    case .totalFeedbackCount:
      return BVConversationsConstants
        .BVAnswers.Keys.totalFeedbackCount
    case .totalNegativeFeedbackCount:
      return
        BVConversationsConstants
          .BVAnswers.Keys.totalNegativeFeedbackCount
    case .totalPositiveFeedbackCount:
      return
        BVConversationsConstants
          .BVAnswers.Keys.totalPositiveFeedbackCount
    case .userLocation:
      return BVConversationsConstants.BVAnswers.Keys.userLocation
    }
  }
}
