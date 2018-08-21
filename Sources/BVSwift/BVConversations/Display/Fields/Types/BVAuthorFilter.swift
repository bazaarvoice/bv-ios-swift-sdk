//
//
//  BVAuthorFilter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// An enum that represents the possible filtering comparators to filter on for
/// the BVAuthorQuery
/// - Note:
/// \
/// Used for conformance with the BVQueryFilterable protocol.
public enum BVAuthorFilter: BVQueryFilter {
  
  case additionalField(name: String, value: String)
  case authorId(String)
  case contentLocale(Locale)
  case contextDataValue(name: String, value: String)
  case hasPhotos(Bool)
  case hasVideos(Bool)
  case lastModeratedTime(Date)
  case moderatorCode(String)
  case submissionTime(Date)
  case totalAnswerCount(Int)
  case totalQuestionCount(Int)
  case totalReviewCount(Int)
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
    case let .additionalField(_, filter):
      return filter
    case let .authorId(filter):
      return filter
    case let .contentLocale(filter):
      return filter.identifier
    case let .contextDataValue(_, filter):
      return filter
    case let .hasPhotos(filter):
      return filter
    case let .hasVideos(filter):
      return filter
    case let .lastModeratedTime(filter):
      return filter.toBVFormat
    case let .moderatorCode(filter):
      return filter
    case let .submissionTime(filter):
      return filter.toBVFormat
    case let .totalAnswerCount(filter):
      return filter
    case let .totalQuestionCount(filter):
      return filter
    case let .totalReviewCount(filter):
      return filter
    case let .userLocation(filter):
      return filter
    }
  }
}

extension BVAuthorFilter: BVConversationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case let .additionalField(field, _):
      return BVConversationsConstants
        .BVAuthors.Keys.additionalField + "_" + field
    case .authorId:
      return BVConversationsConstants.BVAuthors.Keys.authorId
    case .contentLocale:
      return BVConversationsConstants.BVAuthors.Keys.contentLocale
    case let .contextDataValue(field, _):
      return BVConversationsConstants
        .BVAuthors.Keys.contextDataValue + "_" + field
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
