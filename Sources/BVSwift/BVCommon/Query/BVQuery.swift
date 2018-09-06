//
//  BVQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// This is the middleware class used as a public interface into crafting BV
/// specific query objects.
/// - Important:
/// \
/// This class is meant to be agonstic of the types and deal mostly in
/// protocols so that no layer violation exists between submodules and code
/// reuse is of utmost importance.
/// - Note:
/// \
/// If you're not internal to BV then it's likely that you shouldn't want
/// to subclass this class, however, if the need arises we can make this open
/// with relative ease.
public class BVQuery<BVType: BVQueryable> {
  private var box: BVInternalQuery<BVType>
  private var paramsPriv: [BVURLParameter] = []
  
  internal init<BVTypeInternal: BVQueryableInternal>(
    _ type: BVTypeInternal.Type) {
    box = BVInternalQuery<BVType>(type)
    box.queryItemable = self
  }
  
  internal var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    #if DEBUG
    BVLogger.sharedLogger.error("This needs to be overriden.")
    #endif
    return nil
  }
}

// MARK: - BVQuery: BVURLRequestable
extension BVQuery: BVURLRequestable {
  
  public var request: URLRequest? {
    return box.request
  }
  
  public func cached(_ request: URLRequest) -> CachedURLResponse? {
    return box.cached(request)
  }
  
  public func preflight(_ completion: BVCompletionWithErrorsHandler?) -> Bool {
    return box.preflight(completion)
  }
  
  public func process(
    request: URLRequest?,
    data: Data?,
    urlResponse: URLResponse?,
    error: Error?) {
    box.process(
      request: request, data: data, urlResponse: urlResponse, error: error)
  }
  
  public func process(
    request: URLRequest?,
    url: URL?,
    urlResponse: URLResponse?,
    error: Error?) {
    box.process(
      request: request, url: url, urlResponse: urlResponse, error: error)
  }
}

// MARK: - BVQuery: BVURLRequestableCacheable
extension BVQuery: BVURLRequestableCacheable {
  var usesURLCache: Bool {
    get {
      return box.usesURLCache
    }
    set(newValue) {
      box.usesURLCache = newValue
    }
  }
}

// MARK: - BVQuery: BVURLParameterable
extension BVQuery: BVURLParameterable {
  final internal var parameters: [BVURLParameter] {
    return paramsPriv
  }
  
  final internal func set(_ parameters: [BVURLParameter]) {
    paramsPriv = parameters
  }
}

// MARK: - BVQuery: BVURLRequestableWithHandlerInternal
extension BVQuery: BVURLRequestableWithHandlerInternal {
  
  var bvPath: String {
    return box.bvPath
  }
  
  var commonEndpoint: String {
    return box.commonEndpoint
  }
  
  var preflightHandler: BVURLRequestablePreflightHandler? {
    get {
      return box.preflightHandler
    }
    set(newValue) {
      box.preflightHandler = newValue
    }
  }
  
  var postflightHandler: BVURLRequestablePostflightHandler? {
    get {
      return box.postflightHandler
    }
    set(newValue) {
      box.postflightHandler = newValue
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
        self.postflightHandler?($0)
      }
    }
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

// MARK: - BVQuery: BVConfigureRaw
extension BVQuery: BVConfigureRaw {
  var rawConfiguration: BVRawConfiguration? {
    return box.rawConfiguration
  }
  
  @discardableResult
  func configureRaw(_ config: BVRawConfiguration) -> Self {
    box.configureRaw(config)
    return self
  }
}

// MARK: - BVQuery: BVInternalQueryDelegate
extension BVQuery: BVInternalQueryDelegate {
  internal var urlQueryItems: [URLQueryItem]? {
    return urlQueryItemsClosure?()
  }
}
