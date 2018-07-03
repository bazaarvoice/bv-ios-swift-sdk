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
  
  override func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
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
