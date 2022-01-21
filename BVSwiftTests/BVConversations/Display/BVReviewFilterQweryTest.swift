//
//
//  BVReviewFilterQweryTest.swift
//  BVSwift
//
//  Copyright © 2021 Bazaarvoice. All rights reserved.
// 

import Foundation
import XCTest
@testable import BVSwift

class BVReviewFilterQweryTest: XCTestCase {
  
  private static var config: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
      
      let analyticsConfig: BVAnalyticsConfiguration =
        .dryRun(
          configType: .staging(clientId: "apitestcustomer"))
      
      return BVConversationsConfiguration.display(
        clientKey: "ts3u31l77ywbxbl1urw2p9ufm",
        configType: .staging(clientId: "apitestcustomer"),
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
  
  
  func testReviewFilterConstructor(){
    
    let filterReview = BVTopicFilterQuery(productId: "test1")
      .language("fr")
      .configure(BVReviewFilterQweryTest.config)
    
    guard let url = filterReview.request?.url else {
      XCTFail()
      return
    }
    
    print(url.absoluteString)
    XCTAssertTrue(url.absoluteString.contains("productId=test1"))
    XCTAssertTrue(url.absoluteString.contains("language=fr"))
  }
  
  func testReviewFilterSuccess() {
    
    let expectation = self.expectation(description: "testReviewFilter")
    
    let filterReview = BVTopicFilterQuery(productId: "XYZ123-prod-3-4-ExternalId")
      .configure(BVReviewFilterQweryTest.config)
      .handler { (response: BVConversationsQueryResponse<BVFilterReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
      
      guard case let .success(_, filterReviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        XCTAssertNotNil(filterReviews)
        XCTAssertNotNil(filterReviews.first?.topicFilter)
        XCTAssertNotNil(filterReviews.first?.productId)
        XCTAssertEqual(filterReviews.first?.productId,"XYZ123-prod-3-4-ExternalId")
        XCTAssertNotNil(filterReviews.first?.language)
        XCTAssertEqual(filterReviews.first?.language, "en")
        let features = filterReviews.first?.topicFilter
        XCTAssertNotNil(features?.first?.feature)
        XCTAssertEqual(features?.first?.feature,"speed")
        XCTAssertNotNil(features?.first?.localized_feature)
        XCTAssertEqual(features?.first?.localized_feature,"speed")
       
        expectation.fulfill()
      }
    
    guard let req = filterReview.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    filterReview.async()
    
    self.waitForExpectations(timeout: 50) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testReviewFilterError() {
    
    let expectation = self.expectation(description: "testReviewFilter")
    
    let filterReview = BVTopicFilterQuery(productId: "XYZ123-prod-3-4-ExternalId")
      .language("test")
      .configure(BVReviewFilterQweryTest.config)
      .handler { (response: BVConversationsQueryResponse<BVFilterReview>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTAssertNotNil(error)
          expectation.fulfill()
          return
        }
      
      guard case let .success(_, filterReviews) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        XCTAssertNil(filterReviews)
        expectation.fulfill()
      }
    
    guard let req = filterReview.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    filterReview.async()
    
    self.waitForExpectations(timeout: 50) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}
