//
//
//  BVCurationsFeedItemQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVCurationsFeedItem Queries
/// - Note:
/// \
/// For more information please see the
/// [Documentation].(https://developer.bazaarvoice.com/curations-api/reference/curations-3)
public class BVCurationsFeedItemQuery: BVCurationsQuery<BVCurationsFeedItem> {
  private let limit: UInt16?
  
  init(_ limit: UInt16 = 10) {
    self.limit = limit
    super.init(BVCurationsFeedItem.self)
    add(
      .unsafe(BVCurationsConstants.BVCurationsFeedItem.Keys.limit, limit, nil))
  }
}

// MARK: - BVCurationsFeedItemQuery: BVQueryFieldable
extension BVCurationsFeedItemQuery: BVQueryFieldable {
  public typealias Field = BVCurationsFeedItemField
  
  @discardableResult
  public func field(_ to: Field) -> Self {
    
    switch to {
    case .display:
      fallthrough
    case .language:
      fallthrough
    case .tag:
      add(.field(to, nil), coalesce: true)
    case let .featured(count):
      let currentLimit = limit ?? 10
      let newCount = count <= currentLimit ? count : currentLimit
      add(.field(BVCurationsFeedItemField.featured(newCount), nil))
    default:
      add(.field(to, nil))
    }
    
    return self
  }
}

// MARK: - BVCurationsFeedItemQuery: BVCurationsQueryMediaOverridable
extension BVCurationsFeedItemQuery: BVCurationsQueryMediaOverridable {
  @discardableResult
  internal func override(_ media: BVCurationsMedia) -> Self {
    if let jsonMedia = try? JSONEncoder().encode(media),
      let jsonString = String(data: jsonMedia, encoding: .utf8) {
      update(.unsafe(
        BVCurationsConstants.BVCurationsFeedItem.Keys.media, jsonString, nil))
    }
    return self
  }
}
