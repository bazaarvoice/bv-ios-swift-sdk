//
//
//  BVCurationsCustomContent.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVCurationsCustomContent: BVSubmissionable {
  public static var singularKey: String {
    get {
      return BVCurationsConstants.BVCurationsCustomContent.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVCurationsConstants.BVCurationsCustomContent.pluralKey
    }
  }
  
  private var encodableDictionary: [String : Encodable]?
  public let author: BVCurationsAuthorSubmission?
  public let photos: [BVCurationsPhotoSubmission]?
  public let text: String?
  public let videos: [BVCurationsVideoSubmission]?
  
  private enum CodingKeys: String, CodingKey {
    case payload
  }
  
  private enum PayloadCodingKeys: CodingKey {
    case author
    case photos
    case text
    case videos
    case custom(String)
    
    var stringValue: String {
      get {
        switch self {
        case .author:
          return "author"
        case .photos:
          return "photos"
        case .text:
          return "text"
        case .videos:
          return "videos"
        case let .custom(value):
          return value
        }
      }
    }
    
    init?(stringValue: String) {
      switch stringValue {
      case "author":
        self = .author
      case "photos":
        self = .photos
      case "text":
        self = .text
      case "videos":
        self = .videos
      default:
        self = .custom(stringValue)
      }
    }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
  }
  
  public init(
    author: BVCurationsAuthorSubmission,
    photos: [BVCurationsPhotoSubmission]? = nil,
    text: String? = nil,
    videos: [BVCurationsVideoSubmission]? = nil) {
    self.author = author
    self.photos = photos
    self.text = text
    self.videos = videos
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    var payloadContainer =
      container.nestedContainer(
        keyedBy: PayloadCodingKeys.self, forKey: .payload)
    
    try payloadContainer.encode(author, forKey: .author)
    try payloadContainer.encode(photos, forKey: .photos)
    try payloadContainer.encode(text, forKey: .text)
    try payloadContainer.encode(videos, forKey: .videos)
    
    guard let dict = encodableDictionary else {
      return
    }
    
    for (key, value) in dict {
      let erase = BVAnyEncodable(value)
      try payloadContainer.encode(erase, forKey: .custom(key))
    }
  }
  
  public init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let payloadContainer =
      try container.nestedContainer(
        keyedBy: PayloadCodingKeys.self, forKey: .payload)
    
    author =
      try payloadContainer.decodeIfPresent(
        BVCurationsAuthorSubmission.self, forKey: .author)
    photos =
      try payloadContainer.decodeIfPresent(
        [BVCurationsPhotoSubmission].self, forKey: .photos)
    text = try payloadContainer.decodeIfPresent(String.self, forKey: .text)
    videos =
      try payloadContainer.decodeIfPresent(
        [BVCurationsVideoSubmission].self, forKey: .videos)
    encodableDictionary = nil
  }
}

extension BVCurationsCustomContent: BVSubmissionableInternal {
  static var postResource: String? {
    get {
      return BVCurationsConstants.BVCurationsCustomContent.postResource
    }
  }
  
  internal mutating func update(_ values: [String : Encodable]?) {
    encodableDictionary = values
  }
}
