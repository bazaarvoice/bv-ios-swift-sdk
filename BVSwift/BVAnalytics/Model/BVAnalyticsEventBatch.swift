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
  
  private let encodedEvents: [BVAnalyticsEventInstance]?
  private let generic: Encodable?
  
  private enum CodingKeys: String, CodingKey {
    case batch
  }
  
  internal init(_ encodedEvents: [BVAnalyticsEventInstance]) {
    self.encodedEvents = encodedEvents
    self.generic = nil
  }
  
  internal init(_ generic: Encodable) {
    self.generic = generic
    self.encodedEvents = nil
  }
  
  public init(from decoder: Decoder) throws {
    self.encodedEvents = []
    self.generic = nil
  }
  
  public func encode(to encoder: Encoder) throws {
    
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    let analyticEvents: [BVAnyEncodable] = { () -> [BVAnyEncodable] in
      switch (encodedEvents, generic) {
      case (.some(let events), .none):
        return events.map {
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
      case (.none, .some(let event)):
        return [BVAnyEncodable(event)]
      default:
        return []
      }
    }()
    
    try container.encode(analyticEvents, forKey: .batch)
  }
}

extension BVAnalyticsEventBatch: BVSubmissionableInternal {
  
  internal static var postResource: String? {
    return "event"
  }
  
  internal func update(_ values: [String: Encodable]?) { }
}
