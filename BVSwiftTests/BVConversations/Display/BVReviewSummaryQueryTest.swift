//
//
//  BVReviewSummaryQueryTest.swift
//  BVSwift
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

import Foundation
import XCTest
@testable import BVSwift

class BVReviewSummaryQueryTest: XCTestCase {
    
    private static var config: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .production(clientId: "bv-beauty"))
        
        return BVConversationsConfiguration.display(
            clientKey: "caKfOxPN9v5xDgUjw2DJMG0xndA1QuGJXP0VzYzsUMtvc",
            configType: .production(clientId: "bv-beauty"),
            analyticsConfig: analyticsConfig)
    }()
    
    private static var privateSession: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    override class func setUp() {
        super.setUp()
        
        BVPixel.skipAllPixelEvents = true
    }
    
    override class func tearDown() {
        super.tearDown()
        
        BVPixel.skipAllPixelEvents = false
    }
    
    func testProductReviewSummaryQuery() {
        
        let expectation = self.expectation(
            description: "testProductReviewSummaryQuery")
        
        let reviewSummaryQueryRequest = BVProductReviewSummaryQuery(productId: "P000036")
            .formatType(.bullet)
            .configure(BVReviewSummaryQueryTest.config)
            .handler { (response: BVReviewSummaryQueryResponse<BVReviewSummary>) in
                // success
                
                if case .failure(let error) = response {
                    print(error)
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                guard case let .success(reviewSummary) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                XCTAssertEqual(reviewSummary.title, "REVIEW_SUMMARY")
                XCTAssertNotNil(reviewSummary.summary)
                expectation.fulfill()
            }
        
        reviewSummaryQueryRequest.async()
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
}
