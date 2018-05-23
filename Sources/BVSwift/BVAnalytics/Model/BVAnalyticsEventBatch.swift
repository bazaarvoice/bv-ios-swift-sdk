//
//
//  BVAnalyticsEventBatch.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVAnalyticsEventBatch: BVSubmissionable {
  
  static var singularKey: String {
    get {
      return "batch"
    }
  }
  
  static var pluralKey: String {
    get {
      return "batches"
    }
  }
  
  private let encodedEvents: [BVAnalyticsEventInstance]
  
  private enum CodingKeys: String, CodingKey {
    case batch = "batch"
  }
  
  internal init(_ encodedEvents: [BVAnalyticsEventInstance]) {
    self.encodedEvents = encodedEvents
  }
  
  public init(from decoder: Decoder) throws {
    self.encodedEvents = []
  }
  
  public func encode(to encoder: Encoder) throws {
    
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(
      encodedEvents.map {
        BVAnyEncodable(
          $0.event.serialize($0.anonymous)) }, forKey: .batch)
  }
}

extension BVAnalyticsEventBatch: BVSubmissionableInternal {
  internal static var postResource: String? {
    get {
      return "event"
    }
  }
}
