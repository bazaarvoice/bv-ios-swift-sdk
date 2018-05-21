//
//  BVURLSession.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Shadowed non-closure based extensions
public extension URLSession {
  
  @discardableResult func dataTask(
    with requestable: BVURLRequestable) -> URLSessionDataTask? {
    return dataTask(with: requestable) { (_, _, _) in }
  }
  
  @discardableResult func uploadTask(
    with requestable: BVURLRequestableWithFileURL) -> URLSessionUploadTask? {
    return uploadTask(with: requestable) { (_, _, _) in }
  }
  
  @discardableResult func uploadTask(
    with requestable: BVURLRequestableWithBodyData) -> URLSessionUploadTask? {
    return uploadTask(with: requestable) { (_, _, _) in }
  }
}

/// Shadowed closure based extensions
public extension URLSession {
  
  @discardableResult func dataTask(
    with requestable: BVURLRequestable,
    completionHandler:
    @escaping (
    Data?,
    URLResponse?,
    Error?) -> Swift.Void) -> URLSessionDataTask? {
    
    let action = { (error: Error?) -> URLSessionDataTask? in
      
      if let err = error {
        requestable.process(data: nil, urlResponse: nil, error: err)
        completionHandler(nil, nil, err)
        return nil
      }
      
      guard let request = requestable.request else {
        fatalError("nil request for BVURLRequestable")
      }
      
      let task: URLSessionDataTask = self.dataTask(with: request) {
        (data: Data?, response: URLResponse?, error: Error?) in
        requestable.process(data: data, urlResponse: response, error: error)
        completionHandler(data, response, error)
      }
      task.resume()
      
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
  
  @discardableResult func uploadTask(
    with requestable: BVURLRequestableWithFileURL,
    completionHandler:
    @escaping (
    Data?,
    URLResponse?,
    Error?) -> Swift.Void) -> URLSessionUploadTask? {
    
    let action = { (error: Error?) -> URLSessionUploadTask? in
      
      if let err = error {
        requestable.process(data: nil, urlResponse: nil, error: err)
        completionHandler(nil, nil, err)
        return nil
      }
      
      guard let request = requestable.request else {
        fatalError("nil request for BVURLRequestable")
      }
      
      guard let fileURL = requestable.fileURL else {
        fatalError("nil fileURL for BVURLRequestable")
      }
      
      let task: URLSessionUploadTask =
        self.uploadTask(with: request, fromFile: fileURL) {
          (data: Data?, response: URLResponse?, error: Error?) in
          requestable.process(data: data, urlResponse: response, error: error)
          completionHandler(data, response, error)
      }
      task.resume()
      
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
  
  @discardableResult func uploadTask(
    with requestable: BVURLRequestableWithBodyData,
    completionHandler:
    @escaping (
    Data?,
    URLResponse?,
    Error?) -> Swift.Void) -> URLSessionUploadTask? {
    
    let action = { (error: Error?) -> URLSessionUploadTask? in
      
      if let err = error {
        requestable.process(data: nil, urlResponse: nil, error: err)
        completionHandler(nil, nil, err)
        return nil
      }
      
      guard let request = requestable.request else {
        fatalError("nil request for BVURLRequestable")
      }
      
      guard let bodyData = requestable.bodyData else {
        fatalError("nil bodyData for BVURLRequestable")
      }
      
      let task: URLSessionUploadTask =
        self.uploadTask(with: request, from: bodyData) {
          (data: Data?, response: URLResponse?, error: Error?) in
          requestable.process(data: data, urlResponse: response, error: error)
          completionHandler(data, response, error)
      }
      task.resume()
      
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
  @discardableResult func downloadTask(
    with requestable: BVURLRequestable) -> URLSessionDownloadTask? {
    return downloadTask(with: requestable) { (_, _, _) in }
  }
}

internal extension URLSession {
  @discardableResult func downloadTask(
    with requestable: BVURLRequestable,
    completionHandler:
    @escaping (
    URL?,
    URLResponse?,
    Error?) -> Swift.Void) -> URLSessionDownloadTask? {
    
    let action = { (error: Error?) -> URLSessionDownloadTask? in
      
      if let err = error {
        requestable.process(data: nil, urlResponse: nil, error: err)
        completionHandler(nil, nil, err)
        return nil
      }
      
      guard let request = requestable.request else {
        fatalError("nil request for BVURLRequestable")
      }
      
      let task: URLSessionDownloadTask = self.downloadTask(with: request) {
        (url: URL?, response: URLResponse?, error: Error?) in
        requestable.process(url: url, urlResponse: response, error: error)
        completionHandler(url, response, error)
      }
      task.resume()
      
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

