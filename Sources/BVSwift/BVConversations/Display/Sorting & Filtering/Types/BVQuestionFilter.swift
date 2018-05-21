//
//  BVQuestionFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public enum BVQuestionFilter: BVConversationsQueryFilter {
  
  case authorId
  case campaignId
  case categoryAncestorId
  case categoryId
  case contentLocale
  case hasAnswers
  case hasBestAnswer
  case hasBrandAnswers
  case hasPhotos
  case hasStaffAnswers
  case hasTags
  case hasVideos
  case isFeatured
  case isSubjectActive
  case lastApprovedAnswerSubmissionTime
  case lastModeratedTime
  case lastModificationTime
  case moderatorCode
  case productId
  case questionId
  case submissionId
  case submissionTime
  case summary
  case totalAnswerCount
  case totalFeedbackCount
  case totalNegativeFeedbackCount
  case totalPositiveFeedbackCount
  case userLocation
  
  public var description: String {
    return internalDescription
  }
}

extension BVQuestionFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
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
}
