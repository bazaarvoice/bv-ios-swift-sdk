//
//
//  BVReviewTokensQueryTest.swift
//  BVSwift
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVReviewTokensQueryTest: XCTestCase {
    
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
    
    override class func setUp() {
      super.setUp()
      
      BVPixel.skipAllPixelEvents = true
    }
    
    override class func tearDown() {
      super.tearDown()
      
      BVPixel.skipAllPixelEvents = false
    }
    
    func testReviewTokensQuery() {
        let expectation =
        self.expectation(description: "testReviewTokensQuery")
        
        let query = BVReviewTokensQuery(productId: "P000036")
            .configure(BVReviewTokensQueryTest.config)
            .handler { (response: BVContentCoachQueryResponse<BVReviewTokens>) in
                
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
                print(tokensResponse.data ?? "")
                XCTAssertNotNil(tokensResponse)
                expectation.fulfill()
              }
        
        query.async()
        self.waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
}

