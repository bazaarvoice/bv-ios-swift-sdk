//
//  BVQuestionFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVQuestion[s|Search]Query
/// - Note:
/// \
/// Used for conformance with the BVQueryFilterable protocol.
public enum BVQuestionFilter: BVQueryFilter {
  
  case authorId(String)
  case campaignId(String)
  case categoryAncestorId(String)
  case categoryId(String)
  case contentLocale(Locale)
  case hasAnswers(Bool)
  case hasBestAnswer(Bool)
  case hasBrandAnswers(Bool)
  case hasPhotos(Bool)
  case hasStaffAnswers(Bool)
  case hasTags(Bool)
  case hasVideos(Bool)
  case isFeatured(Bool)
  case isSubjectActive(Bool)
  case lastApprovedAnswerSubmissionTime(Date)
  case lastModeratedTime(Date)
  case lastModificationTime(Date)
  case moderatorCode(String)
  case productId(String)
  case questionId(String)
  case submissionId(String)
  case submissionTime(Date)
  case summary(String)
  case totalAnswerCount(Int)
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
    case let .authorId(filter):
      return filter
    case let .campaignId(filter):
      return filter
    case let .categoryAncestorId(filter):
      return filter
    case let .categoryId(filter):
      return filter
    case let .contentLocale(filter):
      return filter.identifier
    case let .hasAnswers(filter):
      return filter
    case let .hasBestAnswer(filter):
      return filter
    case let .hasBrandAnswers(filter):
      return filter
    case let .hasPhotos(filter):
      return filter
    case let .hasStaffAnswers(filter):
      return filter
    case let .hasTags(filter):
      return filter
    case let .hasVideos(filter):
      return filter
    case let .isFeatured(filter):
      return filter
    case let .isSubjectActive(filter):
      return filter
    case let .lastApprovedAnswerSubmissionTime(filter):
      return filter.toBVFormat
    case let .lastModeratedTime(filter):
      return filter.toBVFormat
    case let .lastModificationTime(filter):
      return filter.toBVFormat
    case let .moderatorCode(filter):
      return filter
    case let .productId(filter):
      return filter
    case let .questionId(filter):
      return filter
    case let .submissionId(filter):
      return filter
    case let .submissionTime(filter):
      return filter.toBVFormat
    case let .summary(filter):
      return filter
    case let .totalAnswerCount(filter):
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

extension BVQuestionFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .authorId:
      return BVConversationsConstants.BVQuestions.Keys.authorId
    case .campaignId:
      return BVConversationsConstants.BVQuestions.Keys.campaignId
    case .categoryAncestorId:
      return BVConversationsConstants.BVQuestions.Keys.categoryAncestorId
    case .categoryId:
      return BVConversationsConstants.BVQuestions.Keys.categoryId
    case .contentLocale:
      return BVConversationsConstants.BVQuestions.Keys.contentLocale
    case .hasAnswers:
      return BVConversationsConstants.BVQuestions.Keys.hasAnswers
    case .hasBestAnswer:
      return BVConversationsConstants.BVQuestions.Keys.hasBestAnswer
    case .hasBrandAnswers:
      return BVConversationsConstants.BVQuestions.Keys.hasBrandAnswers
    case .hasPhotos:
      return BVConversationsConstants.BVQuestions.Keys.hasPhotos
    case .hasStaffAnswers:
      return BVConversationsConstants.BVQuestions.Keys.hasStaffAnswers
    case .hasTags:
      return BVConversationsConstants.BVQuestions.Keys.hasTags
    case .hasVideos:
      return BVConversationsConstants.BVQuestions.Keys.hasVideos
    case .isFeatured:
      return BVConversationsConstants.BVQuestions.Keys.isFeatured
    case .isSubjectActive:
      return BVConversationsConstants.BVQuestions.Keys.isSubjectActive
    case .lastApprovedAnswerSubmissionTime:
      return BVConversationsConstants.BVQuestions.Keys
        .lastApprovedAnswerSubmissionTime
    case .lastModeratedTime:
      return BVConversationsConstants.BVQuestions.Keys.lastModeratedTime
    case .lastModificationTime:
      return BVConversationsConstants.BVQuestions.Keys.lastModificationTime
    case .moderatorCode:
      return BVConversationsConstants.BVQuestions.Keys.moderatorCode
    case .productId:
      return BVConversationsConstants.BVQuestions.Keys.productId
    case .questionId:
      return BVConversationsConstants.BVQuestions.Keys.questionId
    case .submissionId:
      return BVConversationsConstants.BVQuestions.Keys.submissionId
    case .submissionTime:
      return BVConversationsConstants.BVQuestions.Keys.submissionTime
    case .summary:
      return BVConversationsConstants.BVQuestions.Keys.summary
    case .totalAnswerCount:
      return BVConversationsConstants.BVQuestions.Keys.totalAnswerCount
    case .totalFeedbackCount:
      return BVConversationsConstants.BVQuestions.Keys.totalFeedbackCount
    case .totalNegativeFeedbackCount:
      return BVConversationsConstants.BVQuestions.Keys
        .totalNegativeFeedbackCount
    case .totalPositiveFeedbackCount:
      return BVConversationsConstants.BVQuestions.Keys
        .totalPositiveFeedbackCount
    case .userLocation:
      return BVConversationsConstants.BVQuestions.Keys.userLocation
    }
  }
}
