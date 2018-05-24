//
//  BVReviewSearchQueryTest.swift
//  BVSwiftTests
//
//  Created by Michael Van Milligan on 5/24/18.
//  Copyright © 2018 Michael Van Milligan. All rights reserved.
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
  
  private static var privateSession:URLSession = {
    return URLSession(configuration: .default)
  }()
  
  override func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  func testReviewSearchQueryDisplay() {
    
    let expectation =
      self.expectation(description: "testReviewSearchQueryDisplay")
    
    let reviewSearchQuery =
      BVReviewSearchQuery(
        productId: "test1", searchQuery: "volutpat")
        .filter(.hasPhotos, op: .equalTo, value: "true")
        .filter(.hasComments, op: .equalTo, value: "false")
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
              return
          }
          
          XCTAssertEqual(reviews.count, 10)
          XCTAssertEqual(review.rating, 5)
          XCTAssertEqual(
            review.title,
            "Nulla risus nibh; tincidunt at volutpat eget, commodo sit " +
              "amet est. In hac habitasse platea dictumst. Donec a ante " +
            "porttitor risus luctus turpis duis.")
          XCTAssertEqual(
            review.reviewText,
            "Quisque quis ipsum quis diam pretium tempor quis in leo. " +
              "Pellentesque non ipsum in nibh feugiat bibendum. Duis sit " +
              "amet nibh justo. Pellentesque ultrices lacus bibendum mi " +
              "cursus vehicula. Donec eu quam vitae velit adipiscing " +
            "tincidunt eleifend amet.")
          XCTAssertEqual(review.moderationStatus, "APPROVED")
          XCTAssertEqual(review.reviewId, "192435")
          XCTAssertEqual(review.productId, "test1")
          XCTAssertEqual(review.isRatingsOnly, false)
          XCTAssertEqual(review.isFeatured, false)
          XCTAssertEqual(review.authorId, "dzmt783zu8o")
          XCTAssertEqual(review.userNickname, "jljkljk")
          XCTAssertNil(review.userLocation)
          
          XCTAssertEqual(photos.count, 1)
          XCTAssertNil(firstPhoto.caption)
          XCTAssertEqual(firstPhoto.photoId, "79886")
          XCTAssertNotNil(firstPhoto.photoSizes)
          
          let regexPhotoList =
            firstPhoto.photoSizes?.filter { (size: BVPhotoSize) -> Bool in
              guard let url = size.url else {
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
}
