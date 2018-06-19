//
//
//  BVCurationsQueryable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation
import CoreLocation

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

// MARK: - BVCurationsQueryUpdateable
internal protocol BVCurationsQueryUpdateable: BVQueryable {
  mutating func update(_ any: Any?)
}

// MARK: - BVCurationsQueryProductUpdatable
internal protocol BVCurationsQueryProductUpdatable: BVCurationsQueryUpdateable {
  mutating func update(_ product: [BVCurationsProduct])
}

extension BVCurationsQueryProductUpdatable {
  internal mutating func update(_ any: Any?) {
    if let product: [BVCurationsProduct] =
      any as? [BVCurationsProduct] {
      update(product)
    }
  }
}
