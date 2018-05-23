//
//
//  BVPixelTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVPixelTest: XCTestCase {
  
  private static var config: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    return BVConversationsConfiguration.display(
      clientKey: "caB45h2jBqXFw1OE043qoMBD1gJC8EwFNCjktzgwncXY4",
      configType: .staging(clientId: "conciergeapidocumentation"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var analyticsConfig: BVAnalyticsConfiguration = {
    return .configuration(
      locale: Locale.autoupdatingCurrent,
      configType: .staging(clientId: "conciergeapidocumentation"))
  }()
  
  private static var privateSession: URLSession = {
    return URLSession(configuration: .default)
  }()
  
  override func setUp() {
    super.setUp()
    
    BVManager.sharedManager.addConfiguration(BVPixelTest.config)
    BVManager.sharedManager.logLevel = .info
    
    BVPixel.skipAllPixelEvents = false
  }
  
  override func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  func testPixelConversionEvent() {
    
    let expectation =
      self.expectation(description: "testPixelConversionEvent")
    
    let conversion: BVAnalyticsEvent =
      .conversion(
        type: "fruit",
        value: "apples",
        label: nil,
        additional: ["piiData" : "somePII"])
    
    let numberOfEvents: UInt = 2
    
    BVPixel.track(conversion)
    
    BVAnalyticsManager.sharedManager.flush
      { (successes: UInt?, errors: [Error]?) in
        if let errs = errors {
          print(errs)
          XCTFail()
          return
        }
        
        guard let wins = successes else {
          XCTFail()
          return
        }
        
        
        if numberOfEvents != wins {
          XCTFail()
          return
        }
        
        expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPixelFeatureEvent() {
    
    let expectation =
      self.expectation(description: "testPixelFeatureEvent")
    
    let feature: BVAnalyticsEvent =
      .feature(
        bvProduct: .reviews,
        name: .reviewComment,
        productId: "productid3434",
        brand: nil,
        additional: nil)
    
    let numberOfEvents: UInt = 1
    
    BVPixel.track(feature)
    
    BVAnalyticsManager.sharedManager.flush
      { (successes: UInt?, errors: [Error]?) in
        if let errs = errors {
          print(errs)
          XCTFail()
          return
        }
        
        guard let wins = successes else {
          XCTFail()
          return
        }
        
        
        if numberOfEvents != wins {
          XCTFail()
          return
        }
        
        expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPixelImpressionEvent() {
    
    let expectation =
      self.expectation(description: "testPixelImpressionEvent")
    
    let impression: BVAnalyticsEvent =
      .impression(
        bvProduct: .reviews,
        contentId: "productid3434",
        contentType: .review,
        productId: "productid3434",
        brand: nil,
        categoryId: nil,
        additional: nil)
    
    let numberOfEvents: UInt = 1
    
    BVPixel.track(impression)
    
    BVAnalyticsManager.sharedManager.flush
      { (successes: UInt?, errors: [Error]?) in
        if let errs = errors {
          print(errs)
          XCTFail()
          return
        }
        
        guard let wins = successes else {
          XCTFail()
          return
        }
        
        
        if numberOfEvents != wins {
          XCTFail()
          return
        }
        
        expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPixelInViewEvent() {
    
    let expectation =
      self.expectation(description: "testPixelImpressionEvent")
    
    let inView: BVAnalyticsEvent =
      .inView(
        bvProduct: .reviews,
        component: "Login",
        productId: "productid3434",
        brand: nil,
        additional: nil)
    
    let numberOfEvents: UInt = 1
    
    BVPixel.track(inView)
    
    BVAnalyticsManager.sharedManager.flush
      { (successes: UInt?, errors: [Error]?) in
        if let errs = errors {
          print(errs)
          XCTFail()
          return
        }
        
        guard let wins = successes else {
          XCTFail()
          return
        }
        
        
        if numberOfEvents != wins {
          XCTFail()
          return
        }
        
        expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPixelPageViewEvent() {
    
    let expectation =
      self.expectation(description: "testPixelPageViewEvent")
    
    let pageView: BVAnalyticsEvent =
      .pageView(
        bvProduct: .reviews,
        productId: "productid3434",
        brand: nil,
        categoryId: nil,
        rootCategoryId: nil,
        additional: nil)
    
    let numberOfEvents: UInt = 1
    
    // We don't explicitly call BVPixel.track(pageView) because it kicks off a
    // flush for us and we won't be able to check the success of the event
    // because we have to use the callback signature.
    BVAnalyticsManager.sharedManager
      .enqueue(
        analyticsEvent: pageView,
        configuration: BVPixelTest.analyticsConfig)
    
    BVAnalyticsManager.sharedManager.flush
      { (successes: UInt?, errors: [Error]?) in
        if let errs = errors {
          print(errs)
          XCTFail()
          return
        }
        
        guard let wins = successes else {
          XCTFail()
          return
        }
        
        
        if numberOfEvents != wins {
          XCTFail()
          return
        }
        
        expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPixelPersonalizationEvent() {
    
    let expectation =
      self.expectation(description: "testPixelPersonalizationEvent")
    
    let personalization: BVAnalyticsEvent =
      .personalization(profileId: "conciergeapidocumentation", additional: nil)
    
    let numberOfEvents: UInt = 1
    
    // We don't explicitly call BVPixel.track(personalization) because it kicks
    // off a flush for us and we won't be able to check the success of the event
    // because we have to use the callback signature.
    BVAnalyticsManager.sharedManager
      .enqueue(
        analyticsEvent: personalization,
        configuration: BVPixelTest.analyticsConfig)
    
    BVAnalyticsManager.sharedManager.flush
      { (successes: UInt?, errors: [Error]?) in
        if let errs = errors {
          print(errs)
          XCTFail()
          return
        }
        
        guard let wins = successes else {
          XCTFail()
          return
        }
        
        
        if numberOfEvents != wins {
          XCTFail()
          return
        }
        
        expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPixelTransactionEvent() {
    
    let expectation =
      self.expectation(description: "testPixelTransactionEvent")
    
    let items: [BVAnalyticsTransactionItem] = [
      BVAnalyticsTransactionItem(
        category: "fruit",
        imageURL: nil,
        name: "apples",
        price: 5.35,
        quantity: 10,
        sku: "$%#$%#jksfgjsdkf$554353"),
      BVAnalyticsTransactionItem(
        category: "fruit",
        imageURL: nil,
        name: "oranges",
        price: 8.35,
        quantity: 10,
        sku: "$%#$%#$jfhdjfhdf"),
      BVAnalyticsTransactionItem(
        category: "fruit",
        imageURL: nil,
        name: "bananas",
        price: 10.35,
        quantity: 10,
        sku: "$%#$%#djfhdjhf554353")
    ]
    
    let transaction: BVAnalyticsEvent =
      .transaction(items: items,
                   orderId: "id-924859485",
                   total: 20.75,
                   city: "Austin",
                   country: "USA",
                   currency: "US",
                   shipping: 7.50,
                   state: "TX",
                   tax: 3.25,
                   additional: ["1" : "2", "3" : "4", "5" : "6"])
    
    let numberOfEvents: UInt = 2
    
    BVPixel.track(transaction)
    
    BVAnalyticsManager.sharedManager.flush
      { (successes: UInt?, errors: [Error]?) in
        if let errs = errors {
          print(errs)
          XCTFail()
          return
        }
        
        guard let wins = successes else {
          XCTFail()
          return
        }
        
        
        if numberOfEvents != wins {
          XCTFail()
          return
        }
        
        expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPixelViewedEvent() {
    
    let expectation =
      self.expectation(description: "testPixelImpressionEvent")
    
    let viewed: BVAnalyticsEvent =
      .viewed(
        bvProduct: .reviews,
        productId: "productid3434",
        brand: nil,
        categoryId: nil,
        rootCategoryId: nil,
        additional: nil)
    
    let numberOfEvents: UInt = 1
    
    BVPixel.track(viewed)
    
    BVAnalyticsManager.sharedManager.flush
      { (successes: UInt?, errors: [Error]?) in
        if let errs = errors {
          print(errs)
          XCTFail()
          return
        }
        
        guard let wins = successes else {
          XCTFail()
          return
        }
        
        
        if numberOfEvents != wins {
          XCTFail()
          return
        }
        
        expectation.fulfill()
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}