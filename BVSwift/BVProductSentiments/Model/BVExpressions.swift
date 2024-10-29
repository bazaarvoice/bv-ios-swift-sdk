//
//
//  BVExpressions.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

// MARK: - BVExpressions
public struct BVExpressions: BVQueryable {
    public static var singularKey: String = ""
    
    public static var pluralKey: String = ""

    public let nativeFeature: String?
    public let expressions: [String]?
    public let status: Int?
    public let title: String?
    public let detail: String?
    public let type: String?
    public let instance: String?
}

extension BVExpressions: BVQueryableInternal {
    internal static var getResource: String? {
        return BVProductSentimentsConstants.BVExpressions.getResource
    }
}
