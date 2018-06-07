//
//
//  BVCommonTest.swift
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVCommonTest: XCTestCase {
  
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
  
  func testAnalyticsEventAppStateSubmission() {
    
    let expectation =
      self.expectation(description: "testAnalyticsEventAppStateSubmission")
    
    var dispatchOnce: Bool = false
    BVLogger.sharedLogger.logLevel = .debug
    BVLogger.sharedLogger.loggerRedirect = { (msg: String) in
      print(msg)
      if !dispatchOnce {
        dispatchOnce = true
        expectation.fulfill()
      }
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
      BVLogger.sharedLogger.debug("Fullfilling expectation")
    }
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}
