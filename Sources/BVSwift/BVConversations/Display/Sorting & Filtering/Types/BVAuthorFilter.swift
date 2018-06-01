//
//
//  BVAuthorFilter.swift
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVAuthorQuery
/// - Note:
/// \
/// Used for conformance with the BVConversationsQueryFilterable protocol.
public enum BVAuthorFilter: BVConversationsQueryFilter {
  
  case additionalField(String)
  case authorId
  case contentLocale
  case contextDataValue(String)
  case hasPhotos
  case hasVideos
  case lastModeratedTime
  case moderatorCode
  case submissionTime
  case totalAnswerCount
  case totalQuestionCount
  case totalReviewCount
  case userLocation
  
  public var description: String {
    return internalDescription
  }
}

extension BVAuthorFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    get {
      switch self {
      case let .additionalField(field):
        return BVConversationsConstants
          .BVAuthors.Keys.additionalField + "_" + field
      case .authorId:
        return BVConversationsConstants.BVAuthors.Keys.authorId
      case .contentLocale:
        return BVConversationsConstants.BVAuthors.Keys.contentLocale
      case let .contextDataValue(value):
        return BVConversationsConstants
          .BVAuthors.Keys.contextDataValue + "_" + value
      case .hasPhotos:
        return BVConversationsConstants.BVAuthors.Keys.hasPhotos
      case .hasVideos:
        return BVConversationsConstants.BVAuthors.Keys.hasVideos
      case .lastModeratedTime:
        return BVConversationsConstants
          .BVAuthors.Keys.lastModeratedTime
      case .moderatorCode:
        return BVConversationsConstants.BVAuthors.Keys.moderatorCode
      case .submissionTime:
        return BVConversationsConstants.BVAuthors.Keys.submissionTime
      case .totalAnswerCount:
        return BVConversationsConstants
          .BVAuthors.Keys.totalAnswerCount
      case .totalQuestionCount:
        return BVConversationsConstants
          .BVAuthors.Keys.totalQuestionCount
      case .totalReviewCount:
        return BVConversationsConstants
          .BVAuthors.Keys.totalReviewCount
      case .userLocation:
        return BVConversationsConstants.BVAuthors.Keys.userLocation
      }
    }
  }
}
