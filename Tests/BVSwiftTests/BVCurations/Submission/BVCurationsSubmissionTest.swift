//
//
//  BVCurationsSubmissionTest.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVCurationsSubmissionTest: XCTestCase {
  
  private static var config: BVCurationsConfiguration =
  { () -> BVCurationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "branddemo"))
    
    return BVCurationsConfiguration.all(
      clientKey: "r538c65d7d3rsx2265tvzfje",
      configType: .staging(clientId: "branddemo"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var configBadKey: BVCurationsConfiguration =
  { () -> BVCurationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "qa_client1"))
    
    return BVCurationsConfiguration.all(
      clientKey: "badkeybadkeybadkey",
      configType: .staging(clientId: "qa_client1"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var configTesting: BVRawConfiguration =
  { () -> BVRawConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "branddemo"))
    
    let endpoint: String = BVCurationsConstants.Testing.stagingEndpoint
    
    return BVRawConfiguration(
      key: "r538c65d7d3rsx2265tvzfje",
      endpoint: endpoint,
      type: .staging(clientId: "branddemo"),
      subConfigs: [analyticsConfig])
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
  
  override func setUp() {
    super.setUp()
    
    BVManager.sharedManager.logLevel = .debug
    BVPixel.skipAllPixelEvents = true
  }
  
  override func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  /*
   
   func testChannelContentSubmission() {
   
   let expectation = self.expectation(
   description: "testChannelContentSubmission")
   
   guard let url = URL(string: "https://www.instagram.com/p/BkDecixgtOw/") else {
   XCTFail()
   expectation.fulfill()
   return
   }
   
   let channelContent =
   BVCurationsChannelContent(url: url, approve: true, bypass: true)
   
   guard let channelContentSubmission =
   BVCurationsChannelContentSubmission(channelContent) else {
   XCTFail()
   expectation.fulfill()
   return
   }
   
   channelContentSubmission
   .configureRaw(BVCurationsSubmissionTest.configTesting)
   .handler { response in
   
   if case let .failure(errors) = response {
   print(errors)
   XCTFail()
   expectation.fulfill()
   return
   }
   
   guard case .success = response else {
   XCTFail()
   expectation.fulfill()
   return
   }
   
   expectation.fulfill()
   }
   
   
   guard let request = channelContentSubmission.request else {
   XCTFail()
   expectation.fulfill()
   return
   }
   
   print(request)
   
   channelContentSubmission.async()
   
   self.waitForExpectations(timeout: 20) { (error) in
   XCTAssertNil(
   error, "Something went horribly wrong, request took too long.")
   }
   }
   
   func testFeedItemQueryBadKey() {
   
   let expectation = self.expectation(
   description: "testFeedItemQueryBadKey")
   
   let feedItemQuery = BVCurationsFeedItemQuery()
   
   feedItemQuery
   .configure(BVCurationsSubmissionTest.configBadKey)
   .filter(.productId(.string("2561970")))
   .handler { response in
   
   guard case let .failure(errors) = response,
   let firstError = errors.first as? BVCurationsError,
   case let .query(error) = firstError else {
   XCTFail()
   expectation.fulfill()
   return
   }
   
   XCTAssertEqual(BVCurationsError.invalidPasskey, error)
   
   expectation.fulfill()
   }
   
   guard let request = feedItemQuery.request else {
   XCTFail()
   expectation.fulfill()
   return
   }
   
   print(request)
   
   feedItemQuery.async()
   
   self.waitForExpectations(timeout: 20) { (error) in
   XCTAssertNil(
   error, "Something went horribly wrong, request took too long.")
   }
   }
   */
}
