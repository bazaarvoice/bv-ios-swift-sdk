//
//
//  BVCurationsMedia.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVCurationsMedia type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
internal struct BVCurationsMedia: BVAuxiliaryable {
  
  public let type: BVCurationsMediaType?
  public let height: UInt16?
  public let width: UInt16?
  
  private enum CodingKeys: String, CodingKey {
    case height
    case width
  }
  
  public init(
    _ type: BVCurationsMediaType, height: UInt16? = nil, width: UInt16? = nil) {
    self.type = type
    self.height = height
    self.width = width
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: BVCodingKey.self)
    
    guard 1 == container.allKeys.count,
      let firstKey = container.allKeys.first else {
        throw BVCurationsError.invalidParameter("Invalid Media Type")
    }
    
    type = BVCurationsMediaType(firstKey.stringValue)
    
    let nested =
      try container.nestedContainer(keyedBy: CodingKeys.self, forKey: firstKey)
    height = try nested.decodeIfPresent(UInt16.self, forKey: .height)
    width = try nested.decodeIfPresent(UInt16.self, forKey: .width)
  }
  
  public func encode(to encoder: Encoder) throws {
    guard let mediaType = type?.rawValue,
      let mediaHeight = height,
      let mediaWidth = width,
      let codingKey: BVCodingKey = BVCodingKey(stringValue: mediaType) else {
        throw BVCurationsError.invalidParameter("Invalid Media Type")
    }
    
    var container = encoder.container(keyedBy: BVCodingKey.self)
    var nested =
      container.nestedContainer(keyedBy: CodingKeys.self, forKey: codingKey)
    try nested.encode(mediaHeight, forKey: .height)
    try nested.encode(mediaWidth, forKey: .width)
  }
}

public enum BVCurationsMediaType: String, BVAuxiliaryable {
  case icon
  case photo
  case video
  case unknown
  
  internal init(_ stringValue: String) {
    switch stringValue {
    case BVCurationsMediaType.icon.rawValue:
      self = .icon
    case BVCurationsMediaType.photo.rawValue:
      self = .photo
    case BVCurationsMediaType.video.rawValue:
      self = .video
    default:
      self = .unknown
    }
  }
}
