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
    BVLogger.sharedLogger.error(
      BVLogMessage(BVConstants.bvProduct, msg: "This needs to be overriden."))
    #endif
    return nil
  }
  
  internal var contentBodyTypeClosure: (
    (BVSubmissionableInternal) -> BVURLRequestBodyType?)? {
    return { (submission: BVSubmissionableInternal) -> BVURLRequestBodyType? in
      
      /// I think this is a swift bug, but this isn't maleviolent.
      let encodable = BVAnyEncodable(submission)
      guard let data: Data = try? JSONEncoder().encode(encodable) else {
        
        #if DEBUG
        do {
          let sending = try JSONEncoder().encode(encodable)
          print(sending)
        } catch {
          BVLogger.sharedLogger.error(
            BVLogMessage(BVConstants.bvProduct, msg: "JSON ERROR: \(error)"))
        }
        
        return nil
        #else
        fatalError()
        #endif
      }
      
      #if DEBUG
      do {
        let sending =
          try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        BVLogger.sharedLogger.debug("\(sending)")
      } catch {
        BVLogger.sharedLogger.error(
          BVLogMessage(BVConstants.bvProduct, msg: "JSON ERROR: \(error)"))
      }
      #endif
      
      return .json(data)
    }
  }
  
  internal var postflightClosure: BVURLRequestableHandler? {
    return nil
  }
  
  internal var userAgentClosure: (() -> String)? {
    return nil
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
      box.responseHandler = { [weak self] in
        cmp($0)
        self?.postflightHandler?($0)
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

// MARK: - BVSubmission: BVInternalSubmissionDelegate
extension BVSubmission: BVInternalSubmissionDelegate {
  internal var userAgent: String? {
    return userAgentClosure?()
  }
  
  internal var urlQueryItems: [URLQueryItem]? {
    return urlQueryItemsClosure?()
  }
  
  internal var requestBodyType: BVURLRequestBodyType? {
    guard let type = submissionableInternal else {
      return nil
    }
    return contentBodyTypeClosure?(type)
  }
  
  internal var submissionableInternal: BVSubmissionableInternal? {
    return box.submissionableType
  }
}
