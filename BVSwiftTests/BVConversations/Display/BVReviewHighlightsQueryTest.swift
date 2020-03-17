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

    private static var config: BVReviewHighlightsConfiguration = { () -> BVReviewHighlightsConfiguration in
        let analyticsConfig: BVAnalyticsConfiguration =  .dryRun(configType: .staging(clientId: "1800petmeds"))
        
        return BVReviewHighlightsConfiguration.display(configType: .staging(clientId: "1800petmeds"), analyticsConfig: analyticsConfig)
    }()
    
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
        
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "prod10002")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
                expectation.fulfill()
                print(response)
                // TODO:- Add assertion statements
        }
        
        
        guard let req = reviewHighlightsQuery.request else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        print(req)
        
        reviewHighlightsQuery.async(urlSession: BVReviewHighlightsQueryTest.privateSession)
        
        self.waitForExpectations(timeout: 10) { (error) in
          XCTAssertNil(
            error, "Something went horribly wrong, request took too long.")
        }
    }

}
