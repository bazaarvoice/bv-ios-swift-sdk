//
//
//  BVCurationsFeedItem.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVCurationsFeedItem: BVQueryable {
  
  public static var singularKey: String {
    get {
      return BVCurationsConstants.BVCurationsFeedItem.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVCurationsConstants.BVCurationsFeedItem.pluralKey
    }
  }
  
  public private(set) var referencedProducts: [BVCurationsProduct]? = nil
  
  public let author: BVCurationsAuthor?
  public let channel: String?
  public let classification: String?
  public let coordinates: BVCurationsCoordinates?
  public var contentId: BVIdentifier? {
    get {
      return identifier
    }
  }
  public let explicitPermissionStatus: String?
  public let externalId: BVIdentifier?
  public let featuredGroups: [String]?
  public let groups: [String]?
  public var identifier: BVIdentifier?
  public let language: String?
  public let links: [BVCurationsLink]?
  public let permalink: BVCodableSafe<URL>?
  public let photos: [BVCurationsPhoto]?
  public let place: String?
  public let praises: Int?
  public let productId: String?
  public let rating: Int?
  public let replyTo: String?
  public let sourceClient: String?
  public let tags: [String]?
  public let teaser: String?
  public let text: String?
  public let timestamp: Date
  public let token: String?
  public let videos: [BVCurationsVideo]?
  
  private enum CodingKeys: String, CodingKey {
    case author = "author"
    case channel = "channel"
    case classification = "classification"
    case coordinates = "coordinates"
    case explicitPermissionStatus = "explicit_permission_status"
    case externalId = "externalId"
    case featuredGroups = "featured_groups"
    case groups = "groups"
    case identifier = "id"
    case language = "language"
    case links = "links"
    case permalink = "permalink"
    case photos = "photos"
    case place = "place"
    case praises = "praises"
    case productId = "product_id"
    case rating = "rating"
    case replyTo = "reply_to"
    case sourceClient = "sourceClient"
    case tags = "tags"
    case teaser = "teaser"
    case text = "text"
    case timestamp = "timestamp"
    case token = "token"
    case videos = "videos"
  }
}

extension BVCurationsFeedItem: BVQueryableInternal {
  internal static var getResource: String? {
    get {
      return BVCurationsConstants.BVCurationsFeedItem.getResource
    }
  }
}

extension BVCurationsFeedItem: BVCurationsProductUpdatable {
  internal mutating
  func update(_ product: [BVCurationsProduct]) {
    
    guard let referenceTags = tags else {
      return
    }
    
    self.referencedProducts = product.compactMap {
      switch (productId, $0.productId) {
      case let (.some(thisId), .some(id)) where thisId == id:
        return $0
      case let (_, .some(id)) where referenceTags.contains("\(id)"):
        return $0
      default:
        return nil
      }
    }
  }
}

