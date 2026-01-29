//
//
//  BVContentCoachQueryable.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVContentCoachQueryPreflightable
internal protocol BVContentCoachQueryPreflightable: BVQueryActionable {
    func contentCoachQueryPreflight(
        _ preflight: BVCompletionWithErrorsHandler?)
}

// MARK: - BVContentCoachQueryPostflightable
internal protocol BVContentCoachQueryPostflightable: BVQueryActionable {
    associatedtype ContentCoachPostflightResult: BVQueryable
    func contentCoachPostflight(_ contentCoach: ContentCoachPostflightResult?)
}

// MARK: - BVContentCoachProductIdfield
internal struct BVContentCoachProductIdfield: BVQueryField {
    private let value: CustomStringConvertible
    
    var internalDescription: String {
        return BVConversationsConstants.BVQueryType.Keys.productId
    }
    
    var representedValue: CustomStringConvertible {
        return value
    }
    
    var description: String {
        return internalDescription
    }
    
    init(_ productId: String) {
        value = productId
    }
}

// MARK: - BVContentCoachReviewTextfield
internal struct BVContentCoachReviewTextfield: BVQueryField {
    private let value: CustomStringConvertible
    
    var internalDescription: String {
        return BVConversationsConstants.BVContentCoach.Keys.reviewText
    }
    
    var representedValue: CustomStringConvertible {
        return value
    }
    
    var description: String {
        return internalDescription
    }
    
    init(_ reviewText: String) {
        value = reviewText
    }
}
