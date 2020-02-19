//
//
//  BVReviewHighlights.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVReviewHighlights: BVQueryable {
    
    static var productId: String?
    static var clientId: String?
    
    public static var singularKey: String {
        return "subjects"
    }
    
    public static var pluralKey: String {
        return "subjects"
    }
    
    public var reviewHighlights: [String: [String: BVReviewHighlight]]?
    
    
    private enum CodingKeys: String, CodingKey {
      case reviewHighlights = "subjects"
    }
}

extension BVReviewHighlights: BVQueryableInternal {
    internal static var getResource: String? {
        
        return "/highlights/v3/1/" + "\(clientId ?? "")/" + "\(productId ?? "")"
    }
}
