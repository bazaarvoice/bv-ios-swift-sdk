//
//
//  BVCurationsFeedItemQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public class BVCurationsFeedItemQuery: BVCurationsQuery<BVCurationsFeedItem> {
  
  public let displayTags: [String]?
  
  init(_ displayTags: [String]? = nil, limit: UInt16 = 10) {
    self.displayTags = displayTags
    
    super.init(BVCurationsFeedItem.self)
    
    if let tags = displayTags {
      for tag in tags {
        add(.filter(BVCurationsFeedItemFilter.display(tag)))
      }
    }
    
    add(.filter(BVCurationsFeedItemFilter.limit(limit)))
  }
}

// MARK: - BVCurationsFeedItemQuery: BVCurationsQueryFilterable
extension BVCurationsFeedItemQuery: BVCurationsQueryFilterable {
  public typealias Filter = BVCurationsFeedItemFilter
  
  @discardableResult
  public func filter(_ filter: BVCurationsFeedItemFilter) -> Self {
    let internalFilter: BVCurationsQueryParameter =
      .filter(filter)
    add(internalFilter)
    return self
  }
}

// MARK: - BVCurationsFeedItemQuery: BVCurationsQueryMediaOverridable
extension BVCurationsFeedItemQuery: BVCurationsQueryMediaOverridable {
  @discardableResult
  internal func override(_ media: BVCurationsMedia) -> Self {
    if let jsonMedia = try? JSONEncoder().encode(media),
      let jsonString = String(data: jsonMedia, encoding: .utf8) {
      let internalFilter: BVCurationsQueryParameter =
        .custom(
          BVCurationsConstants.BVCurationsFeedItem.Keys.media, jsonString)
      update(internalFilter)
    }
    return self
  }
}
