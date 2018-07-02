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

internal protocol BVConversationsIncludable {
  var answers: [BVAnswer]? { get }
  var authors: [BVAuthor]? { get }
  var comments: [BVComment]? { get }
  var products: [BVProduct]? { get }
  var questions: [BVQuestion]? { get }
  var reviews: [BVReview]? { get }
}

extension BVConversationsUpdateIncludable {
  internal mutating func update(_ any: Any?) {
    if let includable: BVConversationsIncludable =
      any as? BVConversationsIncludable {
      update(includable)
    }
  }
}

// MARK: - BVConversationsQueryValue
internal protocol BVConversationsQueryValue:
BVInternalCustomStringConvertible { }

// MARK: - BVConversationsUpdateable
internal protocol BVConversationsUpdateable: BVQueryable {
  mutating func update(_ any: Any?)
}

// MARK: - BVConversationsUpdateIncludable
internal protocol BVConversationsUpdateIncludable: BVConversationsUpdateable {
  mutating func update(_ includable: BVConversationsIncludable)
}

// MARK: - BVConversationsQueryPostflightable
internal protocol BVConversationsQueryPostflightable: BVQueryActionable {
  associatedtype ConversationsPostflightResult: BVQueryable
  func conversationsPostflight(_ results: [ConversationsPostflightResult]?)
}

// MARK: - BVConversationsSearchQueryField
internal struct BVConversationsSearchQueryField: BVQueryField {
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

// MARK: - BVConversationsLimitQueryField
internal struct BVConversationsLimitQueryField: BVQueryField {
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

// MARK: - BVConversationsOffsetQueryField
internal struct BVConversationsOffsetQueryField: BVQueryField {
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
