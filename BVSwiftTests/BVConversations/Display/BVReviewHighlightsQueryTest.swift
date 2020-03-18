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
    
    func testManagerImplementationForReviewHighlightsQuery() {
        
        let expectation = self.expectation(description: "testReviewHighlights")
        
        BVManager.sharedManager.addConfiguration(BVReviewHighlightsQueryTest.config)
        
        guard let reviewHighlightsQuery = BVManager.sharedManager.query(clientId: "1800petmeds", productId: "prod1011") else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        reviewHighlightsQuery.handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
            
            if case .failure(let error) = response {
                print(error)
                XCTFail()
                expectation.fulfill()
                return
            }
            
            guard case let .success(reviewHighlights) = response else {
                XCTFail()
                expectation.fulfill()
                return
            }
            
            XCTAssertNotNil(reviewHighlights.positives)
            if let positives = reviewHighlights.positives {
                XCTAssertFalse(positives.isEmpty)
                
                for positive in positives {
                    XCTAssertNotNil(positive.title)
                }
            }
            
            XCTAssertNotNil(reviewHighlights.negatives)
            if let negatives = reviewHighlights.negatives {
                XCTAssertFalse(negatives.isEmpty)
                
                for negative in negatives {
                    XCTAssertNotNil(negative.title)
                }
            }

            expectation.fulfill()
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
