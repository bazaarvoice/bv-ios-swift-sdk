//
//
//  BVQueryable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVQueryable
public protocol BVQueryable: BVResourceable { }

// MARK: - BVQueryActionable
public protocol BVQueryActionable: BVURLRequestableWithHandler {
  associatedtype Kind: BVQueryable
}

// MARK: - BVQueryableInternal
internal protocol BVQueryableInternal: BVQueryable {
  static var getResource: String? { get }
}

// MARK: - BVQueryActionableInternal
internal protocol BVQueryActionableInternal:
BVURLRequestableWithHandlerInternal { }

// MARK: - BVQueryPostflightable
internal protocol BVQueryPostflightable: BVQueryActionableInternal {
  func postflight(_ response: BVURLRequestableResponseInternal)
}
