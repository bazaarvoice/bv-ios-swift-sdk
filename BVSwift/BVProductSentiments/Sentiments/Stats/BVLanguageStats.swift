//
//
//  BVLanguageStats.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVLanguageStats: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
      return BVProductSentimentsConstants.BVQueryType.Keys.language
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
