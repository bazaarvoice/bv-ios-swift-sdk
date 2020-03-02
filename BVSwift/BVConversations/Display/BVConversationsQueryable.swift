//
//  BVConversationsQueryable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Protocol definition for the answer includable instances
public protocol BVAnswerIncludable: BVQueryable {
  var answers: [BVAnswer]? { get }
}

/// Protocol definition for the author includable instances
public protocol BVAuthorIncludable: BVQueryable {
  var authors: [BVAuthor]? { get }
}

/// Protocol definition for the comment includable instances
public protocol BVCommentIncludable: BVQueryable {
  var comments: [BVComment]? { get }
}

/// Protocol definition for the product includable instances
public protocol BVProductIncludable: BVQueryable {
  var products: [BVProduct]? { get }
}

/// Protocol definition for the question includable instances
public protocol BVQuestionIncludable: BVQueryable {
  var questions: [BVQuestion]? { get }
}

/// Protocol definition for the review includable instances
public protocol BVReviewIncludable: BVQueryable {
  var reviews: [BVReview]? { get }
}

/// Internal

internal protocol BVConversationsQueryIncludable {
  var answers: [BVAnswer]? { get }
  var authors: [BVAuthor]? { get }
  var comments: [BVComment]? { get }
  var products: [BVProduct]? { get }
  var questions: [BVQuestion]? { get }
  var reviews: [BVReview]? { get }
}

extension BVConversationsQueryUpdateIncludable {
  internal mutating func update(_ any: Any?) {
    if let includable: BVConversationsQueryIncludable =
      any as? BVConversationsQueryIncludable {
      update(includable)
    }
  }
}

// MARK: - BVConversationsQueryValue
internal protocol BVConversationsQueryValue: BVCustomStringConvertible { }

// MARK: - BVConversationsQueryUpdateable
internal protocol BVConversationsQueryUpdateable: BVQueryable {
  mutating func update(_ any: Any?)
}

// MARK: - BVConversationsQueryUpdateIncludable
internal protocol BVConversationsQueryUpdateIncludable:
BVConversationsQueryUpdateable {
  mutating func update(_ includable: BVConversationsQueryIncludable)
}

// MARK: - BVConversationsQueryPreflightable
internal protocol BVConversationsQueryPreflightable: BVQueryActionable {
  func conversationsQueryPreflight(
    _ preflight: BVCompletionWithErrorsHandler?)
}

// MARK: - BVConversationsQueryPostflightable
internal protocol BVConversationsQueryPostflightable: BVQueryActionable {
  associatedtype ConversationsQueryPostflightResult: BVQueryable
  func conversationsQueryPostflight(
    _ results: [ConversationsQueryPostflightResult]?)
}

// MARK: - BVConversationsQuerySearchField
internal struct BVConversationsQuerySearchField: BVQueryField {
  private let value: CustomStringConvertible
  
  var internalDescription: String {
    return BVConversationsConstants.BVQueryType.Keys.search
  }
  
  var representedValue: CustomStringConvertible {
    return value
  }
  
  var description: String {
    return internalDescription
  }
  
  init(_ searchQuery: String) {
    value = searchQuery
  }
}

// MARK: - BVConversationsQueryLimitField
internal struct BVConversationsQueryLimitField: BVQueryField {
  private let value: CustomStringConvertible
  
  var internalDescription: String {
    return BVConversationsConstants.BVQueryType.Keys.limit
  }
  
  var representedValue: CustomStringConvertible {
    return value
  }
  
  var description: String {
    return internalDescription
  }
  
  init(_ limit: UInt16) {
    value = "\(limit)"
  }
}

// MARK: - BVConversationsQueryOffsetField
internal struct BVConversationsQueryOffsetField: BVQueryField {
  private let value: CustomStringConvertible
  
  var internalDescription: String {
    return BVConversationsConstants.BVQueryType.Keys.offset
  }
  
  var representedValue: CustomStringConvertible {
    return value
  }
  
  var description: String {
    return internalDescription
  }
  
  init(_ offset: UInt16) {
    value = "\(offset)"
  }
}

// MARK: - BVConversationsQueryFilter
internal enum BVConversationsQueryFilter: BVQueryFilter {
  case id(String)
  case productId(String)
  
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
    case let .id(filter):
      return filter
    case let .productId(filter):
      return filter
    }
  }
  
  internal var internalDescription: String {
    switch self {
    case .id:
      return BVConversationsConstants.BVConversationsQueryFilter.Keys.id
    case .productId:
      return BVConversationsConstants.BVConversationsQueryFilter.Keys.productId
    }
  }
}
