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
    
    BVLogger.sharedLogger.setLogLevel(.debug)
  }
  
  override func tearDown() {
    super.tearDown()
    
    BVLogger.sharedLogger.setLogLevel(.error)
    BVManager.sharedManager.removeAllConfigurations()
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
  
  func testAnalyticsEventConstruction() {
    
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
    
    let transactionEvent: BVAnalyticsEvent =
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
    
    let config = BVAnalyticsCommonTest.analyticsConfig
    
    let encodedPII: [BVAnalyticsEventInstance] =
      [ transactionEvent ].map { ($0, config, false, nil) }
    
    let batch: BVAnalyticsEventBatch =
      BVAnalyticsEventBatch(encodedPII)
    
    do {
      let data = try JSONEncoder().encode(batch)
      let object = try JSONSerialization.jsonObject(with: data, options: [])
      
      if let json = object as? [String: AnyObject],
        let batch = json["batch"] as? [[String: AnyObject]],
        let transaction: [String: AnyObject] = batch.first,
        let items = transaction["items"] as? [[String: AnyObject]] {
        
        XCTAssertNotNil(transaction["orderId"])
        XCTAssertNotNil(transaction["total"])
        XCTAssertNotNil(transaction["city"])
        XCTAssertNotNil(transaction["country"])
        XCTAssertNotNil(transaction["currency"])
        XCTAssertNotNil(transaction["shipping"])
        XCTAssertNotNil(transaction["state"])
        XCTAssertNotNil(transaction["tax"])
        XCTAssertNotNil(transaction["1"])
        XCTAssertNotNil(transaction["3"])
        XCTAssertNotNil(transaction["5"])
        
        items.forEach {
          XCTAssertNotNil($0["category"])
          XCTAssertNil($0["imageURL"])
          XCTAssertNotNil($0["name"])
          XCTAssertNotNil($0["price"])
          XCTAssertNotNil($0["quantity"])
          XCTAssertNotNil($0["sku"])
        }
      } else {
        XCTFail("Couldn't parse BVAnalytics Events")
      }
      
    } catch {
      print("Error: \(error)")
      XCTFail("Couldn't parse BVAnalytics Events")
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
  
  func testAnalyticsRemoteLogDirectSubmission() {
    
    let expectation =
      self.expectation(description: "testAnalyticsRemoteLogDirectSubmission")
    
    let analyticsConfig = BVAnalyticsCommonTest.analyticsConfig
    
    let log = "[\(#function):\(#line)] testing logging error facility"
    let liveLog =
      BVAnalyticsRemoteLog(
        client: "apitestcustomer",
        error: BVLogger.LogLevel.fault.description,
        locale: Locale.autoupdatingCurrent,
        log: log,
        bvProduct: BVAnalyticsConstants.bvProduct)
    
    let liveLogSubmission = BVAnalyticsSubmission(liveLog)
      .configure(analyticsConfig)
      .handler { (response: BVAnalyticsSubmission.BVAnalyticsEventResponse) in
        if case let .failure(errors) = response {
          print(errors)
          expectation.fulfill()
          XCTFail()
          return
        }
        
        expectation.fulfill()
    }
    
    liveLogSubmission.async()
    
    XCTAssertNotNil(liveLogSubmission.request?.url)
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testAnalyticsRemoteLogSubmission() {
    let expectation =
      self.expectation(description: "testAnalyticsRemoteLogDirectSubmission")
    
    let analyticsConfig = BVAnalyticsCommonTest.analyticsConfig
    BVManager.sharedManager.addConfiguration(analyticsConfig)
    
    BVAnalyticsRemoteLogger.sharedManager.remoteLogTestingCompletion = {
      expectation.fulfill()
      if let errors = $1 {
        print(errors)
        XCTFail()
        return
      }
      print($0)
    }
    
    BVLogger.sharedLogger.fault(
      BVLogMessage(
        BVAnalyticsConstants.bvProduct,
        msg: "testing logging error facility"))
    
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}
