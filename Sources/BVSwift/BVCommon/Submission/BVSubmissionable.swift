//
//
//  BVSubmissionable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The main base protocol for BV Types used for Submission Requests
public protocol BVSubmissionable: BVResourceable { }

/// The main base protocol for BV Types used for Submission Requests that have
/// actionable callback handlers associated with them
public protocol BVSubmissionActionable: BVURLRequestableWithHandler { }

// MARK: - BVSubmissionableConsumable
internal protocol BVSubmissionableConsumable: class {
  var submissionableInternal: BVSubmissionableInternal? { get }
}

// MARK: - BVSubmissionableInternal
internal protocol BVSubmissionableInternal: BVSubmissionable {
  static var postResource: String? { get }
  mutating func update(_ values: [String: Encodable]?)
}
