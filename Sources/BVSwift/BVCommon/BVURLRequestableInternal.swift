//
//
//  BVURLRequestableInternal.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Internal Protocols
internal protocol BVURLRequestBodyable: BVURLRequestable {
  func requestContentType(_ type: BVSubmissionableInternal) -> String?
  func requestBody(_ type: BVSubmissionableInternal) -> BVURLRequestBody?
}

internal protocol BVURLRequestableCacheable: BVURLRequestable {
  var usesURLCache: Bool { get set }
}

internal protocol BVURLRequestableInternal: BVURLRequestableCacheable {
  var bvPath: String { get }
  var commonEndpoint: String { get }
}

internal typealias BVURLRequestableHandler =
  ((BVURLRequestableResponseInternal) -> Swift.Void)

internal typealias BVURLRequestablePreflightHandler =
  ((BVCompletionWithErrorsHandler?) -> Swift.Void)

internal typealias BVURLRequestablePostflightHandler = BVURLRequestableHandler

internal protocol BVURLRequestableWithHandlerInternal: BVURLRequestableInternal {
  var preflightHandler: BVURLRequestablePreflightHandler? { get set }
  var postflightHandler: BVURLRequestablePostflightHandler? { get set }
  var responseHandler: BVURLRequestableHandler? { get set }
}

// MARK: - BVURLRequestableResponseInternal
internal enum BVURLRequestableResponseInternal {
  public var success: Bool {
    guard case .success = self else {
      return false
    }
    return true
  }
  
  case success(URLResponse?, Data)
  case failure([Error])
}

// MARK: - BVURLRequestBody
internal enum BVURLRequestBody {
  case multipart(content: [String: Any], boundary: String?)
  case raw(Data)
}

// MARK: - Internal Protocol Extensions
extension BVURLRequestableWithHandlerInternal {
  func preflight(_ completion: BVCompletionWithErrorsHandler?) -> Bool {
    guard let handler = preflightHandler else {
      return false
    }
    handler(completion)
    return true
  }
  
  func process(
    request: URLRequest?,
    data: Data?,
    urlResponse: URLResponse?,
    error: Error?) {
    
    guard nil != responseHandler else {
      fatalError(
        "No completion response block given for query, make sure you" +
        "explicitly mark ignoringCompletion if this is what you intended.")
    }
    
    if let err = error {
      assert(false, err.localizedDescription)
      
      responseHandler?(.failure([err]))
      return
    }
    
    guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse
      else {
        let err =
          BVCommonError.unknown("URLResponse wasn't an HTTPURLResponse")
        assert(false, err.description)
        
        responseHandler?(.failure([err]))
        return
    }
    
    if let httpError: Error = error, 200 != httpResponse.statusCode {
      let err = BVCommonError.network(
        httpResponse.statusCode, httpError.localizedDescription)
      assert(false, err.description)
      
      responseHandler?(.failure([err]))
      return
    }
    
    guard let jsonData: Data = data else {
      let err = BVCommonError.noData
      assert(false, err.description)
      responseHandler?(.failure([err]))
      return
    }
    
    /// We'll only cache successful calls with successful requests
    switch request {
    case let .some(req)
      where req.cachePolicy == .returnCacheDataDontLoad ||
        req.cachePolicy == .returnCacheDataElseLoad:
      let cachedResponse =
        CachedURLResponse(response: httpResponse, data: jsonData)
      BVURLCacheManager.shared.store(cachedResponse, request: req)
    default:
      break
    }
    
    responseHandler?(.success(urlResponse, jsonData))
  }
  
  func process(
    request: URLRequest?,
    url: URL?,
    urlResponse: URLResponse?,
    error: Error?) {
    fatalError("Processing requests via URL isn't supported yet.")
  }
}
