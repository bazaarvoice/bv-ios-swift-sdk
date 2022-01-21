//
//
//  BVLanguageStat.swift
//  BVSwift
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVLanguageStat: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
      return BVConversationsConstants.BVQueryType.Keys.language
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
