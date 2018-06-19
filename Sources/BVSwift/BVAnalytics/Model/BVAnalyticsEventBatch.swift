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
    return "batch"
  }
  
  static var pluralKey: String {
    return "batches"
  }
  
  private let encodedEvents: [BVAnalyticsEventInstance]
  
  private enum CodingKeys: String, CodingKey {
    case batch
  }
  
  internal init(_ encodedEvents: [BVAnalyticsEventInstance]) {
    self.encodedEvents = encodedEvents
  }
  
  public init(from decoder: Decoder) throws {
    self.encodedEvents = []
  }
  
  public func encode(to encoder: Encoder) throws {
    
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    let events: [BVAnyEncodable] =
      encodedEvents.map {
        
        let event =
          ($0.event.serialize($0.anonymous) +
            /// First we will override values that exist in the analytic
            /// events.
            $0.overrides)
            /// Finally, we remove any values that have been overriden as nil
            /// via our encodable nil represented type; BVNil.
            .filter({ return !($0.value.value is BVNil) })
        
        return BVAnyEncodable(event)
    }
    
    try container.encode(events, forKey: .batch)
  }
}

extension BVAnalyticsEventBatch: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return "event"
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}
