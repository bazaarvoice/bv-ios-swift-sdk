//
//
//  BVProductQueryTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVProductQueryTest: XCTestCase {
  
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
  
  func testProductQueryDisplay() {
    
    let expectation =
      self.expectation(description: "testProductQueryDisplay")
    
    let productQuery = BVProductQuery(productId: "test1")
      .include(.reviews, limit: 10)
      .include(.questions, limit: 5)
      .stats(.reviews)
      .configure(BVProductQueryTest.config)
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
          "Our pinpoint oxford is crafted from only the finest 80\'s " +
            "two-ply cotton fibers.Single-needle stitching on all seams for " +
            "a smooth flat appearance. Tailored with our Traditional\n" +
            "                straight collar and button cuffs. " +
          "Machine wash. Imported.")
        XCTAssertEqual(product.brandExternalId, "cskg0snv1x3chrqlde0zklodb")
        XCTAssertEqual(
          product.imageUrl?.value?.absoluteString,
          "http://myshco.com/productImages/shirt.jpg")
        XCTAssertEqual(product.name, "Dress Shirt")
        XCTAssertEqual(product.categoryId, "testCategory1031")
        XCTAssertEqual(product.productId, "test1")
        XCTAssertEqual(reviews.count, 10)
        XCTAssertEqual(questions.count, 5)
        
        expectation.fulfill()
    }
    
    guard let req = productQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    /// We're not testing analytics here
    productQuery.async(urlSession: BVProductQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testProductQueryDisplayWithFilter() {
    
    let expectation =
      self.expectation(description: "testProductDisplayWithFilter")
    
    let productQuery = BVProductQuery(productId: "test1")
      .include(.reviews, limit: 10)
      .include(.questions, limit: 5)
      // only include reviews where isRatingsOnly is false
      .filter(.reviews(.isRatingsOnly(false)))
      // only include questions where isFeatured is not equal to true
      .filter(.questions(.isFeatured(true)), op: .notEqualTo)
      .stats(.reviews)
      .configure(BVProductQueryTest.config)
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
        
        guard let reviews: [BVReview] = product.reviews,
          let questions: [BVQuestion] = product.questions else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        XCTAssertEqual(reviews.count, 10)
        XCTAssertEqual(questions.count, 5)
        
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
    
    guard let req = productQuery.request else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    print(req)
    
    productQuery.async(urlSession: BVProductQueryTest.privateSession)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}
