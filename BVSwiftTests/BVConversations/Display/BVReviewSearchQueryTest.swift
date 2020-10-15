//
//  BVReviewSearchQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

import XCTest
@testable import BVSwift

class BVReviewSearchQueryTest: XCTestCase {
    
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
    
    private static var incentivizedStatsConfig: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .staging(clientId: "apitestcustomer"))
        
        return BVConversationsConfiguration.display(
            clientKey: "caB45h2jBqXFw1OE043qoMBD1gJC8EwFNCjktzgwncXY4",
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
    
    private static var privateSession:URLSession = {
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
    
    func testReviewSearchQueryConstruction() {
        
        let reviewSearchQuery = BVReviewSearchQuery(
            productId: "test1", searchQuery: "volutpat")
            .configure(BVReviewSearchQueryTest.config)
            .filter((.categoryAncestorId("testID1"), .equalTo),
                    (.categoryAncestorId("testID2"), .equalTo),
                    (.categoryAncestorId("testID3"), .equalTo),
                    (.categoryAncestorId("testID4"), .notEqualTo),
                    (.categoryAncestorId("testID5"), .notEqualTo))
        
        guard let url = reviewSearchQuery.request?.url else {
            XCTFail()
            return
        }
        
        print(url.absoluteString)
        
        XCTAssertTrue(url.absoluteString.contains(
            "CategoryAncestorId:eq:testID1,testID2,testID3"))
        XCTAssertTrue(url.absoluteString.contains(
            "CategoryAncestorId:neq:testID4,testID5"))
    }
    
    func testReviewSearchQueryDisplay() {
        
        let expectation =
            self.expectation(description: "testReviewSearchQueryDisplay")
        
        let reviewSearchQuery =
            BVReviewSearchQuery(
                productId: "test1", searchQuery: "volutpat")
                .filter((.hasPhotos(true), .equalTo))
                .filter((.hasComments(false), .equalTo))
                .configure(BVReviewSearchQueryTest.config)
                .handler { (response: BVConversationsQueryResponse<BVReview>) in
                    
                    if case .failure(let error) = response {
                        print(error)
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    guard case let .success(_, reviews) = response else {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    guard let review: BVReview = reviews.first,
                        let photos: [BVPhoto] = review.photos,
                        let firstPhoto: BVPhoto = photos.first else {
                            XCTFail()
                            expectation.fulfill()
                            return
                    }
                    
                    XCTAssertGreaterThanOrEqual(reviews.count, 10)
                    XCTAssertEqual(review.rating, 5)
                    XCTAssertEqual(
                        review.title, "Caum sociis natoque penatibus et magnis dis pa")
                    XCTAssertEqual(
                        review.reviewText,
                        "In volutpat pretium leo, a ornare purus ultricieset. " +
                            "Phasellus quis ultricieslacus. " +
                            "Fusce tristique feugiat elit velviverra. " +
                            "Ut quam sapien, tempor at elementum a, ornare egetmi.\n\n" +
                            "Vivamus orci nibh, vulputate et malesuada eu, commodo nonest. " +
                            "Morbi semper facilisistincidunt. " +
                            "Caum sociis natoque penatibus et magnis dis parturient montes, " +
                            "nascetur ridiculusmus. " +
                            "Nunc iaculis porta dolor, et aliquam urna hendreritvel.\n\n" +
                            "Duis ut nibh ut mi tincidunt ornare nec necneque. " +
                            "Etiam ac volutpatmi. Praesent a scelerisquearcu. " +
                            "Sed fringilla malesuadarutrum.\n\n" +
                            "In accumsan temporscelerisque. Sed ac interdumlectus. " +
                            "Mauris mollis turpis sit amet neque porttitor ac " +
                            "venenatis mimollis. Pellentesque eget odioorci. " +
                            "Praesent sit amet turpis ullamcorper risus laciniaaliquet.\n\n" +
                            "Nam ut feliselit. Etiam feugiat sempervestibulum. " +
                        "Aliquam eratvolutpat.")
                    XCTAssertEqual(review.moderationStatus, "APPROVED")
                    XCTAssertEqual(review.reviewId, "192444")
                    XCTAssertEqual(review.productId, "test1")
                    XCTAssertEqual(review.isRatingsOnly, false)
                    XCTAssertEqual(review.isFeatured, false)
                    XCTAssertEqual(review.authorId, "7i7sa0ys2yo")
                    XCTAssertEqual(review.userNickname, "psg1r5xeUyzIZ3bVQt")
                    XCTAssertEqual(review.userLocation, "M")
                    
                    XCTAssertEqual(photos.count, 6)
                    XCTAssertNil(firstPhoto.caption)
                    XCTAssertEqual(firstPhoto.photoId, "79913")
                    XCTAssertNotNil(firstPhoto.photoSizes)
                    
                    let regexPhotoList =
                        firstPhoto.photoSizes?.filter { (size: BVPhotoSize) -> Bool in
                            guard let url = size.url?.value else {
                                return false
                            }
                            return (url
                                .absoluteString
                                .lowercased()
                                .contains("jpg?client=apireadonlysandbox"))
                    }
                    
                    XCTAssertNotNil(regexPhotoList)
                    
                    reviews.forEach { (rev) in
                        XCTAssertEqual(rev.productId, "test1")
                    }
                    
                    expectation.fulfill()
        }
        
        guard let req = reviewSearchQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        reviewSearchQuery.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testReviewSearchQueryIncludeComments() {
        
        let expectation =
            self.expectation(description: "testReviewSearchQueryIncludeComments")
        
        let reviewSearchQuery =
            BVReviewSearchQuery(
                productId: "test1", searchQuery: "asndflkjaskdlfas")
                .configure(BVReviewSearchQueryTest.config)
                .include(.comments)
                .handler { (response: BVConversationsQueryResponse<BVReview>) in
                    
                    if case .failure(let error) = response {
                        print(error)
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    guard case let .success(_, reviews) = response else {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    guard let review: BVReview = reviews.first,
                        let comments: [BVComment] = review.comments,
                        let comment: BVComment = comments.first else {
                            XCTFail()
                            expectation.fulfill()
                            return
                    }
                    
                    XCTAssertEqual(reviews.count, 1)
                    XCTAssertEqual(comments.count, 1)
                    
                    XCTAssertEqual(comment.authorId, "he5onxrlou8")
                    XCTAssertEqual(
                        comment.submissionTime, "2011-04-15T21:13:28.000+00:00".toBVDate())
                    XCTAssertEqual(
                        comment.commentText,
                        "Vestibulum luctus facilisis massa vestibulumscelerisque." +
                            "\n\nDuis fermentum purus id leo consequat eget accumsan " +
                            "maurishendrerit. Mauris ut lacus non arcu faucibus " +
                        "scelerisque volutpat rhoncusdiam. Maecenas non sodalesdui.")
                    XCTAssertEqual(comment.contentLocale, "en_US")
                    XCTAssertEqual(
                        comment.lastModeratedTime,
                        "2011-06-30T21:15:59.000+00:00".toBVDate())
                    XCTAssertEqual(
                        comment.lastModificationTime,
                        "2011-06-30T21:15:59.000+00:00".toBVDate())
                    
                    expectation.fulfill()
        }
        
        guard let req = reviewSearchQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        reviewSearchQuery.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testReviewQuerySyndicationSource() {
        
        let expectation =
            self.expectation(description: "testReviewQuerySyndicationSource")
        
        let commentQuery:BVReviewSearchQuery =
            BVReviewSearchQuery(productId: "Concierge-Common-Product-1", searchQuery: "convenient point")
                .include(.authors)
                .include(.products)
                .filter(.reviews)
                .configure(BVReviewSearchQueryTest.syndicationSourceConfig)
                .handler { (response: BVConversationsQueryResponse<BVReview>) in
                    
                    if case .failure = response {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    guard case let .success(_, reviews) = response else {
                        XCTFail()
                        expectation.fulfill()
                        return
                    }
                    
                    guard let review: BVReview = reviews.first(where: {$0.reviewId == "33950761"}),
                        let syndicationSource: BVSyndicationSource =
                        review.syndicationSource else {
                            XCTFail()
                            return
                    }
                    
                    //Source Client
                    XCTAssertEqual(review.sourceClient, "testcust-contentoriginsynd")
                    
                    //Syndicated Source
                    XCTAssertTrue(review.isSyndicated!)
                    XCTAssertNotNil(review.syndicationSource)
                    XCTAssertEqual(syndicationSource.name, "TestCustomer-Contentorigin_Synd1_en_US")
                    XCTAssertEqual(review.syndicationSource?.logoImageUrl, "https://contentorigin-stg.bazaarvoice.com/testsynd1-origin/en_US/Fish03_small.jpg")
                    
                    expectation.fulfill()
        }
        
        guard let req = commentQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        commentQuery.async()
        
        self.waitForExpectations(timeout: 2000) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testReviewSearchQueryIncentivizedStats() {
        
        let expectation = self.expectation(description: "testReviewQueryIncentivizedStats")
        
        let reviewQuery = BVReviewSearchQuery(
            productId: "data-gen-moppq9ekthfzbc6qff3bqokie", searchQuery: "king woman vietnsmeese")
            .include(.authors)
            .include(.products)
            .stats(.reviews)
            .filter(.reviews)
            .incentivizedStats(true)
            .configure(BVReviewSearchQueryTest.incentivizedStatsConfig)
            .handler { (response: BVConversationsQueryResponse<BVReview>) in
                
                if case .failure(let error) = response {
                    print(error)
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                guard case let .success(_, reviews) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                XCTAssertEqual(reviews.count, 1)
                
                let review: BVReview = reviews.first!
                
                // assertions for badges
                XCTAssertTrue(review.badges!.contains(where: { $0.badgeId == "incentivizedReview" }))
                if let incentivizedBadge = review.badges?.first(where: { $0.badgeId == "incentivizedReview"}) {
                    XCTAssertEqual(incentivizedBadge.badgeType, .custom)
                    XCTAssertEqual(incentivizedBadge.contentType, "REVIEW")
                }
                
                // assertions for context data values of incentivized review
                XCTAssertTrue(review.contextDataValues!.contains(where: {$0.contextDataValueId == "IncentivizedReview"}))
                if let incentivizedContextDataValue = review.contextDataValues!.first(where: {$0.contextDataValueId == "IncentivizedReview"}) {
                    XCTAssertNotNil(incentivizedContextDataValue.dimensionLabel) // dimensionLabel Value could be anything so actual value check is not added
                    XCTAssertEqual(incentivizedContextDataValue.value, "True")
                    XCTAssertEqual(incentivizedContextDataValue.valueLabel, "Yes")
                }
                
                // assertions for product review statistics
                XCTAssertNotNil(review.products)
                XCTAssertEqual(review.products?.count, 1)
                XCTAssertEqual(review.productId, "data-gen-moppq9ekthfzbc6qff3bqokie")
                
                XCTAssertNotNil(review.products?.first?.reviewStatistics)
                XCTAssertNotNil(review.products?.first?.reviewStatistics?.incentivizedReviewCount)
                XCTAssertEqual(review.products?.first?.reviewStatistics?.incentivizedReviewCount, 15)
                XCTAssertNotNil(review.products?.first?.reviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }))
                
                let incentivizedReview = review.products?.first?.reviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" })!
                XCTAssertEqual(incentivizedReview?.distibutionElementId, "IncentivizedReview")
                XCTAssertEqual(incentivizedReview?.label, "Received an incentive for this review")
                XCTAssertEqual(incentivizedReview?.values?.count, 1)
                
                // assertions for product filtered review statistics
                XCTAssertNotNil(review.products?.first?.filteredReviewStatistics)
                XCTAssertNotNil(review.products?.first?.filteredReviewStatistics?.incentivizedReviewCount)
                XCTAssertEqual(review.products?.first?.filteredReviewStatistics?.incentivizedReviewCount, 1)
                XCTAssertNotNil(review.products?.first?.filteredReviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }))
                
                let filteredIncentivizedReview = review.products?.first?.filteredReviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" })!
                XCTAssertEqual(filteredIncentivizedReview?.distibutionElementId, "IncentivizedReview")
                XCTAssertEqual(filteredIncentivizedReview?.label, "Received an incentive for this review")
                XCTAssertEqual(filteredIncentivizedReview?.values?.count, 1)
                
                // assertions for author include(Review Stats & Filtered Review Stats are mapped to the same object for BVAuthor)
                XCTAssertNotNil(review.authors)
                XCTAssertEqual(review.authors?.count, 1)
                XCTAssertEqual(review.authorId, review.authors?.first?.authorId)
                XCTAssertNotNil(review.authors?.first?.reviewStatistics?.incentivizedReviewCount)
                
                expectation.fulfill()
        }
        
        guard let req = reviewQuery.request else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        print(req)
        
        reviewQuery.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
}
