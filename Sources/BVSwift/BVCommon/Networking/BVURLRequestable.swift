//
//  BVURLRequestable.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Typealiases for the most commmonly used closures througout the
/// BVURLRequestable family of protocols.
public typealias BVCompletionHandler = (() -> Void)
public typealias BVCompletionWithErrorsHandler = ((Error?) -> Void)

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

/// The protocol concerning itself with types that will register response
/// handlers for when various requests start/finish/error.
public protocol BVURLRequestableWithHandler: BVURLRequestable {
  associatedtype Response
  var ignoringCompletion: Bool { get set }
  func handler(completion: @escaping ((Response) -> Void)) -> Self
}

/// The base protocol for all URLResponses to be packaged into a top level BV
/// object graph.
public protocol BVURLRequestableResponse {
  associatedtype ResponseType
  associatedtype MetaType
  var success: Bool { get }
  var errors: [Error]? { get }
}

/// Default implementations
extension BVURLRequestable {
  var request: URLRequest? {
    return nil
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
}
