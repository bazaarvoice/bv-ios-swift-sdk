//
//
//  BVCommentsQueryTest.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSwift

class BVCommentsQueryTest: XCTestCase {
    
    private static var config: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .staging(clientId: "apitestcustomer"))
        
        return BVConversationsConfiguration.display(
            clientKey: "kuy3zj9pr3n7i0wxajrzj04xo",
            configType: .staging(clientId: "apitestcustomer"),
            analyticsConfig: analyticsConfig)
    }()
    
    private static var syndicationSourceConfig: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .staging(clientId: "testcust-contentoriginsynd"))
        
        return BVConversationsConfiguration.display(
            clientKey: "carz85SqKJp9FrZgeb2irdiEBT4b0DSe7m1KUm18elijE",
            configType: .staging(clientId: "testcust-contentoriginsynd"),
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
    
    func testCommentsQueryConstruction() {
        
        let commentsQuery:BVCommentsQuery =
            BVCommentsQuery(
                productId: "1000001",
                reviewId: "192548")
                .configure(BVCommentsQueryTest.config)
                .filter((.reviewId("testID1"), .equalTo),
                        (.reviewId("testID2"), .equalTo),
                        (.reviewId("testID3"), .equalTo),
                        (.reviewId("testID4"), .notEqualTo),
                        (.reviewId("testID5"), .notEqualTo),
                        (.userLocation("Chicago, IL"), .greaterThan),
                        (.categoryAncestorId("2"), .greaterThan),
                        (.moderatorCode("3"), .greaterThan))
        
        guard let url = commentsQuery.request?.url else {
            XCTFail()
            return
        }
        
        print(url.absoluteString)
        
        XCTAssertTrue(url.absoluteString.contains(
            "ReviewId:eq:testID1,testID2,testID3"))
        XCTAssertTrue(url.absoluteString.contains("ReviewId:neq:testID4,testID5"))
    }
    
    func testCommentsQuery() {
        
        let expectation =
            self.expectation(description: "testBVConversationComment")
        
        let commentQuery:BVCommentsQuery =
            BVCommentsQuery(
                productId: "1000001",
                reviewId: "192548",
                limit: 99,
                offset: 0)
                .configure(BVCommentsQueryTest.config)
                .handler { (response: BVConversationsQueryResponse<BVComment>) in
                    
                    if case .failure = response {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    guard case let .success(_, comments) = response else {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    XCTAssertEqual(comments.count, 5)
                    expectation.fulfill()
        }
        
        guard let req = commentQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        commentQuery.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    func testCommentsQuerySyndicationSource() {
        
        let expectation =
            self.expectation(description: "testCommentsQuerySyndicationSource")
        
        let commentQuery:BVCommentsQuery =
            BVCommentsQuery(
                productId: "Concierge-Common-Product-2",
                reviewId: "33950761",
                limit: 99,
                offset: 0)
                .configure(BVCommentsQueryTest.syndicationSourceConfig)
                .handler { (response: BVConversationsQueryResponse<BVComment>) in
                    
                    if case .failure = response {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    guard case let .success(_, comments) = response else {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    guard let comment: BVComment = comments.first(where: { $0.commentId == "4312642" }),
                        let syndicationSource: BVSyndicationSource =
                        comment.syndicationSource else {
                            XCTFail()
                            return
                    }
                    
                    //Source client
                    XCTAssertEqual(comment.sourceClient, "testcust-contentoriginsynd")
                    
                    //Syndicated Source
                    XCTAssertNotNil(comment.syndicationSource)
                    XCTAssertEqual(syndicationSource.logoImageUrl, "https://contentorigin-stg.bazaarvoice.com/testsynd1-origin/en_US/Fish03_small.jpg")
                    XCTAssertEqual(syndicationSource.name, "TestCustomer-Contentorigin_Synd1_en_US")
                    
                    expectation.fulfill()
        }
        
        guard let req = commentQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        commentQuery.async()
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
}
