//
//
//  BVInternalSubmissionRequestable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVInternalSubmission: BVURLRequestableWithBodyData
extension BVInternalSubmission: BVURLRequestableWithBodyData {
  
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
    
    let cachePolicy: URLRequest.CachePolicy =
      usesURLCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
    var request: URLRequest = URLRequest(url: url, cachePolicy: cachePolicy)
    request.httpMethod = "POST"
    
    if let contentType: String = submissionBodyable?.requestContentType {
      request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
    
    BVLogger
      .sharedLogger.debug(
        "Issuing Submission Request to: \(url.absoluteString)")
    
    return request
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
    
    guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse
      else {
        let err = BVCommonError.unknown("URLResponse wasn't an HTTPURLResponse")
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
  
  internal var bodyData: Data? {
    guard let bodyable = submissionBodyable,
      let type = submissionableType else {
        return nil
    }
    
    switch bodyable.requestBody(type) {
    case let .some(.multipart(map)):
      
      let multipartData = map.reduce(Data())
      { (result: Data, keyValue: (key: String, value: Any)) -> Data in
        switch keyValue.value {
        case let value as String:
          return (result + URLRequest
            .multipartData(key: keyValue.key, value: value))
        case let value as Data:
          return (result + URLRequest
            .multipartData(key: keyValue.key, value: value))
        default:
          return result
        }
      }
      
      return (multipartData + URLRequest.encloseMultipartData())
    case let .some(.raw(data)):
      return data
    default:
      return nil
    }
  }
}
