//
//  BVQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public class BVQuery<BVType: BVQueryable> {
  private var box: BVInternalQuery<BVType>
  
  internal init<BVTypeInternal : BVQueryableInternal>(
    _ type: BVTypeInternal.Type) {
    box = BVInternalQuery<BVType>(type)
    box.queryItemable = self
  }
  
  internal var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    get {
      #if DEBUG
        fatalError("This needs to be overriden.")
      #else
        return nil
      #endif
    }
  }
  
  internal var postflightClosure: BVURLRequestableHandler? {
    get {
      return nil
    }
  }
}

// MARK: - BVQuery: BVURLRequestable
extension BVQuery : BVURLRequestable {
  
  public var request: URLRequest? {
    get {
      return box.request
    }
  }
  
  public func preflight(_ completion: BVCompletionWithErrorsHandler?) -> Bool {
    return box.preflight(completion)
  }
  
  public func process(data: Data?, urlResponse: URLResponse?, error: Error?) {
    box.process(data: data, urlResponse: urlResponse, error: error)
  }
  
  public func process(url: URL?, urlResponse: URLResponse?, error: Error?) {
    box.process(url: url, urlResponse: urlResponse, error: error)
  }
}

// MARK: - BVQuery: BVQueryActionableInternal
extension BVQuery: BVQueryActionableInternal {
  var preflightHandler: BVURLRequestablePreflightHandler? {
    get {
      return box.preflightHandler
    }
    set(newValue) {
      box.preflightHandler = newValue
    }
  }
  
  internal var responseHandler: BVURLRequestableHandler? {
    get {
      return box.responseHandler
    }
    set(newValue) {
      /// We do a little swizzling so we can plumb postflight actions through.
      /// We need to be careful to avoid cycles so we may need to suss this out
      /// a little bit; however, I think this may be fine. Famous last words.
      guard let cmp = newValue else {
        box.responseHandler = nil
        return
      }
      box.responseHandler = {
        cmp($0)
        self.postflight($0)
      }
    }
  }
}

// MARK: - BVQuery: BVInternalQueryDelegate
extension BVQuery: BVInternalQueryDelegate {
  internal var urlQueryItems: [URLQueryItem]? {
    guard let queryItems = urlQueryItemsClosure else {
      return nil
    }
    return queryItems()
  }
}

// MARK: - BVQuery: BVConfigureExistentially
extension BVQuery: BVConfigureExistentially {
  @discardableResult
  final func configureExistentially(_ config: BVConfiguration) -> Self {
    box.configureExistentially(config)
    return self
  }
}

// MARK: - BVQuery: BVQueryPostflightable
extension BVQuery: BVQueryPostflightable {
  internal func postflight(_ response: BVURLRequestableResponseInternal) {
    postflightClosure?(response)
  }
}
