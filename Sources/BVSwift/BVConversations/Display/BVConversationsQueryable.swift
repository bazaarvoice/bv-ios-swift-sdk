//
//  BVQueryable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Protocol defining the primitive query filter types
public protocol BVConversationsQueryFilter: CustomStringConvertible { }

/// Protocol defining the primitive query filter operator types
public protocol BVConversationsQueryFilterOperator: CustomStringConvertible { }

/// Protocol defining the primitive query include types
public protocol BVConversationsQueryInclude: CustomStringConvertible { }

/// Protocol defining the primitive query sort types
public protocol BVConversationsQuerySort: CustomStringConvertible { }

/// Protocol defining the primitive query sort order types
public protocol BVConversationsQuerySortOrder: CustomStringConvertible { }

/// Protocol defining the primitive query stat types
public protocol BVConversationsQueryStat: CustomStringConvertible { }

/// Protocol definition for the behavior of adding custom query fields
public protocol BVConversationsQueryCustomizable {
  func custom(_ field: CustomStringConvertible,
              value: CustomStringConvertible) -> Self
}

/// Protocol definition for the behavior of adding filters
public protocol BVConversationsQueryFilterable {
  associatedtype Filter: BVConversationsQueryFilter
  associatedtype Operator: BVConversationsQueryFilterOperator
  func filter(
    _ filter: Filter,
    op: Operator,
    values: [CustomStringConvertible]) -> Self
  func filter(
    _ filter: Filter,
    op: Operator,
    value: CustomStringConvertible) -> Self
}

/// Protocol definition for the behavior of adding included filters
public protocol BVConversationsQueryIncludeable {
  associatedtype Include: BVConversationsQueryInclude
  func include(_ include: Include, limit: UInt16) -> Self
}

/// Protocol definition for the behavior of adding sort filters
public protocol BVConversationsQuerySortable {
  associatedtype Sort: BVConversationsQuerySort
  associatedtype Order: BVConversationsQuerySortOrder
  func sort(_ sort: Sort, order: Order) -> Self
}

/// Protocol definition for the behavior of adding stat filters
public protocol BVConversationsQueryStatable {
  associatedtype Stat: BVConversationsQueryStat
  func stats(_ for: Stat) -> Self
}

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

extension BVConversationsUpdateIncludable {
  internal mutating func update(_ any: Any?) {
    if let includable: BVConversationsIncludable =
      any as? BVConversationsIncludable {
      updateIncludable(includable)
    }
  }
}

// MARK: - BVConversationsQueryField
internal protocol BVConversationsQueryField:
BVInternalCustomStringConvertible {
  static var fieldPrefix: String { get }
}

// MARK: - BVConversationsQueryValue
internal protocol BVConversationsQueryValue:
BVInternalCustomStringConvertible { }

internal protocol BVConversationsUpdateable: BVQueryable {
  mutating func update(_ any: Any?)
}

internal protocol BVConversationsUpdateIncludable: BVConversationsUpdateable {
  mutating func updateIncludable(_ includable: BVConversationsIncludable)
}

// MARK: - BVConversationsQueryPostflightable
internal protocol BVConversationsQueryPostflightable: BVQueryActionable {
  associatedtype ConversationsPostflightResult: BVQueryable
  func conversationsPostflight(_ results: [ConversationsPostflightResult]?)
}

internal extension BVConversationsQueryFilter {
  static var filterPrefix: String {
    get {
      return BVConversationsConstants.BVConversationsQueryFilter.defaultField
    }
  }
}

internal extension BVConversationsQueryInclude {
  static var includePrefix: String {
    get {
      return BVConversationsConstants.BVConversationsQueryInclude.defaultField
    }
  }
}

internal extension BVConversationsQuerySort {
  static var sortPrefix: String {
    get {
      return BVConversationsConstants.BVConversationsQuerySort.defaultField
    }
  }
}

internal extension BVConversationsQueryStat {
  static var statPrefix: String {
    get {
      return BVConversationsConstants.BVConversationsQueryStat.defaultField
    }
  }
}
