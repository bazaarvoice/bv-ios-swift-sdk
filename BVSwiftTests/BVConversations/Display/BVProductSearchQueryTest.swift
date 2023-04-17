//
//  BVProductSearchQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

import Foundation

import XCTest
@testable import BVSwift

class BVProductSearchQueryTest: XCTestCase {
  
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
  
  func testProductSearchQueryConstruction() {
    
    let productSearchQuery =
      BVProductSearchQuery(searchQuery: "pinpoint oxford")
        .configure(BVProductSearchQueryTest.config)
        .filter((.categoryAncestorId("testID1"), .equalTo),
                (.categoryAncestorId("testID2"), .equalTo),
                (.categoryAncestorId("testID3"), .equalTo),
                (.categoryAncestorId("testID4"), .notEqualTo),
                (.categoryAncestorId("testID5"), .notEqualTo))
    
    guard let url = productSearchQuery.request?.url else {
      XCTFail()
      return
    }
    
    print(url.absoluteString)
    
    XCTAssertTrue(url.absoluteString.contains(
      "CategoryAncestorId:eq:testID1,testID2,testID3"))
    XCTAssertTrue(url.absoluteString.contains(
      "CategoryAncestorId:neq:testID4,testID5"))
  }
  
  func testProductSearchQueryDisplay() {
    
    let expectation =
      self.expectation(description: "testProductSearchQueryDisplay")
    
    let productSearchQuery =
      BVProductSearchQuery(searchQuery: "pinpoint oxford")
        .include(.reviews, limit: 10)
        .include(.questions, limit: 5)
        .stats(.reviews)
        .configure(BVProductSearchQueryTest.config)
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
          
          guard let product: BVProduct = products.first,
            let brand: BVBrand = product.brand else {
              XCTFail()
              expectation.fulfill()
              return
          }
          
          guard let reviews: [BVReview] = product.reviews,
            let questions: [BVQuestion] = product.questions else {
              XCTFail()
              expectation.fulfill()
              return
          }
          
          XCTAssertEqual(brand.brandId, "cskg0snv1x3chrqlde0zklodb")
          XCTAssertEqual(brand.name, "mysh")
          XCTAssertEqual(
            product.productDescription,
            "Our pinpoint oxford is crafted from only the finest 1980s " +
              "two-ply cotton fibers. Single-needle stitching on all seams " +
              "for a smooth flat appearance. Tailored with our traditional " +
            "straight collar and button cuffs. Machine wash. Imported.")
          XCTAssertEqual(product.brandExternalId, "cskg0snv1x3chrqlde0zklodb")
          XCTAssertEqual(
            product.imageUrl?.value?.absoluteString,
            "http://myshco.com/productImages/shirt.jpg")
          XCTAssertEqual(product.name, "Dress Shirt")
          XCTAssertEqual(product.categoryId, "1031")
          XCTAssertEqual(product.productId, "3000001")
          XCTAssertEqual(reviews.count, 6)
          XCTAssertEqual(questions.count, 0)
          
          expectation.fulfill()
    }
    
    guard let req = productSearchQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    /// We're not testing analytics here
    productSearchQuery
      .async(urlSession: BVProductSearchQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testProductSearchQueryDisplayWithFilter() {
    
    let expectation =
      self.expectation(description: "testProductSearchQueryDisplayWithFilter")
    
    let productSearchQuery =
      BVProductSearchQuery(searchQuery: "pinpoint oxford")
        .include(.reviews, limit: 10)
        .include(.questions, limit: 5)
        // only include reviews where isRatingsOnly is false
        .filter((.reviews(.isRatingsOnly(false)), .equalTo))
        // only include questions where isFeatured is not equal to true
        .filter((.questions(.isFeatured(true)), .notEqualTo))
        .stats(.reviews)
        .filter(.reviews)
        .configure(BVProductSearchQueryTest.config)
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
          
          guard let product: BVProduct = products.first else {
            XCTFail()
            expectation.fulfill()
            return
          }
          
          XCTAssertNotNil(product.reviewStatistics)
          XCTAssertNotNil(product.filteredReviewStatistics)
          
          guard let reviews: [BVReview] = product.reviews,
            let questions: [BVQuestion] = product.questions else {
              XCTFail()
              expectation.fulfill()
              return
          }
          
          XCTAssertEqual(reviews.count, 6)
          XCTAssertEqual(questions.count, 0)
          
          // Iterate all the included reviews and verify that all the reviews
          // have isRatingsOnly = false
          for review in reviews {
            XCTAssertFalse(review.isRatingsOnly!)
          }
          
          // Iterate all the included questions and verify that all the
          // questions have isFeatured = false
          for question in questions {
            XCTAssertFalse(question.isFeatured!)
          }
          
          expectation.fulfill()
    }
    
    guard let req = productSearchQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    productSearchQuery
      .async(urlSession: BVProductSearchQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testProductSearchQueryIncentivizedStats() {
    let expectation = self.expectation(description: "testProductSearchQueryIncentivizedStats")
    
    let productQuery = BVProductSearchQuery(searchQuery: "large dryer")
      .stats(.reviews)
      .filter(.reviews)
      .incentivizedStats(true)
      .configure(BVProductSearchQueryTest.incentivizedStatsConfig)
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
        
        XCTAssertNotNil(products)
        XCTAssertEqual(products.count, 9)
        
        // incentivized stats assertions
        for product in products {
          XCTAssertNotNil(product.reviewStatistics?.incentivizedReviewCount)
        }
        
        let product = products.first!
        
        XCTAssertNotNil(product.productId)
        
        // Review Statistics assertions
        XCTAssertNotNil(product.reviewStatistics)
        XCTAssertEqual(product.reviewStatistics?.incentivizedReviewCount, 0)
        XCTAssertNotNil(product.reviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }))
        
          if let incentivizedReview = product.reviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }) {
              XCTAssertEqual(incentivizedReview.distibutionElementId, "IncentivizedReview")
              XCTAssertEqual(incentivizedReview.label, "Received an incentive for this review")
              XCTAssertEqual(incentivizedReview.values?.count, 1)
          }
        // Filtered Review Statistics assertions
        XCTAssertNotNil(product.filteredReviewStatistics)
        XCTAssertNotNil(product.filteredReviewStatistics?.incentivizedReviewCount)
        XCTAssertEqual(product.filteredReviewStatistics?.incentivizedReviewCount, 0)
        XCTAssertNotNil(product.filteredReviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }))
        
          if let filtereedIncentivizedReview = product.filteredReviewStatistics?.contextDataDistribution?.first(where: { $0.distibutionElementId == "IncentivizedReview" }){
              XCTAssertEqual(filtereedIncentivizedReview.distibutionElementId, "IncentivizedReview")
              XCTAssertEqual(filtereedIncentivizedReview.label, "Received an incentive for this review")
              XCTAssertEqual(filtereedIncentivizedReview.values?.count, 1)
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
    productQuery.async(urlSession: BVProductSearchQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
    
  }
}
