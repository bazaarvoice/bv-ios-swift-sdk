//
//  BVInternalQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal protocol BVInternalQueryDelegate: class, BVURLQueryItemable { }

// MARK: - BVInternalQuery
internal class BVInternalQuery<T: BVQueryable> {
  
  /// Private
  final private var rawConfig: BVRawConfiguration?
  final private var configuration: BVConfiguration?
  final private var cacheable: Bool = false
  private var preflightClosure: BVURLRequestablePreflightHandler?
  private var baseResponseCompletion: BVURLRequestableHandler?
  private let getResource: String
  
  /// Internal
  internal weak var queryItemable: BVInternalQueryDelegate?
  
  internal init<Concrete: BVQueryableInternal>(_ type: Concrete.Type) {
    self.getResource = type.getResource.map { $0 } ?? String.empty
  }
}

// MARK: - BVInternalQuery: BVConfigureExistentially
extension BVInternalQuery: BVConfigureExistentially {
  @discardableResult
  final func configureExistentially(_ config: BVConfiguration) -> Self {
    configuration = config
    return self
  }
}

// MARK: - BVInternalQuery: BVConfigureRaw
extension BVInternalQuery: BVConfigureRaw {
  var rawConfiguration: BVRawConfiguration? {
    return rawConfig
  }
  
  @discardableResult
  final func configureRaw(_ config: BVRawConfiguration) -> Self {
    rawConfig = config
    return self
  }
}

// MARK: - BVInternalQuery: BVQueryActionableInternal
extension BVInternalQuery: BVQueryActionableInternal {
  
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

// MARK: - BVInternalQuery: BVURLRequestableCacheable
extension BVInternalQuery: BVURLRequestableCacheable {
  var usesURLCache: Bool {
    get {
      return cacheable
    }
    set(newValue) {
      cacheable = newValue
    }
  }
}

// MARK: - BVInternalQuery: BVURLRequestableInternal
extension BVInternalQuery: BVURLRequestableInternal {
  final internal var bvPath: String {
    return getResource
  }
  
  final internal var commonEndpoint: String {
    if let raw = rawConfiguration {
      return raw.endpoint
    }
    return configuration?.endpoint ?? String.empty
  }
}

// MARK: - BVInternalQuery: BVURLQueryItemable
extension BVInternalQuery: BVURLQueryItemable {
  var urlQueryItems: [URLQueryItem]? {
    return queryItemable?.urlQueryItems
  }
}
