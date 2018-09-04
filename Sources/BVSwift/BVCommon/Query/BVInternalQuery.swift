//
//  BVInternalQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal protocol BVInternalQueryDelegate: class, BVURLQueryItemable { }

// MARK: - BVInternalQuery
internal class BVInternalQuery<T: BVQueryable>: BVURLRequest {
  
  /// Internal
  internal weak var queryItemable: BVInternalQueryDelegate?
  
  internal init<Concrete: BVQueryableInternal>(_ type: Concrete.Type) {
    super.init()
    resource = type.getResource.map { $0 } ?? String.empty
  }
}

// MARK: - BVInternalQuery: BVURLQueryItemable
extension BVInternalQuery: BVURLQueryItemable {
  var urlQueryItems: [URLQueryItem]? {
    return queryItemable?.urlQueryItems
  }
}

// MARK: - BVInternalQuery: BVURLRequestableWithHandlerInternal Overrides
extension BVInternalQuery {
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
}
