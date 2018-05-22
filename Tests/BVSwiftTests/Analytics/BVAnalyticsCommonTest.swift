//
//
//  BVAnalyticsCommonTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVAnalyticsCommonTest: XCTestCase {
  
  private static var privateSession: URLSession = {
    return URLSession(configuration: .default)
  }()
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testAnalyticsEventBatching() {
    
    let expectation =
      self.expectation(description: "testAnalyticsEventBatching")
    
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
    
    let conversion: BVAnalyticsEvent =
      .conversion(type: "fruit", value: "apples", label: nil, additional: nil)
    
    let encodedPII: [BVAnalyticsEventInstance] =
      [ transaction, conversion ].map { ($0, false) }
    
    let encodedNoPII: [BVAnalyticsEventInstance] =
      [ transaction, conversion ].map { ($0, true) }
    
    let batch: BVAnalyticsEventBatch =
      BVAnalyticsEventBatch(encodedPII + encodedNoPII)
    
    do {
      let data = try JSONEncoder().encode(batch)
      let _ = try JSONSerialization.jsonObject(with: data, options: [])
    } catch {
      print("Error: \(error)")
      XCTFail("Couldn't parse BVAnalytics Events")
    }
    
    expectation.fulfill()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testAnalyticsEventSubmissionConstruction() {
    
    let expectation =
      self.expectation(description: "testAnalyticsEventBatching")
    
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
    
    let conversion: BVAnalyticsEvent =
      .conversion(type: "fruit", value: "apples", label: nil, additional: nil)
    
    let encodedPII: [BVAnalyticsEventInstance] =
      [ transaction, conversion ].map { ($0, false) }
    
    let batch: BVAnalyticsEventBatch =
      BVAnalyticsEventBatch(encodedPII)
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .configuration(
        locale: Locale.autoupdatingCurrent,
        configType: .staging(clientId: "conciergeapidocumentation"))
    
    let analyticsSubmission = BVAnalyticsSubmission(batch)
      .configure(analyticsConfig)
      .handler { (response: BVAnalyticsSubmission.BVAnalyticsEventResponse) in
        guard response.success else {
          XCTFail()
          return
        }
        expectation.fulfill()
    }
    
    print(analyticsSubmission.request?.url ?? "Not Available")
    
    /// Grab proper session ???
    analyticsSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testAnalyticsEventAppStateSubmission() {
    
    let expectation =
      self.expectation(description: "testAnalyticsEventAppStateSubmission")
    
    let dummyAppState =
      ["appState" : "launched",
       "appSubState" : "remote-notification-initiated"]
    let appStateEvent = dummyAppState + BVAnalyticsManager.defaultAppState
    
    let batch: BVAnalyticsEventBatch =
      BVAnalyticsEventBatch(
        [
          (BVAnalyticsManager.sharedManager.convertToEventable(appStateEvent),
           false)
        ])
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .configuration(
        locale: Locale.autoupdatingCurrent,
        configType: .staging(clientId: "conciergeapidocumentation"))
    
    let analyticsSubmission = BVAnalyticsSubmission(batch)
      .configure(analyticsConfig)
      .handler { (response: BVAnalyticsSubmission.BVAnalyticsEventResponse) in
        guard response.success else {
          XCTFail()
          return
        }
        expectation.fulfill()
    }
    
    print(analyticsSubmission.request?.url ?? "Not Available")
    
    /// Grab proper session ???
    analyticsSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}
