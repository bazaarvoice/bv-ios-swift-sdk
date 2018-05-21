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
  private var preflightClosure: BVURLRequestablePreflightHandler?
  private var baseResponseCompletion: BVURLRequestableHandler?
  private let getResource: String
  
  /// Internal
  final internal var configurationType: BVConfiguration?
  internal weak var queryItemable: BVInternalQueryDelegate?
  
  internal init<Concrete: BVQueryableInternal>(_ type: Concrete.Type) {
    self.getResource = type.getResource.map { $0 } ?? String.empty
  }
}

// MARK: - BVInternalQuery: BVConfigureExistentially
extension BVInternalQuery: BVConfigureExistentially {
  @discardableResult
  final func configureExistentially(_ config: BVConfiguration) -> Self {
    configurationType = config
    return self
  }
}

// MARK: - BVInternalQuery: BVQueryInternal
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

// MARK: - BVInternalQuery: BVURLRequestableInternal
extension BVInternalQuery: BVURLRequestableInternal {
  final internal var bvPath: String {
    get {
      return getResource
    }
  }
  
  final internal var commonEndpoint: String {
    get {
      return configurationType?.endpoint ?? String.empty
    }
  }
}

// MARK: - BVInternalQuery: BVURLQueryItemable
extension BVInternalQuery: BVURLQueryItemable {
  var urlQueryItems: [URLQueryItem]? {
    return queryItemable?.urlQueryItems
  }
}
