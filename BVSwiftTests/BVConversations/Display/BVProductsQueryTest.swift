//
//
//  BVProductsQueryTest.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSwift

class BVProductsQueryTest: XCTestCase {
  
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
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
    
  func testProductsQueryMultipleStats() {
    let expectation = self.expectation(description: "testProductsQueryIncentivizedStats")
    
    let productQuery = BVProductsQuery(productIds: ["test1", "test2"])!
      .stats(.reviews)
      .stats(.questions)
      .filter(.reviews)
      .filter(.questions)
      .configure(BVProductsQueryTest.config)
      .handler { (response: BVConversationsQueryResponse<BVProduct>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, products) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        XCTAssertEqual(products.count, 2)
        
        for product in products {
          XCTAssertNotNil(product.productId)
          XCTAssertNotNil(product.reviewStatistics)
          XCTAssertNotNil(product.filteredReviewStatistics)
          XCTAssertNotNil(product.qaStatistics)
          XCTAssertNotNil(product.filteredQAStatistics)
        }
        
        expectation.fulfill()
    }
    
    guard let req = productQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    /// We're not testing analytics here
    productQuery.async(urlSession: BVProductsQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testProductsQueryIncentivizedStats() {
    let expectation = self.expectation(description: "testProductsQueryIncentivizedStats")
        
    let productQuery = BVProductsQuery(productIds: ["test1234567", "wsd013c"])!
      .stats(.reviews)
      .filter(.reviews)
      .incentivizedStats(true)
      .configure(BVProductsQueryTest.incentivizedStatsConfig)
      .handler { (response: BVConversationsQueryResponse<BVProduct>) in
        
        if case .failure(let error) = response {
          print(error)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, products) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        for product in products {
          XCTAssertNotNil(product.productId)
          XCTAssertNotNil(product.reviewStatistics)
          XCTAssertNotNil(product.reviewStatistics?.incentivizedReviewCount)
        }
        
        guard let product: BVProduct = products.first else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        XCTAssertEqual(product.productId, "wsd013c")
        
        // Review Statistics assertions
        XCTAssertNotNil(product.reviewStatistics)
        XCTAssertNotNil(product.reviewStatistics?.incentivizedReviewCount)
        XCTAssertEqual(product.reviewStatistics?.incentivizedReviewCount, 1)
        XCTAssertNotNil(product.reviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }))
        
        let incentivizedReview = product.reviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" })!
        XCTAssertEqual(incentivizedReview?.distibutionElementId, "IncentivizedReview")
        XCTAssertEqual(incentivizedReview?.label, "Received an incentive for this review")
        XCTAssertEqual(incentivizedReview?.values?.count, 1)
        
        // Filtered Review Statistics assertions
        XCTAssertNotNil(product.filteredReviewStatistics)
        XCTAssertNotNil(product.filteredReviewStatistics?.incentivizedReviewCount)
        XCTAssertEqual(product.filteredReviewStatistics?.incentivizedReviewCount, 1)
        XCTAssertNotNil(product.filteredReviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }))
        
        let filtereedIncentivizedReview = product.filteredReviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" })!
        XCTAssertEqual(filtereedIncentivizedReview?.distibutionElementId, "IncentivizedReview")
        XCTAssertEqual(filtereedIncentivizedReview?.label, "Received an incentive for this review")
        XCTAssertEqual(filtereedIncentivizedReview?.values?.count, 1)
        
        expectation.fulfill()
    }
    
    guard let req = productQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    /// We're not testing analytics here
    productQuery.async(urlSession: BVProductsQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
    
  }
}
