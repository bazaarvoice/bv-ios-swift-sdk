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

/// The main base protocol for BV Types used for Query Requests that have
/// actionable callback handlers associated with them
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
