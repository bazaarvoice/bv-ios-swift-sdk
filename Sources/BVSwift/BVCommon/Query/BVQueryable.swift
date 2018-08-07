//
//
//  BVQueryable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The main base protocol for BV Types used for Query Requests
public protocol BVQueryable: BVResourceable { }

public protocol BVQueryRepresentable: CustomStringConvertible {
  var representedValue: CustomStringConvertible { get }
}

/// The main base protocol for BV Types used for Query Requests that have
/// actionable callback handlers associated with them
public protocol BVQueryActionable: BVURLRequestableWithHandler {
  associatedtype Kind: BVQueryable
}

/// Protocol defining the primitive query field types
public protocol BVQueryField: BVQueryRepresentable { }

/// Protocol defining the primitive query filter types
public protocol BVQueryFilter: BVQueryRepresentable {
  static var filterPrefix: String { get }
  static var filterTypeSeparator: String { get }
  static var filterValueSeparator: String { get }
}

/// Protocol defining the primitive query filter operator types
public protocol BVQueryFilterOperator: CustomStringConvertible { }

/// Protocol defining the primitive query filtered stat types
public protocol BVQueryFilteredStat: BVQueryStat {
}

/// Protocol defining the primitive query include types
public protocol BVQueryInclude: CustomStringConvertible {
  static var includePrefix: String { get }
  static var includeLimitKey: String { get }
  static var includeLimitSeparator: String { get }
}

/// Protocol defining the primitive query sort types
public protocol BVQuerySort: CustomStringConvertible {
  static var sortPrefix: String { get }
  static var sortTypeSeparator: String { get }
  static var sortValueSeparator: String { get }
}

/// Protocol defining the primitive query sort order types
public protocol BVQuerySortOrder: CustomStringConvertible { }

/// Protocol defining the primitive query stat types
public protocol BVQueryStat: CustomStringConvertible {
  static var statPrefix: String { get }
}

/// Protocol definition for the behavior of adding filters
public protocol BVQueryFieldable {
  associatedtype Field: BVQueryField
  func field(_ to: Field) -> Self
}

/// Protocol definition for the behavior of adding filters with operators
public protocol BVQueryFilterable {
  associatedtype Filter: BVQueryFilter
  associatedtype Operator: BVQueryFilterOperator
  func filter(_ by: Filter, op: Operator) -> Self
}

/// Protocol definition for the behavior of adding filtered stats
public protocol BVQueryFilteredStatable {
  associatedtype FilteredStat: BVQueryFilteredStat
  func filter(_ by: FilteredStat) -> Self
}

/// Protocol definition for the behavior of adding included filters
public protocol BVQueryIncludeable {
  associatedtype Include: BVQueryInclude
  func include(_ kind: Include, limit: UInt16) -> Self
}

/// Protocol definition for the behavior of adding sort filters
public protocol BVQuerySortable {
  associatedtype Sort: BVQuerySort
  associatedtype Order: BVQuerySortOrder
  func sort(_ on: Sort, order: Order) -> Self
}

/// Protocol definition for the behavior of adding stat filters
public protocol BVQueryStatable {
  associatedtype Stat: BVQueryStat
  func stats(_ for: Stat) -> Self
}

/// Protocol definition for the behavior of adding custom query fields
/// - Note:
/// \
/// The reason this is marked as unsafe is because if the string convertables
/// contain any ["not nice"](https://tools.ietf.org/html/rfc3986#section-2)
/// characters for a URL
public protocol BVQueryUnsafeField {
  func unsafe(_ field: CustomStringConvertible,
              value: CustomStringConvertible) -> Self
}

// MARK: - BVQueryableInternal
internal protocol BVQueryableInternal: BVQueryable {
  static var getResource: String? { get }
}

// MARK: - BVQueryActionableInternal
internal protocol BVQueryActionableInternal:
BVURLRequestableWithHandlerInternal { }
