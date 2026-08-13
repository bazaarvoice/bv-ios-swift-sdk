//
//
//  BVProductQuotesQueryTest.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVProductQuotesQueryTest: XCTestCase {
    
    private static var config: BVProductSentimentsConfiguration =
    { () -> BVProductSentimentsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .staging(clientId: "bv-beauty"))
        
        return BVProductSentimentsConfiguration.display(
            clientKey: "OViAhjSr82ZKxinT800bVC8jfyXVRY4w4a17ksQzVbs",
            configType: .staging(clientId: "bv-beauty"),
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
    
    func testProductQuotesQuery() {
        let expectation =
        self.expectation(description: "testProductQuotesQuery")
        let query = BVProductQuotesQuery(productId: "P000036", limit: 10)
            .language("en")
            .configure(BVProductQuotesQueryTest.config)
            .handler { (response: BVProductSentimentsQueryResponse<BVQuotes>) in
                
                if case let .failure(errors) = response {
                    print(errors)
                    errors.forEach { (error: Error) in
                        guard let bverror: BVError = error as? BVError
                        else {
                            XCTFail()
                            expectation.fulfill()
                            return
                        }
                        print(bverror.message)
                        XCTFail()
                        expectation.fulfill()
                    }
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                guard case let .success(result) = response
                else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                guard let status = result.status,
                        let sentimentsError =
                        BVProductSentimentsError("\(status)", message: result.detail)
                else {
                    XCTAssertNotNil(result.quotes)
                    expectation.fulfill()
                    return
                }
                print(sentimentsError.localizedDescription)
                XCTFail()
                expectation.fulfill()
            }
        
        query.async()
        self.waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
}

