//
//  BVAuthorQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

/// Public class for handling BVAuthor Queries
/// - Note:
/// \
/// For more information please see the [Documentation].(https://developer.bazaarvoice.com/conversations-api/reference/v5.4/profiles/profile-display)
public class BVAuthorQuery: BVConversationsQuery<BVAuthor> {
  
  /// The Author identifier to query
  public let authorId: String?
  
  /// The initializer for BVAuthorQuery
  /// - Parameters:
  ///   - authorId: The Author identifier to query
  public init(authorId: String) {
    self.authorId = authorId
    
    super.init(BVAuthor.self)
    
    let authorFilter:BVConversationsQueryParameter =
      .filter(
        BVAuthorFilter.authorId(authorId),
        BVRelationalFilterOperator.equalTo,
        nil)
    
    add(authorFilter)
  }
  
  /// Internal
  internal override var conversationsPostflightResultsClosure:
    (([BVAuthor]?) -> Swift.Void)? {
    get {
      return { (results: [BVAuthor]?) in
        if let _ = results,
          let authorId = self.authorId {
          let authorFeatureEvent: BVAnalyticsEvent =
            .feature(
              bvProduct: .profile,
              name: .profile,
              productId: "none",
              brand: nil,
              additional: ["page" : authorId, "interaction" : false])
          BVPixel.track(
            authorFeatureEvent,
            analyticConfiguration: self.configuration?.analyticsConfiguration)
        }
      }
    }
  }
}

// MARK: - BVAuthorQuery: BVConversationsQueryIncludeable
extension BVAuthorQuery: BVConversationsQueryIncludeable {
  public typealias Include = BVAuthorInclude
  
  @discardableResult
  public func include(_ include: Include, limit: UInt16 = 0) -> Self {
    let internalInclude:BVConversationsQueryParameter =
      .include(include, nil)
    add(internalInclude, coalesce: true)
    if limit > 0 {
      let internalIncludeLimit:BVConversationsQueryParameter =
        .includeLimit(include, limit, nil)
      add(internalIncludeLimit)
    }
    return self
  }
}

// MARK: - BVAuthorQuery: BVConversationsQuerySortable
extension BVAuthorQuery: BVConversationsQuerySortable {
  public typealias Sort = BVAuthorSort
  public typealias Order = BVMonotonicSortOrder
  
  @discardableResult
  public func sort(_ sort: Sort, order: Order) -> Self {
    let internalSort: BVConversationsQueryParameter = {
      switch sort {
      case let .answers(by):
        return .sortType(sort, by, order, nil)
      case let .comments(by):
        return .sortType(sort, by, order, nil)
      case let .questions(by):
        return .sortType(sort, by, order, nil)
      case let .reviews(by):
        return .sortType(sort, by, order, nil)
      }
    }()
    
    add(internalSort)
    return self
  }
}

// MARK: - BVAuthorQuery: BVConversationsQueryStatable
extension BVAuthorQuery: BVConversationsQueryStatable {
  public typealias Stat = BVAuthorStat
  
  @discardableResult
  public func stats(_ for: Stat) -> Self {
    let internalStat:BVConversationsQueryParameter = .stats(`for`, nil)
    add(internalStat)
    return self
  }
}
