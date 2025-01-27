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
public protocol BVQueryFilteredStat: BVQueryStat { }

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
  func filter(_ apply: [(Filter, Operator)]) -> Self
  func filter(_ apply: (Filter, Operator)...) -> Self
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

/// Protocol definition for the behavior of adding sort filters
public protocol BVQueryCustomSortable {
  associatedtype Sort: BVQuerySort
 
  func coustomSort(_ on: Sort, contentLocales: [String]) -> Self
}


/// Protocol definition for the behavior of adding stat filters
public protocol BVQueryStatable {
  associatedtype Stat: BVQueryStat
  func stats(_ for: Stat) -> Self
}

/// Protocol definition for the behavior of adding  incentivizedStats
public protocol BVQueryIncentivizedStatable {
  func incentivizedStats(_ value: Bool) -> Self
}

/// Protocol definition for the behavior of adding  features
public protocol BVQueryFeatureStatable {
  func feature(_ value: String) -> Self
}

/// Protocol definition for the behavior of adding  tagstats
public protocol BVQueryTagStatStatable {
  func tagStats(_ value: Bool) -> Self
}

/// Protocol definition for the behavior of adding  tagstats
public protocol BVQuerySecondaryRatingstatable {
  func secondaryRatingstats(_ value: Bool) -> Self
}

/// Protocol definition for the behavior of adding  features
public protocol BVQueryLanguageStatable {
  func language(_ value: String) -> Self
}

/// Protocol definition for the behavior of adding embedded values
public protocol BVQueryEmbedStatable {
  func embed(_ value: String) -> Self
}

/// Protocol definition for the behavior of adding summary format values
public protocol BVQueryFormatStatable {
  func formatType(_ value: String) -> Self
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

/// Enum defining the supported logical operators of filter
internal enum BVQueryFilterExpression<T: BVQueryFilter, U: BVQueryFilterOperator> {
  case and([(T, U)])
  case not((T, U))
  case or([(T, U)])
  case xor([(T, U)])
}

// MARK: - BVQueryFilterable: Extension for supported expressions
extension BVQueryFilterable {
  internal func flatten<T: BVQueryFilter, U: BVQueryFilterOperator>(
    _ expr: BVQueryFilterExpression<T, U>,
    preflight: ((T, U) -> BVURLParameter?)? = nil) -> [BVURLParameter] {
    
    /// First we set a default apply closure to just return a filter parameter.
    let defaultPreflight: ((T, U) -> BVURLParameter) = {
      return BVURLParameter.filter($0, $1, nil)
    }
    
    /// AND is the easiest, we just linearly append the filters to the list.
    ///
    /// but...
    ///
    /// OR is more complicated because we have to not only have to construct
    /// the recursive composition but we also have to make sure to preflight
    /// the parameters into equivalent genus buckets, e.g., .filter() &
    /// .filterType(), otherwise we'll end up losing some filters.
    switch expr {
    case let .and(list):
      return list.map {
        return preflight?($0.0, $0.1) ?? defaultPreflight($0.0, $0.1)
      }
    case let .or(list):
      
      let urlParameters: [BVURLParameter] = list.map {
        return preflight?($0.0, $0.1) ?? defaultPreflight($0.0, $0.1)
      }
      
      /// We zip up the values into buckets based on the name of the parameter
      /// since (at least for now) it's unique. This way we end up with an
      /// array of BVURLParameter arrays all sorted by the name. This ensures
      /// that when we go to try and compose them it won't fail and drop a
      /// filter off the list.
      ///
      /// For more information, see the Dictionary(grouping:) call-site as it's
      /// the main workhorse for separation by genus equality.
      return
        Dictionary(grouping: urlParameters) { $0.name }
          .values
          .reduce(into: []) {
            let compose: BVURLParameter? = $1.reduce(nil) {
              guard let prev = $0 else {
                return $1
              }
              return prev + $1
            }
            
            guard let filter = compose else {
              return
            }
            
            $0 += [filter]
      }
    default:
      return []
    }
  }
}
