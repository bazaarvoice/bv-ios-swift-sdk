//
//
//  BVURLRequestableInternal.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Internal Protocols
internal protocol BVURLRequestableCacheable: BVURLRequestable {
  var usesURLCache: Bool { get set }
}

internal protocol BVURLRequestableInternal: BVURLRequestableCacheable {
  var bvPath: String { get }
  var commonEndpoint: String { get }
}

internal protocol BVURLRequestBodyTypeable: BVURLRequestableWithBodyData {
  var requestBodyType: BVURLRequestBodyType? { get }
}

internal protocol BVURLRequestUserAgentable: BVURLRequestable {
  var userAgent: String? { get }
}

internal protocol BVURLRequestUserAuthorization: BVURLRequestable {
  var userAuthorization: String? { get }
}

internal typealias BVURLRequestableHandler =
  ((BVURLRequestableResponseInternal) -> Void)

internal typealias BVURLRequestablePreflightHandler =
  ((BVCompletionWithErrorsHandler?) -> Void)

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

// MARK: - BVURLRequestBodyType
internal enum BVURLRequestBodyType {
  case multipart(content: [String: Any], fileName: String, boundary: String)
  case json(Data)
  case urlencoded(Data)
}

extension BVURLRequestBodyType: CustomStringConvertible {
  var description: String {
    switch self {
    case let .multipart(_, _, boundary):
      return "multipart/form-data; boundary=" + boundary
    case .json:
      return "application/json"
    case .urlencoded:
      return "application/x-www-form-urlencoded"
    }
  }
}

// MARK: - Internal Protocol Extensions
extension BVURLRequestBodyTypeable {
  public var bodyData: Data? {
    switch requestBodyType {
    case let .some(.multipart(map, fileName, boundary)):
      
      let multipartData = map.reduce(into: Data()) {
        switch $1.value {
        case let value as String:
          $0 += URLRequest
            .multipartData(
              key: $1.key, string: value, boundary: boundary)
        case let value as Data:
          $0 += URLRequest
            .multipartData(
              key: $1.key, data: value, fileName: fileName, boundary: boundary)
        default:
          break
        }
      }
      return (multipartData + URLRequest.encloseMultipartData(boundary))
    case let .some(.json(data)):
      return data
    case let .some(.urlencoded(data)):
      return data
    default:
      return nil
    }
  }
}

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
      responseHandler?(.failure([err]))
      return
    }
    
    guard let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse
      else {
        let err =
          BVCommonError.unknown("URLResponse wasn't an HTTPURLResponse")
        responseHandler?(.failure([err]))
        return
    }
    
    BVLogger.sharedLogger.debug(
      "HTTP RESPONSE: \(httpResponse), status: \(httpResponse.statusCode)")
    
    if let httpError: Error = error {
      let err = BVCommonError.network(
        httpResponse.statusCode, httpError.localizedDescription)
      responseHandler?(.failure([err]))
      return
    }
    
    if 400 < httpResponse.statusCode {
      let err = BVCommonError.network(
        httpResponse.statusCode, "HTTP Response <= 300")
      responseHandler?(.failure([err]))
      return
    }
    
    guard let jsonData: Data = data else {
      let err = BVCommonError.noData
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
