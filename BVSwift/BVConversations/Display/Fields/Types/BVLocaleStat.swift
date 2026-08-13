//
//  BVLocaleStat.swift
//  BVSwift
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVLocaleStat: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
        return BVConversationsConstants.BVQueryType.Keys.locale
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
