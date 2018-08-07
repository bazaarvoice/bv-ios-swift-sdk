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
        configType: .staging(clientId: "maurices"))
    
    return BVRecommendationsConfiguration.display(
      clientKey: "sr2E446qoPDpZ8NIMhvphZSG0VteEm9nqMyqDWwXjg7OA",
      configType: .production(clientId: "maurices"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var configBadKey: BVRecommendationsConfiguration =
  { () -> BVRecommendationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "kohls"))
    
    return BVRecommendationsConfiguration.display(
      clientKey: "badkeybadkeybadkey",
      configType: .staging(clientId: "kohls"),
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
    //expectation?.fulfill()
  }
}
