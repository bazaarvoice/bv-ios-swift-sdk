//
//
//  BVFeatureStats.swift
//  BVSwift
//
//  Copyright © 2021 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVFeaturesStats: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
      return BVConversationsConstants.BVQueryType.Keys.feature
    }
    
    var representedValue: CustomStringConvertible {
        return value
    }
    
    var description: String {
        return internalDescription
    }
    
    init(_ _value: String) {
        value = "\(_value)"
    }
    
}
