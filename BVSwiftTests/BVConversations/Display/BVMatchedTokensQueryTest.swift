//
//
//  BVMatchedTokensQueryTest.swift
//  BVSwift
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

import Foundation

import XCTest
@testable import BVSwift

class BVMatchedTokensQueryTest: XCTestCase {
    
    private static var config: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .production(clientId: "bv-beauty"))
        
        return BVConversationsConfiguration.all(
            clientKey: "caKfOxPN9v5xDgUjw2DJMG0xndA1QuGJXP0VzYzsUMtvc",
            configType: .production(clientId: "bv-beauty"),
            analyticsConfig: analyticsConfig)
    }()
    
    override class func setUp() {
        super.setUp()
        
        BVPixel.skipAllPixelEvents = true
    }
    
    override class func tearDown() {
        super.tearDown()
        
        BVPixel.skipAllPixelEvents = false
    }
    
    func testMatchedTokensQuery() {
        let expectation =
        self.expectation(description: "testMatchedTokensQuery")
        let tokens = BVMatchedTokens(productId: "P000036", reviewText: "This product has great absorption and fragrance.")
        let tokensSubmission = BVMatchedTokensSubmission(tokens)!
            .configure(BVMatchedTokensQueryTest.config)
            .handler { (response: BVContentCoachSubmissionResponse<BVMatchedTokens>) in
                if case .failure(let error) = response {
                    print(error)
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                guard case let .success(tokensResponse) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                guard let status = tokensResponse.status,
                        let sentimentsError =
                        BVContentCoachError("\(status)", message: tokensResponse.detail)
                else {
                    XCTAssertEqual(tokensResponse.tokens?.count, 2)
                    XCTAssertNotNil(tokensResponse)
                    expectation.fulfill()
                    return
                }

                print(sentimentsError.code + " : " + sentimentsError.message)
                XCTFail()
                expectation.fulfill()
            }
        
        tokensSubmission.async()
        self.waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
}

