//
//
//  BVCommonTest.swift
//  BVSwift
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
  
  func testXMLParserWithRawText() {
    let expectation =
      self.expectation(description: "testXMLParserWithRawText")
    
    let xmlString = "Bad string"
    
    guard let xmlData = xmlString.data(using: .utf8) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    XCTAssertNil(BVXMLParser().parse(xmlData))
    
    expectation.fulfill()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testXMLParserWithXML() {
    let expectation =
      self.expectation(description: "testXMLParserWithXML")
    
    let xml = "xml"
    let h1 = "h1"
    let h2 = "h2"
    let array = "array"
    let first = "Premier"
    let second = "Deuxieme"
    let item1 = "item1"
    let item2 = "item2"
    let item3 = "item3"
    let one = "Un"
    let two = "Deux"
    let three = "Trois"
    
    let xmlString =
      "<\(xml)>" +
        "<\(h1)>\(first)</\(h1)>" +
        "<\(h2)>\(second)</\(h2)>" +
        "<\(array)>" +
        "<\(item1)>\(one)</\(item1)>" +
        "<\(item2)>\(two)</\(item2)>" +
        "<\(item3)>\(three)</\(item3)>" +
        "</\(array)>" +
    "</\(xml)>"
    
    guard let xmlData = xmlString.data(using: .utf8),
      let parsed = BVXMLParser().parse(xmlData),
      let dictionary = parsed.dictionary,
      let root = dictionary[xml] as? [String : Any] else {
        XCTFail()
        expectation.fulfill()
        return
    }
    
    XCTAssertEqual(root[h1] as? String, first)
    XCTAssertEqual(root[h2] as? String, second)
    
    guard let inner: [String : Any] = root[array] as? [String : Any] else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    XCTAssertEqual(inner[item1] as? String, one)
    XCTAssertEqual(inner[item2] as? String, two)
    XCTAssertEqual(inner[item3] as? String, three)
    
    expectation.fulfill()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
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
  
  func testSDKVersionExistence() {
    let bundles = Bundle.allFrameworks
    
    let frameworkBundle =
      bundles.filter {
        $0.bundleIdentifier?.contains(
          BVConstants.bvFrameworkBundleIndentifier) ?? false }
    
    XCTAssertTrue(!frameworkBundle.isEmpty)
    
    guard let bvswiftBundle = frameworkBundle.first else {
      XCTFail()
      return
    }
    
    guard let version =
      bvswiftBundle
        .infoDictionary?[cfBundleVersionString] as? String else {
          XCTFail()
          return
    }
    
    XCTAssertTrue(!version.isEmpty)
  }
  
  func testLocks() {
    let expectation =
      self.expectation(description: "testLocks")
    
    let concurrentQueue = DispatchQueue(
      label: "com.bvswifttests.BVCommonTest.concurrentEventQueue",
      qos: .userInteractive,
      attributes: .concurrent,
      autoreleaseFrequency: .inherit,
      target: nil)
    
    let lock = BVLock()
    var lockTest = false
    
    concurrentQueue.async {
      let flag = lock.sync { () -> Bool in
        lockTest = true
        return lockTest
      }
      
      lock.lock()
      XCTAssertTrue(flag)
      expectation.fulfill()
      lock.unlock()
    }
    
    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testRecursiveLocks() {
    let expectation =
      self.expectation(description: "testRecursiveLocks")
    
    let concurrentQueue = DispatchQueue(
      label: "com.bvswifttests.BVCommonTest.concurrentEventQueue",
      qos: .userInteractive,
      attributes: .concurrent,
      autoreleaseFrequency: .inherit,
      target: nil)
    
    let lock = BVLock(.recursive)
    var lockTest = false
    
    concurrentQueue.async {
      let flag = lock.sync { () -> Bool in
        
        for _ in 0...10 {
          lock.lock()
        }
        
        lockTest = true
        return lockTest
      }
      
      lock.lock()
      XCTAssertTrue(flag)
      expectation.fulfill()
      lock.unlock()
    }
    
    self.waitForExpectations(timeout: 5) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}
