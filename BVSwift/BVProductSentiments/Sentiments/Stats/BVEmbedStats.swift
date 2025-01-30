//
//
//  BVEmbedStats.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation


internal struct BVEmbedStats: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
        return BVProductSentimentsConstants.BVQueryType.Keys.embed
    }
    
    var representedValue: CustomStringConvertible {
        return value
    }
    
    var description: String {
        return internalDescription
    }
    
    init(_ _value: BVEmbedStatsType) {
        value = _value.representedValue
    }
}


public enum BVEmbedStatsType: Int {
  
  case quotes

  public var representedValue: CustomStringConvertible {
    switch self {
    case .quotes:
        return BVProductSentimentsConstants.BVQueryType.Keys.quotes
    }
  }
}
