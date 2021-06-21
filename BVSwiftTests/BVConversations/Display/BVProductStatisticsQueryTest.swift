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

    func testProductStatisticsQueryDisplayIncentivizedReview() {
      
      let expectation =
        self.expectation(
          description: "testProductStatisticsQueryDisplayIncentivizedReview")
      
      let usLocale: Locale = Locale(identifier: "en_US")
      
      guard let productStatisticsQuery =
        BVProductStatisticsQuery(productIds: ["data-gen-moppq9ekthfzbc6qff3bqokie"]) else {
          XCTFail()
          expectation.fulfill()
          return
      }
      
      productStatisticsQuery
        .filter((.contentLocale(usLocale), .equalTo))
        .stats(.nativeReviews)
        .stats(.reviews)
        .incentivizedStats(true)
        .configure(BVProductStatisticsQueryTest.incentivizedStatsConfig)
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
                firstProductStatistic.reviewStatistics, let nativeReviewStatistics =
                firstProductStatistic.nativeReviewStatistics else {
                    XCTFail()
                    expectation.fulfill()
                    return
            }
            
            XCTAssertEqual(productStatistics.count, 1)
            XCTAssertEqual(firstProductStatistic.productId, "data-gen-moppq9ekthfzbc6qff3bqokie")
            
            // For Review Statistics
            XCTAssertEqual(reviewStatistics.totalReviewCount, 75)
            XCTAssertEqual(reviewStatistics.incentivizedReviewCount, 15)
            XCTAssertNotNil(reviewStatistics.averageOverallRating)
            XCTAssertEqual(reviewStatistics.overallRatingRange, 5)
            
            //For Native Review Statistics
            XCTAssertEqual(nativeReviewStatistics.totalReviewCount, 75)
            XCTAssertEqual(nativeReviewStatistics.incentivizedReviewCount, 15)
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
  
  func testProductStatisticsQueryTooManyProductsTimeout() {
    
    let expectation =
      self.expectation(
        description: "testProductStatisticsQueryTooManyProductsTimeout")
    
    var tooManyProductIds: [String] = []
    
    for index in 1 ... 110 {
      tooManyProductIds += ["ProductId\(index)"]
    }
    
    guard let productStatisticsQuery =
      BVProductStatisticsQuery(productIds: ["product1"])?
        .configure(BVProductStatisticsQueryTest.config) else {
          XCTFail()
          return
    }
    
    let productIdFilterTuple = tooManyProductIds.map {
      return (BVConversationsQueryFilter.productId($0),
              BVConversationsFilterOperator.equalTo)
    }
    
    BVProductStatisticsQuery
      .groupFilters(productIdFilterTuple).forEach { group in
        let expr: BVQueryFilterExpression<BVConversationsQueryFilter,
          BVConversationsFilterOperator> =
          1 < group.count ? .or(group) : .and(group)
        productStatisticsQuery.flatten(expr).forEach
          { productStatisticsQuery.add($0) }
    }
    
    guard let url = productStatisticsQuery.request?.url else {
      XCTFail()
      return
    }
    
    expectation.fulfill()
    print(url)
    
    self.waitForExpectations(timeout: 5) { (error) in
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
      tooManyProductIds += ["ProductId\(index)"]
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
