//
//
//  BVInternalSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

typealias EncodingClosure = (Encodable?) -> Data?

internal protocol BVInternalSubmissionDelegate: class,
BVURLRequestBodyable, BVURLQueryItemable { }

internal class BVInternalSubmission {  
  
  /// Private
  final private var rawConfig: BVRawConfiguration?
  final private var configuration: BVConfiguration?
  final private var cacheable: Bool = false
  private var preflightClosure: BVURLRequestablePreflightHandler?
  private var baseResponseCompletion: BVURLRequestableHandler?
  private let postResource: String
  
  /// Internal
  final internal let submissionableType: BVSubmissionableInternal?
  internal weak var submissionBodyable: BVInternalSubmissionDelegate?
  
  internal init(_ internalType: BVSubmissionableInternal) {
    postResource =
      type(of: internalType).postResource ?? String.empty
    submissionableType = internalType
  }
}

// MARK: - BVInternalSubmission: BVConfigureExistentially
extension BVInternalSubmission: BVConfigureExistentially {
  @discardableResult
  final func configureExistentially(_ config: BVConfiguration) -> Self {
    configuration = config
    return self
  }
}

// MARK: - BVInternalSubmission: BVConfigureRaw
extension BVInternalSubmission: BVConfigureRaw {
  var rawConfiguration: BVRawConfiguration? {
    return rawConfig
  }
  
  @discardableResult
  final func configureRaw(_ config: BVRawConfiguration) -> Self {
    rawConfig = config
    return self
  }
}

// MARK: - BVSubmissionableConsumable: BVSubmissionableConsumable
extension BVInternalSubmission: BVSubmissionableConsumable {
  var submissionableInternal: BVSubmissionableInternal? {
    return submissionableType
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

// MARK: - BVInternalSubmission: BVURLRequestableCacheable
extension BVInternalSubmission: BVURLRequestableCacheable {
  var usesURLCache: Bool {
    get {
      return cacheable
    }
    set(newValue) {
      cacheable = newValue
    }
  }
}

// MARK: - BVInternalSubmission: BVURLRequestableInternal
extension BVInternalSubmission: BVURLRequestableInternal {
  final internal var bvPath: String {
    return postResource
  }
  
  final internal var commonEndpoint: String {
    if let raw = rawConfiguration {
      return raw.endpoint
    }
    return configuration?.endpoint ?? String.empty
  }
}

// MARK: - BVInternalSubmission: BVURLQueryItemable
extension BVInternalSubmission: BVURLQueryItemable {
  var urlQueryItems: [URLQueryItem]? {
    return submissionBodyable?.urlQueryItems
  }
}
