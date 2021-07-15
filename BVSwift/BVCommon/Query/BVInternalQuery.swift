//
//  BVInternalQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

internal protocol BVInternalQueryDelegate:
AnyObject, BVURLQueryItemable, BVURLRequestUserAgentable { }

// MARK: - BVInternalQuery
internal class BVInternalQuery<T: BVQueryable>: BVURLRequest {
  
  /// Internal
  internal weak var queryItemable: BVInternalQueryDelegate?
  
  internal init<Concrete: BVQueryableInternal>(_ type: Concrete.Type) {
    super.init()
    resource = type.getResource.map { $0 } ?? String.empty
  }
  
  override var urlQueryItems: [URLQueryItem]? {
    return queryItemable?.urlQueryItems
  }
  
  override var userAgent: String? {
    return queryItemable?.userAgent
  }
}
