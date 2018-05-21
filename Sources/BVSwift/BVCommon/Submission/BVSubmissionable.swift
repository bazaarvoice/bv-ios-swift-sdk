//
//
//  BVSubmissionable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVSubmissionable
public protocol BVSubmissionable: BVResourceable { }

// MARK: - BVSubmissionActionable
public protocol BVSubmissionActionable: BVURLRequestableWithHandler { }

// MARK: - BVSubmissionableInternal
internal protocol BVSubmissionableInternal: BVSubmissionable {
  static var postResource: String? { get }
}

// MARK: - BVSubmissionActionableInternal
internal protocol BVSubmissionActionableInternal:
BVURLRequestableWithHandlerInternal { }

// MARK: - BVSubmissionPreflightable
internal protocol BVSubmissionPreflightable: BVSubmissionActionableInternal {
  func preflightWithInternalResponse(_ continue: (() -> Swift.Void))
}

// MARK: - BVSubmissionPostflightable
internal protocol BVSubmissionPostflightable: BVSubmissionActionableInternal {
  func postflight(_ response: BVURLRequestableResponseInternal)
}
