//
//
//  BVRecommendationsQueryTest.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVRecommendationsQueryTest: XCTestCase {
  
  private static var config: BVRecommendationsConfiguration =
  { () -> BVRecommendationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "apitestcustomer"))
    
    return BVRecommendationsConfiguration.display(
      clientKey: "srZ86SuQ0JupyKrtBHILGIIFsqJoeP4tXYJlQfjojBmuo",
      configType: .production(clientId: "apitestcustomer"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var configBadKey: BVRecommendationsConfiguration =
  { () -> BVRecommendationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "badclient"))
    
    return BVRecommendationsConfiguration.display(
      clientKey: "badkeybadkeybadkey",
      configType: .staging(clientId: "badclient"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var privateSession: URLSession = {
    return URLSession(configuration: .default)
  }()
  
  private class func loadJSONData() -> Data? {
    guard let resourceURL =
      Bundle(
        for: BVPhotoSubmissionTest.self)
        .url(
          forResource: "testCurationsFeedTest",
          withExtension: ".json") else {
            return nil
    }
    return try? Data(contentsOf: resourceURL, options: [])
  }
  
  private var listener: BVRecommendationsQueryTestListener?
  
  override class func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override class func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    
    BVURLCacheManager.shared.expunge()
    self.listener = nil
  }
  
  func testProfileQueryConstruction() {
    
    let bvBrandId: String = "610ce8a1-644f-4f02-8b6e-8b198376aa9d"
    let lookbackTime: Int = 10
    guard let lookback =
      Calendar.current.date(
        byAdding: .second,
        value: -1 * lookbackTime,
        to: Date()) else {
          XCTFail()
          return
    }
    
    let usLocale: Locale = Locale(identifier: "en_US")
    
    let profileQuery =
      BVRecommendationsProfileQuery()
        /// Config
        .configure(BVRecommendationsQueryTest.config)
        /// Average Rating
        .field(.avgRating(3.333333333333333333))
        /// Brand Id
        .field(.brandId(bvBrandId))
        /// Interest
        .field(.interest("football"))
        /// Locale
        .field(.locale(usLocale))
        /// Lookback
        .field(.lookback(lookback))
        /// Includes
        .field(.include(.interests))
        .field(.include(.categories))
        .field(.include(.brands))
        .field(.include(.recommendations))
        /// Preferred Category
        .field(.preferredCategory("sports_wear"))
        /// Product
        .field(.product("product1234"))
        /// Purpose
        .field(.purpose(.ads))
        /// Required Category
        .field(.requiredCategory("menswear"))
        /// Strategies
        .field(.strategy("foo"))
        .field(.strategy("foo"))
        .field(.strategy("bar"))
        .field(.strategy("bar"))
        .field(.strategy("baz"))
        .field(.strategy("baz"))
    
    _ = profileQuery.preflight { (error: Error?) in
      guard nil == error else {
        XCTFail()
        return
      }
    }
    
    guard let request = profileQuery.request,
      let requestString = request.url?.absoluteString else {
        XCTFail()
        return
    }
    
    print(requestString)
    
    XCTAssertTrue(requestString.contains("avg_rating=\(3.33333)"))
    XCTAssertTrue(requestString.contains("bvbrandid=\(bvBrandId)"))
    XCTAssertTrue(
      requestString.contains("category=apitestcustomer/sports_wear"))
    XCTAssertTrue(
      requestString.contains(
        "include=brands,category_recommendations,interests,recommendations"))
    XCTAssertTrue(requestString.contains("interest=football"))
    XCTAssertTrue(requestString.contains("locale=\(usLocale.identifier)"))
    XCTAssertTrue(requestString.contains("lookback=10s"))
    XCTAssertTrue(
      requestString.contains("product=apitestcustomer/product1234"))
    XCTAssertTrue(requestString.contains("purpose=ads"))
    XCTAssertTrue(
      requestString.contains("required_category=apitestcustomer/menswear"))
    XCTAssertTrue(requestString.contains("strategies=bar,baz,foo"))
  }
  
  func testProfileQuery() {
    
    let expectation = self.expectation(description: "testProfileQuery")
    
    let profileQuery = BVRecommendationsProfileQuery()
    
    profileQuery
      .configure(BVRecommendationsQueryTest.config)
      .field(.brandId("610ce8a1-644f-4f02-8b6e-8b198376aa9d"))
      .field(.include(.interests))
      .field(.include(.categories))
      .field(.include(.brands))
      .field(.include(.recommendations))
      .handler { response in
        
        if case let .failure(errors) = response {
          print(errors)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(meta, result) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        print(meta)
        print(result)
        
        expectation.fulfill()
    }
    
    profileQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testProfileQueryCached() {
    
    let expectation = self.expectation(description: "testProfileQueryCached")
    
    let thisListener = BVRecommendationsQueryTestListener(expectation)
    
    self.listener = thisListener
    BVURLCacheManager.shared.add(thisListener)
    
    let profileQuery = BVRecommendationsProfileQuery()
      .configure(BVRecommendationsQueryTest.config)
      .field(.brandId("610ce8a1-644f-4f02-8b6e-8b198376aa9d"))
      .field(.include(.interests))
      .field(.include(.categories))
      .field(.include(.brands))
      .field(.include(.recommendations))
    
    var once: Bool = true
    
    profileQuery
      .handler { response in
        if once {
          once = false
          profileQuery.async()
        }
    }
    
    profileQuery.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}

internal class BVRecommendationsQueryTestListener: BVURLCacheListener {
  
  private var expectation: XCTestExpectation?
  
  init(_ expectation: XCTestExpectation) {
    self.expectation = expectation
  }
  
  func hit(_ request: URLRequest) {
    print("HIT")
    expectation?.fulfill()
  }
  
  func miss(_ request: URLRequest) {
    print("MISS")
  }
}
