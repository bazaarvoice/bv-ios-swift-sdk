//
//  BVCommentQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSwift

class BVCommentQueryTest: XCTestCase {
    
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
            clientKey: "ca79jZohgqUDHy625ASm2su46Iu092ZhKuhKibga3Z6zo",
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
    
    func testCommentQueryConstruction() {
        
        let commentQuery:BVCommentQuery =
            BVCommentQuery(
                productId: "1000001",
                commentId: "192548")
                .configure(BVCommentQueryTest.config)
                .filter((.reviewId("testID1"), .equalTo),
                        (.reviewId("testID2"), .equalTo),
                        (.reviewId("testID3"), .equalTo),
                        (.reviewId("testID4"), .notEqualTo),
                        (.reviewId("testID5"), .notEqualTo),
                        (.userLocation("Chicago, IL"), .greaterThan),
                        (.categoryAncestorId("2"), .greaterThan),
                        (.moderatorCode("3"), .greaterThan))
        
        guard let url = commentQuery.request?.url else {
            XCTFail()
            return
        }
        
        print(url.absoluteString)
        
        XCTAssertTrue(url.absoluteString.contains(
            "ReviewId:eq:testID1,testID2,testID3"))
        XCTAssertTrue(url.absoluteString.contains("ReviewId:neq:testID4,testID5"))
    }
    
    func testCommentQuery() {
        
        let expectation =
            self.expectation(description: "testBVConversationComment")
        
        let commentQuery:BVCommentsQuery =
            BVCommentsQuery(
                productId: "1000001",
                reviewId: "192548",
                limit: 99,
                offset: 0)
                .configure(BVCommentQueryTest.config)
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
    
    func testCommentQuerySyndicationSource() {
        
        let expectation =
            self.expectation(description: "testCommentQuerySyndicationSource")
        
        let commentQuery:BVCommentQuery =
            BVCommentQuery(
                productId: "Concierge-Common-Product-2",
                commentId: "4312642")
                .include(.authors)
                .include(.products)
                .include(.reviews)
                .configure(BVCommentQueryTest.syndicationSourceConfig)
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
                    
                    guard let comment: BVComment = comments.first,
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
    
    func testCommentQueryIncludes() {
        
        let expectation =
            self.expectation(description: "testBVConversationCommentIncludes")
        
        let commentQuery:BVCommentQuery =
            BVCommentQuery(
                productId: "1000001",
                commentId: "12024")
                .include(.authors)
                .include(.products)
                .include(.reviews)
                .configure(BVCommentQueryTest.config)
                .handler { (response: BVConversationsQueryResponse<BVComment>) in
                    
                    if case .failure = response {
                        XCTFail()
                        expectation.fulfill()
                    }
                    
                    guard case let .success(_, comments) = response else {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    XCTAssertEqual(comments.count, 1)
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
