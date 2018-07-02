//
//  BVURLRequestable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Typealiases for the most commmonly used closures througout the
/// BVURLRequestable family of protocols.
public typealias BVCompletionHandler = (() -> Swift.Void)
public typealias BVCompletionWithErrorsHandler = ((Error?) -> Swift.Void)

/// The main base protocol for BV based networking requests.
public protocol BVURLRequestable {
  
  /// The request object constructed from the conforming type
  /// - Note:
  /// \
  /// Argueably the most important conformance, because, without it, we cannot
  /// have all the pieces fit together to construct the actions necessary to
  /// query or submit.
  var request: URLRequest? { get }
  
  /// Callback function for handling whether there exists a cached response
  /// somewhere that can be used for the issuing request.
  /// - Parameters:
  ///   - request: The request to use as a lookup for a cached response
  func cached(_ request: URLRequest) -> CachedURLResponse?
  
  /// Callback function for handling anything needed before construction of the
  /// URLRequest object and then the intial networking call happens.
  /// - Parameters:
  ///   - completion: The callback closure to be invoked
  func preflight(_ completion: BVCompletionWithErrorsHandler?) -> Bool
  
  /// Callback function for handling the processing of a URLResponse coming in
  /// from a URL data request.
  /// - Parameters:
  ///   - request: The request that this process call originated
  ///   - data: The data returned from the URLRequest
  ///   - urlResponse: The URLResponse returned from the URLRequest
  ///   - error: Any error encountered through the URLRequest
  func process(
    request: URLRequest?,
    data: Data?,
    urlResponse: URLResponse?,
    error: Error?)
  
  /// Callback function for handling the processing of a URLResponse coming in
  /// from a URL request.
  /// - Parameters:
  ///   - request: The request that this process call originated
  ///   - url: The url usd for the URLRequest
  ///   - urlResponse: The URLResponse returned from the URLRequest
  ///   - error: Any error encountered through the URLRequest
  func process(
    request: URLRequest?,
    url: URL?,
    urlResponse: URLResponse?,
    error: Error?)
}

/// This protocol augments the BVURLRequestable protocol by having conformance
/// for requests that will have a body.
public protocol BVURLRequestableWithBodyData: BVURLRequestable {
  var bodyData: Data? { get }
}

/// This protocol augments the BVURLRequestable protocol by having conformance
/// for requests that will likley be pulling some raw data from file.
public protocol BVURLRequestableWithFileURL: BVURLRequestable {
  var fileURL: URL? { get }
}

/// The base protocol for all URLResponses to be packaged into a top level BV
/// object graph.
public protocol BVURLRequestableResponse {
  associatedtype ResponseType
  associatedtype MetaType
  var success: Bool { get }
  var errors: [Error]? { get }
}

/// The protocol concerning itself with types that will register response
/// handlers for when various requests start/finish/error.
public protocol BVURLRequestableWithHandler {
  associatedtype Response
  var ignoringCompletion: Bool { get set }
  func handler(completion: @escaping ((Response) -> Void)) -> Self
}

/// Internal
internal protocol BVURLRequestableCacheable {
  var usesURLCache: Bool { get set }
}

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
  func add(_ parameter: ParameterType, coalesce: Bool)
  func update(_ parameter: ParameterType)
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
    return parameters.map(URLQueryItem.init)
  }
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
  case multipart([String: Any])
  case raw(Data)
}
