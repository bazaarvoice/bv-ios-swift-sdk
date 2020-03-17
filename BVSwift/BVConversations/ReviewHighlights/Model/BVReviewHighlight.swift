//
//
//  BVReviewHighlight.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

public struct BVReviewHighlight: BVAuxiliaryable {
    
    public var title: String?
    public let presenceCount: Int?
    public let mentionsCount: Int?
    public let bestExamples: [BVReviewHighlightsReview]?
}
