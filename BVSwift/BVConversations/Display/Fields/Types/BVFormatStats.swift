//
//
//  BVFormatStats.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVFormatStats: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
        return BVConversationsConstants.BVReviewSummary.Keys.formatType
    }
    
    var representedValue: CustomStringConvertible {
        return value
    }
    
    var description: String {
        return internalDescription
    }
    
    init(_ _value: BVFormatStatsType) {
        value = _value.representedValue
    }
}

public enum BVFormatStatsType: Int {
  
  case bullet
  case paragraph

  public var representedValue: CustomStringConvertible {
    switch self {
    case .bullet:
        return BVConversationsConstants.BVReviewSummary.Keys.bullet
    case .paragraph:
        return BVConversationsConstants.BVReviewSummary.Keys.paragraph
    }
  }
}
