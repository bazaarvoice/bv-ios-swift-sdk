//
//
//  BVReviewHighlight.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVReviewHighlight: BVAuxiliaryable {
    
    public let presenceCount: Int
    public let mentionsCount: Int
    public let bestExamples: [BVReviewHighlightsReview]
    
    private enum CodingKeys: String, CodingKey {
      case presenceCount = "presenceCount"
      case mentionsCount = "mentionsCount"
      case bestExamples = "bestExamples"
    }
}
