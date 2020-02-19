//
//
//  BVReviewHighlightsConstants.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import Foundation

internal struct BVReviewHighlightsConstants {
    
    static let stagingEndpoint: String = ""
    static let productionEndpoint: String = "https://rh.nexus.bazaarvoice.com/"
    
    internal struct BVReviewHighlights {
        static let singularKey: String = "subjects"
        static let pluralKey: String = "subjects"
        static let getResource: String = "highlights/v3/1/"
    }
}
