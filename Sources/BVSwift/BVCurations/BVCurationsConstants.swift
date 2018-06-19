//
//
//  BVCurationsConstants.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation


internal struct BVCurationsConstants {
  
  static let apiKey: String = "apiKeyCurations"
  static let clientKey: String = "client"
  static let parameterKey: String = "passkey"
  static let stagingEndpoint: String =
  "https://stg.api.bazaarvoice.com/curations/c3/content/"
  static let productionEndpoint: String =
  "https://api.bazaarvoice.com/curations/c3/content/"
  
  internal struct ErrorMessages {
    static let invalidApproveOrBypassField: String = "bad string"
  }
  
  internal struct BVCurationsAuthor {
    static let singularKey: String = "Author"
    static let pluralKey: String = "Authors"
  }
  
  internal struct BVCurationsChannelContent {
    static let singularKey: String = "ChannelContent"
    static let pluralKey: String = "ChannelContent"
    static let postResource: String = "url"
  }
  
  internal struct BVCurationsCustomContent {
    static let singularKey: String = "CustomContent"
    static let pluralKey: String = "CustomContent"
    static let postResource: String = "custom"
  }
  
  internal struct BVCurationsFeedItem {
    static let singularKey: String = "FeedItem"
    static let pluralKey: String = "FeedItems"
    static let getResource: String = "get"
    
    internal struct Keys {
      static let absoluteLocation: String = "geolocation"
      static let after: String = "after"
      static let author: String = "author"
      static let before: String = "before"
      static let display: String = "display"
      static let externalId: String = "externalId"
      static let featured: String = "featured"
      static let group: String = "has_geotag"
      static let hasGeotag: String = "geolocation"
      static let hasLink: String = "has_link"
      static let hasPhoto: String = "has_photo"
      static let hasPhotoOrVideo: String = "has_photo_or_video"
      static let hasVideo: String = "has_video"
      static let includeComments: String = "include_comments"
      static let includeProductData: String = "withProductData"
      static let langauge: String = "languages"
      static let limit: String = "limit"
      static let media: String = "media"
      static let productId: String = "productId"
      static let rating: String = "rating"
      static let tag: String = "tags"
    }
  }
  
  internal struct Testing {
    static let stagingEndpoint: String =
    "https://srrq8ymzrg.execute-api.us-east-1.amazonaws.com/dev/content/"
    static let productionEndpoint: String =
    "https://lwp8q9794k.execute-api.us-east-1.amazonaws.com/prod/content/"
  }
}
