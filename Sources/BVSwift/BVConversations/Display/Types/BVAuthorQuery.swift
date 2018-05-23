//
//  BVAuthorQuery.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

public final class BVAuthorQuery: BVConversationsQuery<BVAuthor> {
  /// Private
  private var authorIdPriv: String
  
  private struct BVAuthorFilter: BVConversationsQueryFilter {
    var description: String {
      get {
        return BVConversationsConstants.BVAuthors.Keys.authorId
      }
    }
  }
  
  /// Internal
  internal override var conversationsPostflightResultsClosure:
    (([BVAuthor]?) -> Swift.Void)? {
    get {
      return { (results: [BVAuthor]?) in
        if let _ = results  {
          let authorFeatureEvent: BVAnalyticsEvent =
            .feature(
              bvProduct: .profile,
              name: .profile,
              productId: "none",
              brand: nil,
              additional: ["page" : self.authorIdPriv, "interaction" : false])
          BVPixel.track(
            authorFeatureEvent,
            analyticConfiguration: self.configuration?.analyticsConfiguration)
        }
      }
    }
  }
  
  /// Public
  public var authorId: String {
    get {
      return authorIdPriv
    }
  }
  
  public init(authorId: String) {
    authorIdPriv = authorId
    
    super.init(BVAuthor.self)
    
    let authorFilter:BVConversationsQueryParameter =
      .filter(
        BVAuthorFilter(),
        BVRelationalFilterOperator.equalTo,
        [authorIdPriv],
        nil)
    
    add(parameter: authorFilter)
  }
}

// MARK: - BVAuthorQuery: BVConversationsQueryIncludeable
extension BVAuthorQuery: BVConversationsQueryIncludeable {
  public typealias Include = BVAuthorInclude
  
  @discardableResult public func include(
    _ include: Include, limit: UInt16 = 0) -> Self {
    let internalInclude:BVConversationsQueryParameter = .include(include, nil)
    add(parameter: internalInclude, coalesce: true)
    if limit > 0 {
      let internalIncludeLimit:BVConversationsQueryParameter =
        .includeLimit(include, limit, nil)
      add(parameter: internalIncludeLimit)
    }
    return self
  }
}

// MARK: - BVAuthorQuery: BVConversationsQuerySortable
extension BVAuthorQuery: BVConversationsQuerySortable {
  public typealias Sort = BVAuthorSort
  public typealias Order = BVMonotonicSortOrder
  
  @discardableResult public func sort(
    _ sort: Sort, order: Order) -> Self {
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
    
    add(parameter: internalSort)
    return self
  }
}

// MARK: - BVAuthorQuery: BVConversationsQueryStatable
extension BVAuthorQuery: BVConversationsQueryStatable {
  public typealias Stat = BVAuthorStat
  
  @discardableResult public func stats(
    _ for: Stat) -> Self {
    let internalStat:BVConversationsQueryParameter = .stats(`for`, nil)
    add(parameter: internalStat)
    return self
  }
}
