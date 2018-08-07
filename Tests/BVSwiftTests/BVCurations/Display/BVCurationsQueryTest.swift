//
//
//  BVCurationsQueryTest.swift
//  BVSwift
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

/// https://api.bazaarvoice.com/curations/c3/content/get/?has_photo_or_video=true&client=kohls&productId=2561970&passkey=kuuqd395w5u7gv43987gxshh

import Foundation

import XCTest
@testable import BVSwift

class BVCurationsQueryTest: XCTestCase {
  
  private static var config: BVCurationsConfiguration =
  { () -> BVCurationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "branddemo"))
    
    return BVCurationsConfiguration.display(
      clientKey: "r538c65d7d3rsx2265tvzfje",
      configType: .production(clientId: "branddemo"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var configBadKey: BVCurationsConfiguration =
  { () -> BVCurationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "branddemo"))
    
    return BVCurationsConfiguration.display(
      clientKey: "badkeybadkeybadkey",
      configType: .staging(clientId: "branddemo"),
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
  
  override class func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override class func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  func testFeedItemQueryParseURL() {
    
    let expectation = self.expectation(
      description: "testFeedItemQueryParseURL")
    
    
    let feedItemQuery =
      BVCurationsFeedItemQuery()
        .configure(BVCurationsQueryTest.config)
        .field(.before(Date()))
        .field(.language("en"))
        .field(.language("fr"))
        .field(.language("de"))
        .field(.tag("one"))
        .field(.tag("deux"))
        .field(.tag("drei"))
        .field(.display("display_one"))
        .field(.display("display_deux"))
        .field(.display("display_drei"))
    
    guard let request = feedItemQuery.request,
      let absoluteURLString = request.url?.absoluteString else {
        XCTFail()
        expectation.fulfill()
        return
    }
    
    let languages: String = "languages=de,en,fr"
    let tags: String = "tags=deux,drei,one"
    let display: String = "display=display_deux,display_drei,display_one"
    
    print(absoluteURLString)
    
    XCTAssertNotNil(absoluteURLString.range(of: languages))
    XCTAssertNotNil(absoluteURLString.range(of: tags))
    XCTAssertNotNil(absoluteURLString.range(of: display))
    
    expectation.fulfill()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testFeedItemQueryParseResult() {
    
    let expectation = self.expectation(
      description: "testFeedItemQueryParseResult")
    
    guard let jsonData = BVCurationsQueryTest.loadJSONData() else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    guard let response =
      try? JSONDecoder().decode(
        BVCurationsQueryResponseInternal<BVCurationsFeedItem>.self,
        from: jsonData) else {
          
          do {
            let _ = try JSONDecoder().decode(
              BVCurationsQueryResponseInternal<BVCurationsFeedItem>.self,
              from: jsonData)
          } catch {
            print(BVCommonError.parse(error))
          }
          
          XCTFail()
          expectation.fulfill()
          return
    }
    
    if let code = response.code {
      print("Code: \(code)")
    }
    
    if let errors = response.errors {
      print("Errors: \(errors)")
    }
    
    if let limit = response.limit {
      print("Limit: \(limit)")
    }
    
    if let offset = response.offset {
      print("Offset: \(offset)")
    }
    
    if let returnedResults = response.returnedResults {
      print("Number of Returned Results: \(returnedResults)")
    }
    
    if let status = response.status {
      print("Status: \(status)")
    }
    
    if let totalResults = response.totalResults {
      print("Total Amount of Results: \(totalResults)")
    }
    
    if let results = response.results,
      let firstResult = results.first,
      let firstId = firstResult.contentId {
      print("Results [0 of \(results.count)]: \(firstId)")
      
      if let referencedProducts = firstResult.referencedProducts {
        print("Referenced Products: \(referencedProducts)")
      }
    }
    
    expectation.fulfill()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testFeedItemQuery() {
    
    let expectation = self.expectation(
      description: "testFeedItemQuery")
    
    let feedItemQuery = BVCurationsFeedItemQuery()
    
    feedItemQuery
      .configure(BVCurationsQueryTest.config)
      .field(.before(Date()))
      .handler { response in
        
        if case let .failure(errors) = response {
          print(errors)
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(meta, results) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        print(meta)
        
        if let firstResult = results.first,
          let contentId = firstResult.contentId {
          print(contentId)
          
          if let referencedProducts = firstResult.referencedProducts {
            print(referencedProducts)
          }
        }
        
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
  
  func testFeedItemQueryBadKey() {
    
    let expectation = self.expectation(
      description: "testFeedItemQueryBadKey")
    
    let feedItemQuery = BVCurationsFeedItemQuery()
    
    feedItemQuery
      .configure(BVCurationsQueryTest.configBadKey)
      .field(.productId(.string("2561970")))
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
}
