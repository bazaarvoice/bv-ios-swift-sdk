//
//
//  BVReviewHighlightsQueryTest.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest

@testable import BVSwift

class BVReviewHighlightsQueryTest: XCTestCase {

    private static var privateSession:URLSession = {
      return URLSession(configuration: .default)
    }()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReviewHighlights() {
        
        let expectation = self.expectation(description: "testReviewHighlights")
        
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(productId: "prod10002")
            .configure(.display(configType: .staging(clientId: "1800petmeds"),
                                analyticsConfig: .dryRun(
                                    configType: .staging(clientId: "1800petmeds"))))
            
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
                print(response)
        }
        
        
        guard let req = reviewHighlightsQuery.request else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        reviewHighlightsQuery.async(urlSession: BVReviewHighlightsQueryTest.privateSession)
        
        self.waitForExpectations(timeout: 20000) { (error) in
          XCTAssertNil(
            error, "Something went horribly wrong, request took too long.")
        }
    }

}
