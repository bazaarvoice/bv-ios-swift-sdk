//
//  BVURLRequestable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Public
public typealias BVCompletionHandler = (() -> Swift.Void)
public typealias BVCompletionWithErrorsHandler = ((Error?) -> Swift.Void)

public protocol BVURLRequestable {
  var request: URLRequest? { get }
  func preflight(_ completion: BVCompletionWithErrorsHandler?) -> Bool
  func process(data: Data?, urlResponse: URLResponse?, error: Error?)
  func process(url: URL?, urlResponse: URLResponse?, error: Error?)
}

public protocol BVURLRequestableWithBodyData: BVURLRequestable {
  var bodyData: Data? { get }
}

public protocol BVURLRequestableWithFileURL: BVURLRequestable {
  var fileURL: URL? { get }
}

public protocol BVURLRequestableResponse {
  associatedtype ResponseType
  associatedtype MetaType
  var success: Bool { get }
  var errors: [Error]? { get }
}

public protocol BVURLRequestableWithHandler {
  associatedtype Response
  var ignoringCompletion: Bool { get set }
  func handler(completion: @escaping ((Response) -> Void)) -> Self
}

/// Internal

internal protocol BVURLRequestableInternal {
  var bvPath: String { get }
  var commonEndpoint: String { get }
}

internal typealias BVURLRequestableHandler =
  ((BVURLRequestableResponseInternal) -> Swift.Void)

internal typealias BVURLRequestablePreflightHandler =
  ((BVCompletionWithErrorsHandler?) -> Swift.Void)

internal protocol BVURLRequestableWithHandlerInternal {
  var preflightHandler: BVURLRequestablePreflightHandler? { get set }
  var responseHandler: BVURLRequestableHandler? { get set }
}

internal protocol BVURLParameterable {
  associatedtype ParameterType: BVParameter
  func add(parameter: ParameterType, coalesce: Bool)
  func update(parameter: ParameterType)
}

internal protocol BVURLQueryItemable {
  var urlQueryItems: [URLQueryItem]? { get }
}

internal protocol BVURLRequestBodyable {
  var requestContentType: String? { get }
  func requestBody(_ type: BVSubmissionableInternal) -> BVURLRequestBody?
}

internal protocol BVURLParameterableInternal:
BVURLParameterable, BVURLQueryItemable {
  var parameters: [ParameterType] { get }
}

internal extension BVURLParameterableInternal {
  var queryItems: [URLQueryItem]? {
    get {
      return parameters.map(URLQueryItem.init)
    }
  }
}

// MARK: - BVURLRequestableResponseInternal
internal enum BVURLRequestableResponseInternal {
  public var success: Bool {
    get {
      guard case .success = self else {
        return false
      }
      return true
    }
  }
  
  case success(URLResponse?, Data)
  case failure([Error])
}

// MARK: - BVURLRequestBody
internal enum BVURLRequestBody {
  case multipart([String : Any])
  case raw(Data)
}

