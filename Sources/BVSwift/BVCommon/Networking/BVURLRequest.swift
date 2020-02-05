//
//
//  BVURLRequest.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal class BVURLRequest:
BVURLRequestable, BVURLQueryItemable, BVURLRequestUserAgentable {
  
  /// Private
  final private var rawConfig: BVRawConfiguration?
  final private var configuration: BVConfiguration?
  final private var cacheable: Bool = false
  private var preflightClosure: BVURLRequestablePreflightHandler?
  private var postflightClosure: BVURLRequestablePostflightHandler?
  private var baseResponseCompletion: BVURLRequestableHandler?
  
  /// Internal
  internal var resource: String?
  
  internal var urlQueryItems: [URLQueryItem]? {
    return nil
  }
  
  internal var userAgent: String? {
    return nil
  }
  
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
        
        // NOTE:- To make mock API work
        if self.resource == "employee" {
            if let index = urlComponents.queryItems?.firstIndex(where: {$0.name == "filter"}) {
                let filter = urlComponents.queryItems![index]
                
                let newFilter = URLQueryItem(name: "filter", value: filter.value!.replacingOccurrences(of: "eq:", with: ""))
                urlComponents.queryItems?.remove(at: index)
                urlComponents.queryItems?.append(newFilter)
            }
            
            if let index = urlComponents.queryItems?.firstIndex(where: {$0.name == "sort"}) {
                let sort = urlComponents.queryItems![index]
                
                var newSortValue = sort.value?.replacingOccurrences(of: ":asc", with: "")
                newSortValue = newSortValue?.replacingOccurrences(of: ":desc", with: "")
                let newSort = URLQueryItem(name: "sort", value: newSortValue)
                urlComponents.queryItems?.remove(at: index)
                urlComponents.queryItems?.append(newSort)
            }
        }
    }
    
    guard let url: URL = urlComponents.url else {
      return nil
    }
    
    BVLogger
      .sharedLogger.debug("Issuing Query Request to: \(url.absoluteString)")
    
    let cachePolicy: URLRequest.CachePolicy =
      usesURLCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
    
    var request = URLRequest(url: url, cachePolicy: cachePolicy)
    
    if let ua = userAgent {
      request.setValue(ua, forHTTPHeaderField: "User-Agent")
    }
    
    return request
  }
}

// MARK: - BVURLRequest: BVConfigureExistentially
extension BVURLRequest: BVConfigureExistentially {
  @discardableResult
  final func configureExistentially(_ config: BVConfiguration) -> Self {
    configuration = config
    return self
  }
}

// MARK: - BVURLRequest: BVConfigureRaw
extension BVURLRequest: BVConfigureRaw {
  final var rawConfiguration: BVRawConfiguration? {
    return rawConfig
  }
  
  @discardableResult
  final func configureRaw(_ config: BVRawConfiguration) -> Self {
    rawConfig = config
    return self
  }
}

// MARK: - BVURLRequest: BVURLRequestableWithHandlerInternal
extension BVURLRequest: BVURLRequestableWithHandlerInternal {
  final var preflightHandler: BVURLRequestablePreflightHandler? {
    get {
      return preflightClosure
    }
    set(newValue) {
      preflightClosure = newValue
    }
  }
  
  final var postflightHandler: BVURLRequestablePostflightHandler? {
    get {
      return postflightClosure
    }
    set(newValue) {
      postflightClosure = newValue
    }
  }
  
  final internal var responseHandler: BVURLRequestableHandler? {
    get {
      return baseResponseCompletion
    }
    set(newValue) {
      baseResponseCompletion = newValue
    }
  }
}

// MARK: - BVURLRequest: BVURLRequestableCacheable
extension BVURLRequest: BVURLRequestableCacheable {
  final var usesURLCache: Bool {
    get {
      return cacheable
    }
    set(newValue) {
      cacheable = newValue
    }
  }
}

// MARK: - BVURLRequest: BVURLRequestableInternal
extension BVURLRequest: BVURLRequestableInternal {
  final internal var bvPath: String {
    return resource ?? String.empty
  }
  
  final internal var commonEndpoint: String {
    if let raw = rawConfiguration {
      return raw.endpoint
    }
    
    // NOTE:- check added for mock API
    if resource == "employee" {
        return "http://localhost:8080/"
    }
    return configuration?.endpoint ?? String.empty
  }
}
