//
//  BVQueryable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

// MARK: - BVConversationsQueryField
internal protocol BVConversationsQueryField:
BVInternalCustomStringConvertible {
  static var prefix: String { get }
}

// MARK: - BVConversationsQueryValue
internal protocol BVConversationsQueryValue:
BVInternalCustomStringConvertible { }

// MARK: - BVConversationsQueryFilter
public protocol BVConversationsQueryFilter: CustomStringConvertible { }

internal extension BVConversationsQueryFilter {
  static var filterPrefix: String {
    get {
      return BVConversationsConstants.BVConversationsQueryFilter.defaultField
    }
  }
}

// MARK: - BVConversationsQueryFilterOperator
public protocol BVConversationsQueryFilterOperator: CustomStringConvertible { }

// MARK: - BVConversationsQueryInclude
public protocol BVConversationsQueryInclude: CustomStringConvertible { }

internal extension BVConversationsQueryInclude {
  static var includePrefix: String {
    get {
      return BVConversationsConstants.BVConversationsQueryInclude.defaultField
    }
  }
}

// MARK: - BVConversationsQuerySort
public protocol BVConversationsQuerySort: CustomStringConvertible { }

internal extension BVConversationsQuerySort {
  static var sortPrefix: String {
    get {
      return BVConversationsConstants.BVConversationsQuerySort.defaultField
    }
  }
}

// MARK: - BVConversationsQuerySortOrder
public protocol BVConversationsQuerySortOrder: CustomStringConvertible { }

// MARK: - BVConversationsQueryStat
public protocol BVConversationsQueryStat: CustomStringConvertible { }

internal extension BVConversationsQueryStat {
  static var statPrefix: String {
    get {
      return BVConversationsConstants.BVConversationsQueryStat.defaultField
    }
  }
}

// MARK: - BVConversationsQueryCustomizable
public protocol BVConversationsQueryCustomizable {
  func custom(_ field: CustomStringConvertible,
              value: CustomStringConvertible) -> Self
}

// MARK: - BVConversationsQueryFilterable
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

// MARK: - BVConversationsQueryIncludeable
public protocol BVConversationsQueryIncludeable {
  associatedtype Include: BVConversationsQueryInclude
  func include(_ include: Include, limit: UInt16) -> Self
}

// MARK: - BVConversationsQuerySortable
public protocol BVConversationsQuerySortable {
  associatedtype Sort: BVConversationsQuerySort
  associatedtype Order: BVConversationsQuerySortOrder
  func sort(_ sort: Sort, order: Order) -> Self
}

// MARK: - BVConversationsQueryStatable
public protocol BVConversationsQueryStatable {
  associatedtype Stat: BVConversationsQueryStat
  func stats(_ for: Stat) -> Self
}

// MARK: - BVQueryable Types
public protocol BVAnswerIncludable: BVQueryable {
  var answers: [BVAnswer]? { get }
}

public protocol BVAuthorIncludable: BVQueryable {
  var authors: [BVAuthor]? { get }
}

public protocol BVCommentIncludable: BVQueryable {
  var comments: [BVComment]? { get }
}

public protocol BVProductIncludable: BVQueryable {
  var products: [BVProduct]? { get }
}

public protocol BVQuestionIncludable: BVQueryable {
  var questions: [BVQuestion]? { get }
}

public protocol BVReviewIncludable: BVQueryable {
  var reviews: [BVReview]? { get }
}

internal protocol BVConversationsUpdateable: BVQueryable {
  mutating func update(_ any: Any?)
}

internal protocol BVConversationsUpdateIncludable: BVConversationsUpdateable {
  mutating func updateIncludable(_ includable: BVConversationsIncludable)
}

extension BVConversationsUpdateIncludable {
  mutating func update(_ any: Any?) {
    if let includable: BVConversationsIncludable =
      any as? BVConversationsIncludable {
      updateIncludable(includable)
    }
  }
}

// MARK: - BVConversationsQueryPostflightable
internal protocol BVConversationsQueryPostflightable: BVQueryActionable {
  associatedtype ConversationsPostflightResult: BVQueryable
  func conversationsPostflight(_ results: [ConversationsPostflightResult]?)
}
