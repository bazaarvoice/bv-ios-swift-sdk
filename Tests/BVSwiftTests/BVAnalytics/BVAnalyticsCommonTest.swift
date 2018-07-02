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
    
    let feature: BVAnalyticsEvent =
      .feature(
        bvProduct: .recommendations,
        name: .scrolled,
        productId: "id#$%$#$%$%",
        brand: "brandX",
        additional: nil)
    
    let config = BVAnalyticsCommonTest.analyticsConfig
    
    let encodedPII: [BVAnalyticsEventInstance] =
      [ transaction, feature ].map { ($0, config, false, nil) }
    
    let encodedNoPII: [BVAnalyticsEventInstance] =
      [ transaction, feature ].map { ($0, config, true, nil) }
    
    let batch: BVAnalyticsEventBatch =
      BVAnalyticsEventBatch(encodedPII + encodedNoPII)
    
    do {
      let data = try JSONEncoder().encode(batch)
      let _ = try JSONSerialization.jsonObject(with: data, options: [])
    } catch {
      print("Error: \(error)")
      XCTFail("Couldn't parse BVAnalytics Events")
      expectation.fulfill()
    }
    
    expectation.fulfill()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testAnalyticsEventBatchingOverride() {
    let expectation =
      self.expectation(description: "testAnalyticsEventBatchingOverride")
    
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
    
    let newType: String = "newType"
    let override: [String: BVAnyEncodable] =
      ["type": BVAnyEncodable(newType),
       "country": BVAnyEncodable(BVNil())]
    
    let feature: BVAnalyticsEvent =
      .feature(
        bvProduct: .recommendations,
        name: .scrolled,
        productId: "id#$%$#$%$%",
        brand: "brandX",
        additional: nil)
    
    let config = BVAnalyticsCommonTest.analyticsConfig
    
    let encodedPII: [BVAnalyticsEventInstance] =
      [ transaction, feature ].map { ($0, config, false, override) }
    
    let encodedNoPII: [BVAnalyticsEventInstance] =
      [ transaction, feature ].map { ($0, config, true, override) }
    
    let batch: BVAnalyticsEventBatch =
      BVAnalyticsEventBatch(encodedPII + encodedNoPII)
    
    do {
      let data = try JSONEncoder().encode(batch)
      let object = try JSONSerialization.jsonObject(with: data, options: [])
      
      if let json = object as? [String: AnyObject],
        let batch = json["batch"] as? [[String: AnyObject]] {
        
        batch.forEach {
          let type = $0["type"] as? String
          let nilCurrency = $0["country"]
          XCTAssertEqual(type, newType)
          XCTAssertNil(nilCurrency)
        }
      }
      
    } catch {
      print("Error: \(error)")
      XCTFail("Couldn't parse BVAnalytics Events")
      expectation.fulfill()
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
    
    let config = BVAnalyticsCommonTest.analyticsConfig
    
    let encodedPII: [BVAnalyticsEventInstance] =
      [ transaction, conversion ].map { ($0, config, false, nil) }
    
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
          expectation.fulfill()
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
    
    let config = BVAnalyticsCommonTest.analyticsConfig
    
    let batch: BVAnalyticsEventBatch =
      BVAnalyticsEventBatch(
        [
          (BVAnalyticsManager.sharedManager.convertToEventable(appStateEvent),
           config,
           false,
           nil)
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
          expectation.fulfill()
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
