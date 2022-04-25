//
//
//  BVSecondaryRatingStat.swift
//  BVSwift
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVSecondaryRatingStat: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
      return BVConversationsConstants.BVQueryType.Keys.secondaryRatingStats
    }
    
    var representedValue: CustomStringConvertible {
        return value
    }
    
    var description: String {
        return internalDescription
    }
    
    init(_ _value: Bool) {
        value = "\(_value)"
    }
}
