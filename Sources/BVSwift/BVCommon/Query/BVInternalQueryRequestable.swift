//
//  BVInternalQueryRequestable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

extension BVInternalQuery: BVURLRequestable {
  
  internal var request: URLRequest? {
    if commonEndpoint.isEmpty {
      fatalError(
        "Endpoint value is empty, make sure you configure the query first.")
    }
    
    let urlString: String = "\(commonEndpoint)\(bvPath)"
    guard var urlComponents: URLComponents =
      URLComponents(string: urlString) else {
        return nil
    }
    
    if let items = urlQueryItems,
      !items.isEmpty {
      urlComponents.queryItems = items
    }
    
    guard let url: URL = urlComponents.url else {
      return nil
    }
    
    BVLogger
      .sharedLogger.debug("Issuing Query Request to: \(url.absoluteString)")
    
    let cachePolicy: URLRequest.CachePolicy =
      usesURLCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
    return URLRequest(url: url, cachePolicy: cachePolicy)
  }
  
  func cached(_ request: URLRequest) -> CachedURLResponse? {
    switch request.cachePolicy {
    case .returnCacheDataDontLoad:
      fallthrough
    case .returnCacheDataElseLoad:
      return BVURLCacheManager.shared.load(request)
    default:
      return nil
    }
  }
  
  func preflight(_ completion: BVCompletionWithErrorsHandler?) -> Bool {
    guard let handler = preflightHandler else {
      return false
    }
    handler(completion)
    return true
  }
  
  internal final
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
  
  internal final
  func process(
    request: URLRequest?,
    url: URL?,
    urlResponse: URLResponse?,
    error: Error?) {
    fatalError("Processing requests via URL isn't supported yet.")
  }
}
