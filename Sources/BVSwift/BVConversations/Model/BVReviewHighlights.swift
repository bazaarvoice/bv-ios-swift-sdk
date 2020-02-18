//
//
//  BVReviewHighlights.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

class BVReviewHighlights: BVQueryable {
    
    static var productId: String?
    static var clientId: String?
    
    static var singularKey: String {
        return "subject"
    }
    
    static var pluralKey: String {
        return "subjects"
    }
    
    public let reviewHighlights: [BVReviewHighlight]?
    
    private enum CodingKeys: String, CodingKey {
      case reviewHighlights = "subjects"
    }
}

extension BVReviewHighlights: BVQueryableInternal {
    internal static var getResource: String? {
        
        return "/highlights/v3/1/" + "\(clientId ?? "")/" + "\(productId ?? "")"
    }
}
