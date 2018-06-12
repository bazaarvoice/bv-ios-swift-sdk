//
//
//  BVCurationsQueryable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation
import CoreLocation

/// Protocol defining the primitive query filter types
public protocol BVCurationsQueryFilter: CustomStringConvertible {
  var representedValue: CustomStringConvertible { get }
}

/// Protocol definition for the behavior of adding filters
public protocol BVCurationsQueryFilterable {
  associatedtype Filter: BVCurationsQueryFilter
  func filter(_ filter: Filter) -> Self
}

/// Protocol definition for the behavior of formatting media
internal protocol BVCurationsQueryMediaOverridable {
  func override(_ media: BVCurationsMedia) -> Self
}

// MARK: - BVCurationsQueryValue
internal protocol BVCurationsQueryValue: BVInternalCustomStringConvertible { }

// MARK: - BVCurationsQueryPostflightable
internal protocol BVCurationsQueryPostflightable: BVQueryActionable {
  associatedtype CurationsPostflightResult: BVQueryable
  func curationsPostflight(_ results: [CurationsPostflightResult]?)
}

// MARK: - BVCurationsUpdateable
internal protocol BVCurationsUpdateable: BVQueryable {
  mutating func update(_ any: Any?)
}

// MARK: - BVCurationsProductUpdatable
internal protocol BVCurationsProductUpdatable: BVCurationsUpdateable {
  mutating func update(_ product: [BVCurationsProduct])
}

extension BVCurationsProductUpdatable {
  internal mutating func update(_ any: Any?) {
    if let product: [BVCurationsProduct] =
      any as? [BVCurationsProduct] {
      update(product)
    }
  }
}
