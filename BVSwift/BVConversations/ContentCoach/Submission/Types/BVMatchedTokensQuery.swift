//
//
//  BVMatchedTokensQuery.swift
//  BVSwift
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

import Foundation

/// Public class for handling BVMatchedTokens Submissions
public class BVMatchedTokensSubmission: BVContentCoachSubmission<BVMatchedTokens> {
    
    /// The MatchedTokens to submit against
    public var matchedTokens: BVMatchedTokens? {
        return submissionable
    }
    
    /// The initializer for BVMatchedTokens
    /// - Parameters:
    ///   - matchedTokens: The BVMatchedTokens object to submit against.
    public override init?(_ matchedTokens: BVMatchedTokens)  {
        guard let productId = matchedTokens.productId,
              let reviewText = matchedTokens.reviewText else {
            return nil
        }
        super.init(matchedTokens)
        
        customSubmissionParameters =
        [BVConversationsConstants.BVProductId.defaultField: productId,
         BVConversationsConstants.BVContentCoach.Keys.reviewText: reviewText
        ]
    }
    
    /// Internal
    override var
    submissionPostflightResultsClosure: (([BVMatchedTokens]?) -> Void)? {
        return { [weak self] (results: [BVMatchedTokens]?) in
            guard nil != results,
                  let tokens = self?.matchedTokens,
                  let productId = tokens.productId else {
                return
            }
            
            let additional: [String: String] =
            ["contentType": "Content Coach"]
            
            let analyticEvent: BVAnalyticsEvent =
                .feature(
                    bvProduct: .reviews,
                    name: .contentCoach,
                    productId: productId,
                    brand: nil,
                    additional: additional)
            BVPixel.track(
                analyticEvent,
                analyticConfiguration: self?.configuration?.analyticsConfiguration)
        }
    }
}
