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
        guard let tokensSubmission = BVMatchedTokensSubmission(tokens) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        tokensSubmission
            .configure(BVMatchedTokensQueryTest.config)
            .handler { (response: BVContentCoachSubmissionResponse<BVMatchedTokens>) in
                switch response {
                case .success(let tokensResponse):
                    guard let status = tokensResponse.status,
                            let error = BVContentCoachError("\(status)", message: tokensResponse.detail)
                    else {
                        guard let tokens = tokensResponse.tokens else {
                            print("No tokens returned")
                            XCTFail()
                            expectation.fulfill()
                            return
                        }
                        print(tokens)
                        XCTAssertEqual(tokensResponse.tokens?.count, 2)
                        XCTAssertNotNil(tokensResponse)
                        expectation.fulfill()
                        return
                    }
                    print(error.code + " : " + error.message)
                    XCTFail()
                    expectation.fulfill()

                case .failure(let errors):
                    errors.forEach { (error: Error) in
                        guard let bverror: BVError = error as? BVError
                        else {
                            print("Unknown error")
                            return
                        }
                        print(bverror.message)
                    }
                    XCTFail()
                    expectation.fulfill()
                }
            }
        
        tokensSubmission.async()
        self.waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
}

