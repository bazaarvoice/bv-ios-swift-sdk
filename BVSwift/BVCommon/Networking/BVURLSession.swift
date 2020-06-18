//
//  BVURLSession.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// A shadowing URLSession extension to allow for BVURLRequest types to be
/// executed through URLSessions.
/// - Note:
/// \
/// These extension functions don't use the completion handler variants, but
/// rather, passthrough to them. Obviously, these will be used most often since
/// conformance to BVURLRequest requires calling the respective processing
/// function callback.
public extension URLSession {
  
  /// Shadowed URLSession.dataTask function call
  /// - Parameters:
  ///   - requestable: BVURLRequestable to be invoked
  @discardableResult
    func dataTask(
    with requestable: BVURLRequestable) -> URLSessionDataTask? {
    return dataTask(with: requestable) { (_, _, _) in }
  }
  
  /// Shadowed URLSession.uploadTask function call
  /// - Parameters:
  ///   - requestable: BVURLRequestableWithFileURL to be invoked
  @discardableResult
    func uploadTask(
    with requestable: BVURLRequestableWithFileURL) -> URLSessionUploadTask? {
    return uploadTask(with: requestable) { (_, _, _) in }
  }
  
  /// Shadowed URLSession.uploadTask function call
  /// - Parameters:
  ///   - requestable: BVURLRequestableWithBodyData to be invoked
  @discardableResult
    func uploadTask(
    with requestable: BVURLRequestableWithBodyData) -> URLSessionUploadTask? {
    return uploadTask(with: requestable) { (_, _, _) in }
  }
}

/// A shadowing URLSession extension to allow for BVURLRequest types to be
/// executed through URLSessions.
/// - Note:
/// \
/// These extension functions are exposed not only as a requirement for the
/// other URLSession extensions but also for a convenience just in case there
/// needs to be some granularity of access not provided by the defined types
/// conforming to BVURLRequest, e.g., logging, debugging, etc.
public extension URLSession {
  
  /// Shadowed URLSession.dataTask function call with completion handler
  /// - Parameters:
  ///   - requestable: BVURLRequestable to be invoked
  ///   - completionHandler: The completion handler to be invoked
  /// - Important:
  /// \
  /// If the BVURLRequestable type instantiates preflight handling by returning
  /// true from the preflight function then this function will return nil and
  /// therefore the reference to underlying URLSessionDataTask will be lost at
  /// the call site. This seemed like an adaquate trade-off since the task can
  /// be acquired back if really needed by using a custom URLSession*Delegate
  /// and capturing it there. If this ends up being a problem we'll have to
  /// figure out some way to defer in which case we'll have to change the
  /// function signature to be less "pure" with respect to the original.
  @discardableResult
    func dataTask(
    with requestable: BVURLRequestable,
    completionHandler:
    @escaping (
    Data?,
    URLResponse?,
    Error?) -> Void) -> URLSessionDataTask? {
    
    let action = { [weak self] (error: Error?) -> URLSessionDataTask? in
      
      /// Execute preflight and check for any errors
      if let err = error {
        requestable.process(
          request: nil, data: nil, urlResponse: nil, error: err)
        completionHandler(nil, nil, err)
        return nil
      }
      
      /// Ask nicely for the request object
      guard let request = requestable.request else {
        fatalError("nil request for BVURLRequestable")
      }
      
      /// Next we ask if there's any cached responses laying around for the
      /// request
      if let cached = requestable.cached(request) {
        requestable.process(
            request: request, data: cached.data, urlResponse: cached.response, error: error)
        completionHandler(cached.data, cached.response, nil)
        return nil
      }
      
      let task: URLSessionDataTask? = self?.dataTask(with: request) {
        (data: Data?, response: URLResponse?, error: Error?) in
        requestable.process(
          request: request, data: data, urlResponse: response, error: error)
        completionHandler(data, response, error)
      }
      task?.resume()
      
      return task
    }
    
    /// Have to do preflight first as the request might need information
    /// returned from the preflight handling.
    guard requestable.preflight({ (error: Error?) in
      _ = action(error)
    }) else {
      return action(nil)
    }
    
    return nil
  }
  
  /// Shadowed URLSession.uploadTask function call with completion handler
  /// - Parameters:
  ///   - requestable: BVURLRequestableWithFileURL to be invoked
  ///   - completionHandler: The completion handler to be invoked
  /// - Important:
  /// \
  /// If the BVURLRequestable type instantiates preflight handling by returning
  /// true from the preflight function then this function will return nil and
  /// therefore the reference to underlying URLSessionDataTask will be lost at
  /// the call site. This seemed like an adaquate trade-off since the task can
  /// be acquired back if really needed by using a custom URLSession*Delegate
  /// and capturing it there. If this ends up being a problem we'll have to
  /// figure out some way to defer in which case we'll have to change the
  /// function signature to be less "pure" with respect to the original.
  @discardableResult
    func uploadTask(
    with requestable: BVURLRequestableWithFileURL,
    completionHandler:
    @escaping (
    Data?,
    URLResponse?,
    Error?) -> Void) -> URLSessionUploadTask? {
    
    let action = { [weak self] (error: Error?) -> URLSessionUploadTask? in
      
      /// Execute preflight and check for any errors
      if let err = error {
        requestable.process(
          request: nil, data: nil, urlResponse: nil, error: err)
        completionHandler(nil, nil, err)
        return nil
      }
      
      /// Ask nicely for the request object
      guard let request = requestable.request else {
        fatalError("nil request for BVURLRequestable")
      }
      
      /// Ask nicely for the file handle
      guard let fileURL = requestable.fileURL else {
        fatalError("nil fileURL for BVURLRequestable")
      }
      
      /// Next we ask if there's any cached responses laying around for the
      /// request
      if let cached = requestable.cached(request) {
        completionHandler(cached.data, cached.response, nil)
        return nil
      }
      
      let task: URLSessionUploadTask? =
        self?.uploadTask(with: request, fromFile: fileURL) {
          (data: Data?, response: URLResponse?, error: Error?) in
          requestable.process(
            request: request, data: data, urlResponse: response, error: error)
          completionHandler(data, response, error)
      }
      task?.resume()
      
      return task
    }
    
    /// Have to do preflight first as the request might need information
    /// returned from the preflight handling.
    guard requestable.preflight({ (error: Error?) in
      _ = action(error)
    }) else {
      return action(nil)
    }
    
    return nil
  }
  
  /// Shadowed URLSession.uploadTask function call with completion handler
  /// - Parameters:
  ///   - requestable: BVURLRequestableWithBodyData to be invoked
  ///   - completionHandler: The completion handler to be invoked
  /// - Important:
  /// \
  /// If the BVURLRequestable type instantiates preflight handling by returning
  /// true from the preflight function then this function will return nil and
  /// therefore the reference to underlying URLSessionDataTask will be lost at
  /// the call site. This seemed like an adaquate trade-off since the task can
  /// be acquired back if really needed by using a custom URLSession*Delegate
  /// and capturing it there. If this ends up being a problem we'll have to
  /// figure out some way to defer in which case we'll have to change the
  /// function signature to be less "pure" with respect to the original.
  @discardableResult
    func uploadTask(
    with requestable: BVURLRequestableWithBodyData,
    completionHandler:
    @escaping (
    Data?,
    URLResponse?,
    Error?) -> Void) -> URLSessionUploadTask? {
    
    let action = { [weak self] (error: Error?) -> URLSessionUploadTask? in
      
      /// Execute preflight and check for any errors
      if let err = error {
        requestable.process(
          request: nil, data: nil, urlResponse: nil, error: err)
        completionHandler(nil, nil, err)
        return nil
      }
      
      /// Ask nicely for the request object
      guard let request = requestable.request else {
        fatalError("nil request for BVURLRequestable")
      }
      
      /// Ask nicely for the body data
      guard let bodyData = requestable.bodyData else {
        fatalError("nil bodyData for BVURLRequestable")
      }
      
      /// Next we ask if there's any cached responses laying around for the
      /// request
      if let cached = requestable.cached(request) {
        completionHandler(cached.data, cached.response, nil)
        return nil
      }
      
      let task: URLSessionUploadTask? =
        self?.uploadTask(with: request, from: bodyData) {
          (data: Data?, response: URLResponse?, error: Error?) in
          requestable.process(
            request: request, data: data, urlResponse: response, error: error)
          completionHandler(data, response, error)
      }
      task?.resume()
      
      return task
    }
    
    /// Have to do preflight first as the request might need information
    /// returned from the preflight handling.
    guard requestable.preflight({ (error: Error?) in
      _ = action(error)
    }) else {
      return action(nil)
    }
    
    return nil
  }
}

/// Not sure we need these yet.
internal extension URLSession {
  @discardableResult
  func downloadTask(
    with requestable: BVURLRequestable) -> URLSessionDownloadTask? {
    return downloadTask(with: requestable) { (_, _, _) in }
  }
}

internal extension URLSession {
  @discardableResult
  func downloadTask(
    with requestable: BVURLRequestable,
    completionHandler:
    @escaping (
    URL?,
    URLResponse?,
    Error?) -> Void) -> URLSessionDownloadTask? {
    
    let action = { [weak self] (error: Error?) -> URLSessionDownloadTask? in
      
      /// Execute preflight and check for any errors
      if let err = error {
        requestable.process(
          request: nil, data: nil, urlResponse: nil, error: err)
        completionHandler(nil, nil, err)
        return nil
      }
      
      /// Ask nicely for the request object
      guard let request = requestable.request else {
        fatalError("nil request for BVURLRequestable")
      }
      
      /// Next we ask if there's any cached responses laying around for the
      /// request
      if let cached = requestable.cached(request) {
        completionHandler(cached.response.url, cached.response, nil)
        return nil
      }
      
      let task: URLSessionDownloadTask? = self?.downloadTask(with: request) {
        (url: URL?, response: URLResponse?, error: Error?) in
        requestable.process(
          request: request, url: url, urlResponse: response, error: error)
        completionHandler(url, response, error)
      }
      task?.resume()
      
      return task
    }
    
    /// Have to do preflight first as the request might need information
    /// returned from the preflight handling.
    guard requestable.preflight({ (error: Error?) in
      _ = action(error)
    }) else {
      return action(nil)
    }
    
    return nil
  }
}
