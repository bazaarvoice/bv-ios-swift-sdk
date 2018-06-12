//
//
//  BVCurationsChannelContent.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVCurationsChannelContent: BVSubmissionable {
  public static var singularKey: String {
    get {
      return BVCurationsConstants.BVCurationsChannelContent.singularKey
    }
  }
  
  public static var pluralKey: String {
    get {
      return BVCurationsConstants.BVCurationsChannelContent.pluralKey
    }
  }
  
  private var encodableDictionary: [String : Encodable]?
  public let approve: Bool?
  public let bypass: Bool?
  public let url: URL?
  
  private enum CodingKeys: CodingKey {
    case approve
    case bypass
    case url
    case custom(String)
    
    var stringValue: String {
      get {
        switch self {
        case .approve:
          return "approve"
        case .bypass:
          return "bypass"
        case .url:
          return "url"
        case let .custom(value):
          return value
        }
      }
    }
    
    init?(stringValue: String) {
      switch stringValue {
      case "approve":
        self = .approve
      case "bypass":
        self = .bypass
      case "url":
        self = .url
      default:
        self = .custom(stringValue)
      }
    }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
  }
  
  public init(url: URL, approve: Bool? = nil, bypass: Bool? = nil) {
    self.url = url
    self.approve = approve
    self.bypass = bypass
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(approve, forKey: .approve)
    try container.encode(bypass, forKey: .bypass)
    try container.encode(url, forKey: .url)
    
    guard let dict = encodableDictionary else {
      return
    }
    
    for (key, value) in dict {
      let erase = BVAnyEncodable(value)
      try container.encode(erase, forKey: .custom(key))
    }
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    approve = try container.decodeIfPresent(Bool.self, forKey: .approve)
    bypass = try container.decodeIfPresent(Bool.self, forKey: .bypass)
    url = try container.decodeIfPresent(URL.self, forKey: .url)
    encodableDictionary = nil
  }
}

extension BVCurationsChannelContent: BVSubmissionableInternal {
  static var postResource: String? {
    get {
      return BVCurationsConstants.BVCurationsChannelContent.postResource
    }
  }
  
  internal mutating func update(_ values: [String : Encodable]?) {
    encodableDictionary = values
  }
}
