//
//
//  BVInternalSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

typealias EncodingClosure = (Encodable?) -> Data?

internal protocol BVInternalSubmissionDelegate: class, BVURLRequestBodyable { }

internal class BVInternalSubmission {  
  
  /// Private
  private var preflightClosure: BVURLRequestablePreflightHandler?
  private var baseResponseCompletion: BVURLRequestableHandler?
  private let postResource: String
  
  /// Internal
  final internal let encodableType: BVSubmissionableInternal?
  final internal var configurationType: BVConfiguration?
  internal weak var submissionBodyable: BVInternalSubmissionDelegate?
  
  internal init(_ internalType: BVSubmissionableInternal) {
    postResource =
      type(of: internalType).postResource ?? String.empty
    encodableType = internalType
  }
}

// MARK: - BVInternalSubmission: BVSubmissionActionableInternal
extension BVInternalSubmission: BVSubmissionActionableInternal {
  
  var preflightHandler: BVURLRequestablePreflightHandler? {
    get {
      return preflightClosure
    }
    set(newValue) {
      preflightClosure = newValue
    }
  }
  
  internal var responseHandler: BVURLRequestableHandler? {
    get {
      return baseResponseCompletion
    }
    set(newValue) {
      baseResponseCompletion = newValue
    }
  }
}

// MARK: - BVInternalSubmission: BVURLRequestableInternal
extension BVInternalSubmission: BVURLRequestableInternal {
  final internal var bvPath: String {
    get {
      return postResource
    }
  }
  
  final internal var commonEndpoint: String {
    get {
      return configurationType?.endpoint ?? String.empty
    }
  }
}
