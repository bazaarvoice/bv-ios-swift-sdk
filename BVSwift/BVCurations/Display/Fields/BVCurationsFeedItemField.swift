//
//
//  BVCurationsFeedItemField.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation
import CoreLocation

/// BVCurations supported fields
/// - Note:
/// \
/// These are passed as query items to HTTPS requests.
public enum BVCurationsFeedItemField: BVQueryField {
  
  case after(Date)
  case author(String)
  case before(Date)
  case display(String)
  case featured(UInt16)
  case groups([String])
  case hasGeotag(Bool)
  case hasLink(Bool)
  case hasPhoto(Bool)
  case hasPhotoOrVideo(Bool)
  case hasVideo(Bool)
  case includeProductData(Bool)
  case language(String)
  case productId(BVIdentifier)
  case rating(UInt16)
  case tag(String)
  
  public var description: String {
    return internalDescription
  }
  
  public var representedValue: CustomStringConvertible {
    switch self {
    case let .after(filter):
      return filter.timeIntervalSince1970
    case let .author(filter):
      return filter
    case let .before(filter):
      return filter.timeIntervalSince1970
    case let .display(filter):
      return filter
    case let .featured(filter):
      return filter
    case let .groups(filter):
      return filter.joined(separator: ",")
    case let .hasGeotag(filter):
      return filter
    case let .hasLink(filter):
      return filter
    case let .hasPhoto(filter):
      return filter
    case let .hasPhotoOrVideo(filter):
      return filter
    case let .hasVideo(filter):
      return filter
    case let .includeProductData(filter):
      return filter
    case let .language(filter):
      return filter
    case let .productId(filter):
      return filter
    case let .rating(filter):
      return filter
    case let .tag(filter):
      return filter
    }
  }
}

extension BVCurationsFeedItemField: BVCurationsQueryValue {
  internal var internalDescription: String {
    switch self {
    case .after:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.after
    case .author:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.author
    case .before:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.before
    case .display:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.display
    case .featured:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.featured
    case .groups:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.group
    case .hasGeotag:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.hasGeotag
    case .hasLink:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.hasLink
    case .hasPhoto:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.hasPhoto
    case .hasPhotoOrVideo:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.hasPhotoOrVideo
    case .hasVideo:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.hasVideo
    case .includeProductData:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.includeProductData
    case .language:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.langauge
    case .productId:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.productId
    case .rating:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.rating
    case .tag:
      return BVCurationsConstants.BVCurationsFeedItem.Keys.tag
    }
  }
}
