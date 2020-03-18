//
//
//  BVReviewHighlightsReview.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

/// The definition for the BVReviewHighlightsReview type
/// - Note:
/// \
/// It conforms to BVAuxiliaryable (see BVAuxiliaryable notes for more).
public struct BVReviewHighlightsReview: BVAuxiliaryable {
    
    public let rating: UInt?
    public let about: String?
    public let reviewText: String?
    public let author: String?
    public let snippetId: String?
    public let reviewId: String?
    public let summary: String?
    public let submissionTime: String?
    public let reviewTitle: String?
}
