//
//
//  BVReviewHighlight.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVReviewHighlight: BVAuxiliaryable {
    
    public let mentionsCount: Int
    
    private enum CodingKeys: String, CodingKey {
      case mentionsCount = "mentionsCount"
    }
}
