//
//
//  BVReviewHighlightsQueryTest.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

/*
 Test case Scenarios:
 
 Both Pros and Cons are returned for a valid productId and clientId.
 Only Pros are returned and no Cons are returned for a valid productId and clientId.
 Only Cons are returned and no Pros are returned for a valid productId and clientId.
 The count of PROS and CONS Should be equal to or less then five.
 No Pros and Cons are returned for a valid productId and clientId (Review count < 10, Excluding incentivised reviews review count < 10).
 The given productId is invalid. In this case a specific error should be returned.
 The given clientId is invalid. In this case a specific error should be returned.
 The clientId does not have RH enabled. In this case a specific error should be returned.
 Pros & Cons should not be mismatched.
 The sequence of the Pros and Cons should be the same as return in Response.
 */

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
                
                //Remove this
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
    
    //Both Pros and Cons are returned for a valid productId and clientId.
    func testProsAndCons() {
        
        let expectation = self.expectation(description: "testProsAndCons")
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "prod1011")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
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
                
                XCTAssertNotNil(reviewHighlights.negatives)
                XCTAssertNotNil(reviewHighlights.positives)
                
                if let negatives = reviewHighlights.negatives {
                    XCTAssertFalse(negatives.isEmpty)
                    
                    for negative in negatives {
                        XCTAssertNotNil(negative.title)
                    }
                }
                
                if let positives = reviewHighlights.positives {
                    XCTAssertFalse(positives.isEmpty)
                    
                    for positive in positives {
                        XCTAssertNotNil(positive.title)
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
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
    //Only Pros are returned and no Cons are returned for a valid productId and clientId.
    func testOnlyProsAndNoCons() {
        
        let expectation = self.expectation(description: "testOnlyProsAndNoCons")
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "prod10002")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
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
                    XCTAssertTrue(negatives.isEmpty)
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
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    //Only Cons are returned and no Pros are returned for a valid productId and clientId.
    func testOnlyConsAndNoPros() {
        
        let expectation = self.expectation(description: "testOnlyConsAndNoPros")
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "prod1022")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
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
                
                
                XCTAssertNotNil(reviewHighlights.negatives)
                
                if let negatives = reviewHighlights.negatives {
                    XCTAssertFalse(negatives.isEmpty)
                    
                    for negative in negatives {
                        XCTAssertNotNil(negative.title)
                    }
                }
                
                XCTAssertNotNil(reviewHighlights.positives)
                
                if let positives = reviewHighlights.positives {
                    XCTAssertTrue(positives.isEmpty)
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
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    //No Pros and No Cons are returned for a valid productId and clientId (Review count < 10, Excluding incentivised reviews review count < 10).
    func testNoProsAndNoCons() {
        
        let expectation = self.expectation(description: "testNoProsAndCons")
        
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "5068ZW")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
                if case .failure(let error) = response {
                    print(error)
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                    return
                }
                
                guard case .success(_) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                XCTFail("success block should not be called")
                
                expectation.fulfill()
        }
        
        guard let req = reviewHighlightsQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        reviewHighlightsQuery.async(urlSession: BVReviewHighlightsQueryTest.privateSession)
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    //The count of PROS and CONS Should be equal to or less then five.
    func testCountOfProsAndConsNotMoreThanFive() {
        
        let expectation = self.expectation(description: "testCountOfProsAndConsNotMoreThanFive")
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "prod10002")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
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
                XCTAssertNotNil(reviewHighlights.negatives)
                
                if let negatives = reviewHighlights.negatives {
                    
                    for negative in negatives {
                        XCTAssertNotNil(negative.title)
                    }
                    
                    XCTAssertFalse(negatives.count > 5)
                }
                
                if let positives = reviewHighlights.positives {
                    
                    for positive in positives {
                        XCTAssertNotNil(positive.title)
                    }
                    
                    XCTAssertFalse(positives.count > 5)
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
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    //The given productId is invalid. In this case a specific error should be returned.
    func testInvalidProductId() {
        
        let expectation = self.expectation(description: "testInvalidProductId")
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "invalidProductId")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
                if case .failure(let error) = response {
                    print(error)
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                    return
                }
                
                guard case .success(_) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                XCTFail("success block should not be called")
                expectation.fulfill()
        }
        
        guard let req = reviewHighlightsQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        reviewHighlightsQuery.async(urlSession: BVReviewHighlightsQueryTest.privateSession)
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
    //The given clientId is invalid. In this case a specific error should be returned.
    func testInvalidClientId() {
        
        let expectation = self.expectation(description: "testInvalidClientId")
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "invalidClinetId", productId: "prod10002")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
                if case .failure(let error) = response {
                    print(error)
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                    return
                }
                
                guard case .success(_) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                XCTFail("success block should not be called")
                
                expectation.fulfill()
        }
        
        guard let req = reviewHighlightsQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        reviewHighlightsQuery.async(urlSession: BVReviewHighlightsQueryTest.privateSession)
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
    //The clientId does not have RH enabled. In this case a specific error should be returned.
    func testReviewHighlightsNotEnabled() {
        
        let expectation = self.expectation(description: "testReviewHighlightsNotEnabled")
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "5068ZW")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
                if case .failure(let error) = response {
                    print(error)
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                    return
                }
                
                guard case .success(_) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                XCTFail("success block should not be called")
                expectation.fulfill()
        }
        
        guard let req = reviewHighlightsQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        reviewHighlightsQuery.async(urlSession: BVReviewHighlightsQueryTest.privateSession)
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
    //Pros & Cons should not be mismatched.
    func testProsAndConsNotMismatched() {
        
        let expectation = self.expectation(description: "testProsAndConsNotMismatched")
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "prod1011")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
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
                
                
                XCTAssertNotNil(reviewHighlights.negatives)
                XCTAssertNotNil(reviewHighlights.positives)
                
                if let negatives = reviewHighlights.negatives {
                    XCTAssertFalse(negatives.isEmpty)
                    
                    for negative in negatives {
                        XCTAssertNotNil(negative.title)
                    }
                }
                
                if let positives = reviewHighlights.positives {
                    XCTAssertFalse(positives.isEmpty)
                    
                    for positive in positives {
                        XCTAssertNotNil(positive.title)
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
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
    //The sequence of the Pros and Cons should be the same as return in Response.
    func testProsAndConsSequence() {
        
        let expectation = self.expectation(description: "testProsAndConsSequence")
        let reviewHighlightsQuery = BVProductReviewHighlightsQuery(clientId: "1800petmeds", productId: "prod1011")
            .configure(BVReviewHighlightsQueryTest.config)
            .handler { (response: BVReviewHighlightsQueryResponse<BVReviewHighlights>) in
                
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
                
                
                XCTAssertNotNil(reviewHighlights.negatives)
                XCTAssertNotNil(reviewHighlights.positives)
                
                if let negatives = reviewHighlights.negatives {
                    XCTAssertFalse(negatives.isEmpty)
                }
                
                if let positives = reviewHighlights.positives {
                    XCTAssertFalse(positives.isEmpty)
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
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
        
    }
    
}

