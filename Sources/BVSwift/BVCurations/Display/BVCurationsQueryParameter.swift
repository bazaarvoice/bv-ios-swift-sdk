//
//
//  BVCurationsQueryParameter.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVCurationsQueryParameter
internal enum BVCurationsQueryParameter: BVParameter {
  
  case custom(
    CustomStringConvertible,
    CustomStringConvertible)
  case filter(BVCurationsQueryFilter)
  
  var name: String {
    get {
      switch self {
      case let .custom(filter, _):
        return "\(filter)"
      case let .filter(filter):
        return filter.description
      }
    }
  }
  
  var value: String {
    get {
      switch self {
      case let .custom(_, value):
        return "\(value)"
      case let .filter(filter):
        return "\(filter.representedValue)"
      }
    }
  }
}

extension BVCurationsQueryParameter: Equatable {
  static func ==(lhs: BVCurationsQueryParameter, rhs: BVCurationsQueryParameter) -> Bool {
    return lhs.name == rhs.name && lhs.value == rhs.value
  }
}

extension BVCurationsQueryParameter: Hashable {
  var hashValue: Int {
    return name.djb2hash ^ value.hashValue
  }
}
