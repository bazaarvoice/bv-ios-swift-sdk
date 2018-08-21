//
//  BVCommentFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVComment[s]Query.
/// - Note:
/// \
/// Used for conformance with the BVQueryFilterable protocol.
public enum BVCommentFilter: BVQueryFilter {
  
  case authorId(String)
  case campaignId(String)
  case categoryAncestorId(String)
  case commentId(String)
  case contentLocale(Locale)
  case isFeatured(Bool)
  case lastModeratedTime(Date)
  case lastModificationTime(Date)
  case moderatorCode(String)
  case productId(String)
  case reviewId(String)
  case submissionId(String)
  case submissionTime(Date)
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
    case let .commentId(filter):
      return filter
    case let .contentLocale(filter):
      return filter.identifier
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

extension BVCommentFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .authorId:
      return BVConversationsConstants.BVComments.Keys.authorId
    case .campaignId:
      return BVConversationsConstants.BVComments.Keys.campaignId
    case .categoryAncestorId:
      return BVConversationsConstants.BVComments.Keys.categoryAncestorId
    case .commentId:
      return BVConversationsConstants.BVComments.Keys.commentId
    case .contentLocale:
      return BVConversationsConstants.BVComments.Keys.contentLocale
    case .isFeatured:
      return BVConversationsConstants.BVComments.Keys.isFeatured
    case .lastModeratedTime:
      return BVConversationsConstants.BVComments.Keys.lastModeratedTime
    case .lastModificationTime:
      return BVConversationsConstants
        .BVComments.Keys.lastModificationTime
    case .moderatorCode:
      return BVConversationsConstants.BVComments.Keys.moderatorCode
    case .productId:
      return BVConversationsConstants.BVComments.Keys.productId
    case .reviewId:
      return BVConversationsConstants.BVComments.Keys.reviewId
    case .submissionId:
      return BVConversationsConstants.BVComments.Keys.submissionId
    case .submissionTime:
      return BVConversationsConstants.BVComments.Keys.submissionTime
    case .totalFeedbackCount:
      return BVConversationsConstants
        .BVComments.Keys.totalFeedbackCount
    case .totalNegativeFeedbackCount:
      return
        BVConversationsConstants
          .BVComments.Keys.totalNegativeFeedbackCount
    case .totalPositiveFeedbackCount:
      return
        BVConversationsConstants
          .BVComments.Keys.totalPositiveFeedbackCount
    case .userLocation:
      return BVConversationsConstants.BVComments.Keys.userLocation
    }
  }
}
