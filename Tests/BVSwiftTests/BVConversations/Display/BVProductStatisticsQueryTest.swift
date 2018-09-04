//
//
//  BVProductStatisticsQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVProductStatisticsQueryTest: XCTestCase {
  
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
  
  override class func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override class func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  func testProductStatisticsQueryConstruction() {
    
    let enLocale = Locale(identifier: "en_US")
    let ukLocale = Locale(identifier: "en_GB")
    
    let productIds =
      ["testID1",
       "testID2",
       "testID3"]
    
    guard let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: productIds)?
        .configure(BVProductStatisticsQueryTest.config)
        .filter((.contentLocale(enLocale), .notEqualTo),
                (.contentLocale(ukLocale), .notEqualTo)) else {
                  XCTFail()
                  return
    }
    
    guard let url = productStatisticsQuery.request?.url else {
      XCTFail()
      return
    }
    
    print(url.absoluteString)
    
    XCTAssertTrue(url.absoluteString.contains(
      "ProductId:eq:testID1,testID2,testID3"))
    XCTAssertTrue(url.absoluteString.contains(
      "ContentLocale:neq:en_GB,en_US"))
  }
  
  func testProductStatisticsQueryDisplayOneProduct() {
    
    let expectation =
      self.expectation(
        description: "testProductStatisticsQueryDisplayOneProduct")
    
    let usLocale: Locale = Locale(identifier: "en_US")
    
    guard let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: ["test3"]) else {
        XCTFail()
        expectation.fulfill()
        return
    }
    
    productStatisticsQuery
      .filter((.contentLocale(usLocale), .equalTo))
      .stats(.nativeReviews)
      .stats(.reviews)
      .configure(BVProductStatisticsQueryTest.config)
      .handler {
        (response: BVConversationsQueryResponse<BVProductStatistics>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, productStatistics) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard let firstProductStatistic: BVProductStatistics =
          productStatistics.first,
          let reviewStatistics =
          firstProductStatistic.reviewStatistics,
          let nativeReviewStatistics =
          firstProductStatistic.nativeReviewStatistics else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        XCTAssertEqual(productStatistics.count, 1)
        
        XCTAssertEqual(firstProductStatistic.productId, "test3")
        XCTAssertEqual(reviewStatistics.totalReviewCount, 29)
        XCTAssertNotNil(reviewStatistics.averageOverallRating)
        XCTAssertEqual(reviewStatistics.overallRatingRange, 5)
        XCTAssertEqual(nativeReviewStatistics.totalReviewCount, 29)
        XCTAssertEqual(nativeReviewStatistics.overallRatingRange, 5)
        
        expectation.fulfill()
    }
    
    guard let req = productStatisticsQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    productStatisticsQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  
  
  
  func testProductStatisticsQueryDisplayMultipleProducts() {
    
    let expectation =
      self.expectation(
        description: "testProductStatisticsQueryDisplayMultipleProducts")
    
    let usLocale: Locale = Locale(identifier: "en_US")
    
    guard let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: ["test1", "test2", "test3"]) else {
        XCTFail()
        expectation.fulfill()
        return
    }
    
    productStatisticsQuery
      .stats(.nativeReviews)
      .stats(.reviews)
      .filter((.contentLocale(usLocale), .equalTo))
      .configure(BVProductStatisticsQueryTest.config)
      .handler {
        (response: BVConversationsQueryResponse<BVProductStatistics>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, productStatistics) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        XCTAssertEqual(productStatistics.count, 3)
        expectation.fulfill()
    }
    
    guard let req = productStatisticsQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    productStatisticsQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testProductStatisticsQueryTooManyProductsError() {
    
    let expectation =
      self.expectation(
        description: "testProductStatisticsQueryTooManyProductsError")
    
    var tooManyProductIds: [String] = []
    
    for index in 1 ... 110 {
      tooManyProductIds += [String(index)]
    }
    
    guard let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: tooManyProductIds) else {
        XCTFail()
        expectation.fulfill()
        return
    }
    
    productStatisticsQuery
      .stats(.nativeReviews)
      .stats(.reviews)
      .configure(BVProductStatisticsQueryTest.config)
      .handler {
        (response: BVConversationsQueryResponse<BVProductStatistics>) in
        
        if case .failure(let error) = response {
          print(error)
          expectation.fulfill()
          return
        }
        
        if case let .success(_, productStatistics) = response,
          0 == productStatistics.count {
          expectation.fulfill()
          return
        }
        
        XCTFail()
        expectation.fulfill()
    }
    
    guard let req = productStatisticsQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    productStatisticsQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}
