//
//  BVProductSearchQueryTest.swift
//  BVSwiftTests
//
//  Created by Michael Van Milligan on 5/24/18.
//  Copyright © 2018 Michael Van Milligan. All rights reserved.
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
            return
          }
          
          guard case let .success(_, products) = response else {
            XCTFail()
            return
          }
          
          guard let product: BVProduct = products.first,
            let brand: BVBrand = product.brand else {
              XCTFail()
              return
          }
          
          guard let reviews: [BVReview] = product.reviews,
            let questions: [BVQuestion] = product.questions else {
              XCTFail()
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
            product.imageUrl?.absoluteString,
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
        .filter(.reviews(.isRatingsOnly), op: .equalTo, value: "false")
        // only include questions where isFeatured is not equal to true
        .filter(.questions(.isFeatured), op: .notEqualTo, value: "true")
        .stats(.reviews)
        .configure(BVProductSearchQueryTest.config)
        .handler { (response: BVConversationsQueryResponse<BVProduct>) in
          
          if case .failure(let error) = response {
            print(error)
            XCTFail()
            return
          }
          
          guard case let .success(_, products) = response else {
            XCTFail()
            return
          }
          
          guard let product: BVProduct = products.first else {
            XCTFail()
            return
          }
          
          guard let reviews: [BVReview] = product.reviews,
            let questions: [BVQuestion] = product.questions else {
              XCTFail()
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
}
