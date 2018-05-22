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
  
  override func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  func testProductStatisticsQueryDisplayOneProduct() {
    
    let expectation =
      self.expectation(
        description: "testProductStatisticsQueryDisplayOneProduct")
    
    let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: ["test3"])
        .filter(.contentLocale, op: .equalTo, value: "en_US")
        .stats(.nativeReviews)
        .stats(.reviews)
        .configure(BVProductStatisticsQueryTest.config)
        .handler {
          (response: BVConversationsQueryResponse<BVProductStatistics>) in
          
          if case .failure(let error) = response {
            print(error)
            XCTFail()
            return
          }
          
          guard case let .success(_, productStatistics) = response else {
            XCTFail()
            return
          }
          
          guard let firstProductStatistic: BVProductStatistics =
            productStatistics.first,
            let reviewStatistics =
            firstProductStatistic.reviewStatistics,
            let nativeReviewStatistics =
            firstProductStatistic.nativeReviewStatistics else {
              XCTFail()
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
    
    let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: ["test1", "test2", "test3"])
        .stats(.nativeReviews)
        .stats(.reviews)
        .filter(.contentLocale, op: .equalTo, value: "en_US")
        .configure(BVProductStatisticsQueryTest.config)
        .handler {
          (response: BVConversationsQueryResponse<BVProductStatistics>) in
          
          if case .failure(let error) = response {
            print(error)
            XCTFail()
            return
          }
          
          guard case let .success(_, productStatistics) = response else {
            XCTFail()
            return
          }
          
          XCTAssertEqual(productStatistics.count, 3)
          expectation.fulfill()
    }
    
    guard let req = productStatisticsQuery.request else {
      XCTFail()
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
    
    for i in 1 ... 110 {
      tooManyProductIds += [String(i)]
    }
    
    let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: tooManyProductIds)
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
    }
    
    guard let req = productStatisticsQuery.request else {
      XCTFail()
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
