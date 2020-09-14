//
//
//  BVIncentivizedStats.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import UIKit

internal struct BVIncentivizedStats: BVQueryField {
    
    private let value: CustomStringConvertible
    
    var internalDescription: String {
        return BVConversationsConstants.BVQueryType.Keys.incentivizedstats
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
