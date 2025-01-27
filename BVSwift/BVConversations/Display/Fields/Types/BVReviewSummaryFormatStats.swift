//
//
//  BVReviewSummaryFormatStats.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVReviewSummaryFormatStats: BVQueryField {
    
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
    
    init(_ _value: String) {
        value = "\(_value)"
    }
}
