//
//
//  BVSubmission.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// This is the middleware class used as a public interface into crafting BV
/// specific submission objects.
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
public class BVSubmission {
  private var box: BVInternalSubmission
  private var paramsPriv: [BVURLParameter] = []
  
  internal init(internalType: BVSubmissionableInternal) {
    box = BVInternalSubmission(internalType)
    box.submissionBodyable = self
  }
  
  internal var urlQueryItemsClosure: (() -> [URLQueryItem]?)? {
    #if DEBUG
    BVLogger.sharedLogger.error("This needs to be overriden.")
    #endif
    return nil
  }
  
  internal var contentBodyClosure: ((BVSubmissionableInternal) -> BVURLRequestBody?)? {
    return { (submission: BVSubmissionableInternal) -> BVURLRequestBody? in
      
      /// I think this is a swift bug, but this isn't maleviolent.
      let encodable = BVAnyEncodable(submission)
      guard let data: Data = try? JSONEncoder().encode(encodable) else {
        
        #if DEBUG
        do {
          _ = try JSONEncoder().encode(encodable)
        } catch {
          BVLogger.sharedLogger.error("JSON ERROR: \(error)")
        }
        
        return nil
        #else
        fatalError()
        #endif
      }
      
      return .raw(data)
    }
  }
  
  internal var contentTypeClosure: ((BVSubmissionableInternal) -> String?)? {
    return { _ in
      return "application/json"
    }
  }
  
  internal var postflightClosure: BVURLRequestableHandler? {
    return nil
  }
}

// MARK: - BVSubmission: BVURLRequestableWithBodyData
extension BVSubmission: BVURLRequestableWithBodyData {
  public var bodyData: Data? {
    return box.bodyData
  }
}

// MARK: - BVSubmission: BVURLRequestable
extension BVSubmission: BVURLRequestable {
  
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
      request: request,
      url: url,
      urlResponse: urlResponse,
      error: error)
  }
}

// MARK: - BVSubmission: BVURLRequestableCacheable
extension BVSubmission: BVURLRequestableCacheable {
  var usesURLCache: Bool {
    get {
      return box.usesURLCache
    }
    set(newValue) {
      box.usesURLCache = newValue
    }
  }
}

// MARK: - BVSubmission: BVURLParameterable
extension BVSubmission: BVURLParameterable {
  final internal var parameters: [BVURLParameter] {
    return paramsPriv
  }
  
  final internal func set(_ parameters: [BVURLParameter]) {
    paramsPriv = parameters
  }
}

// MARK: - BVSubmission: BVURLRequestableWithHandlerInternal
extension BVSubmission: BVURLRequestableWithHandlerInternal {
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

// MARK: - BVSubmission: BVConfigureExistentially
extension BVSubmission: BVConfigureExistentially {
  @discardableResult
  final public func configureExistentially(_ config: BVConfiguration) -> Self {
    box.configureExistentially(config)
    return self
  }
}

// MARK: - BVSubmission: BVConfigureRaw
extension BVSubmission: BVConfigureRaw {
  var rawConfiguration: BVRawConfiguration? {
    return box.rawConfiguration
  }
  
  @discardableResult
  func configureRaw(_ config: BVRawConfiguration) -> Self {
    box.configureRaw(config)
    return self
  }
}

// MARK: - BVSubmission: BVSubmissionableConsumable
extension BVSubmission: BVSubmissionableConsumable {
  var submissionableInternal: BVSubmissionableInternal? {
    return box.submissionableInternal
  }
}

// MARK: - BVSubmission: BVInternalSubmissionDelegate
extension BVSubmission: BVInternalSubmissionDelegate {
  var urlQueryItems: [URLQueryItem]? {
    return urlQueryItemsClosure?()
  }
  
  func requestContentType(_ type: BVSubmissionableInternal) -> String? {
    return contentTypeClosure?(type)
  }
  
  func requestBody(_ type: BVSubmissionableInternal) -> BVURLRequestBody? {
    return contentBodyClosure?(type)
  }
}
