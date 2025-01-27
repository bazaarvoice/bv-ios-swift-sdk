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
    
    init(_ _value: String) {
        value = "\(_value)"
    }
}
