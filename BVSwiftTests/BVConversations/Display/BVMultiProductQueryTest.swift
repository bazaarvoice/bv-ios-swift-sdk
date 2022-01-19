//
//
//  BVMultiProductQueryTest.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSwift

class BVMultiProductQueryTest: XCTestCase {

    private static var config: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
            .dryRun(
                configType: .staging(clientId: "testcustomermobilesdk"))
        
        return BVConversationsConfiguration.all(
            clientKey: "cauPFGiXDMZYw1QQ11PBmJXt5YdK5oEvirFBMxlyshhlU",
            configType: .staging(clientId: "testcustomermobilesdk"),
            analyticsConfig: analyticsConfig)
    }()
    
    private static var privateSession:URLSession = {
        return URLSession(configuration: .default)
    }()
    
    override class func setUp() {
        super.setUp()
        
        BVPixel.skipAllPixelEvents = true
    }
    
    override class func tearDown() {
        super.tearDown()
        
        BVPixel.skipAllPixelEvents = false
    }

    func testMultiProductQueryWithToken() {
        let expectation =
            self.expectation(description: "testMultiProductQueryWithToken")
        
        let multiProduct: BVMultiProduct = BVMultiProduct(productIds: ["product4", "product2", "product3"], locale: "en_US", userToken: "6851e5f974485291cd2c32bfbc4d00774e6d298910c3b0c674e553a4cc48562d6d61786167653d33353626484f535445443d564552494649454426646174653d323031393037323526656d61696c616464726573733d42564061696c2e636f6d267573657269643d74657374313039")
        
        guard let multiProductSubmission = BVMultiProductQuery(multiProduct) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        multiProductSubmission.configure(BVMultiProductQueryTest.config)
        
        multiProductSubmission
            .handler { result in
              if case .failure(_) = result {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                if case let .success(_ , response) = result {
                    XCTAssertTrue( response.productFormData!.count == 3)
                    expectation.fulfill()
                    return
                }
                
                expectation.fulfill()
        }
        
        multiProductSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testMultiProductQueryWithUserId() {
        let expectation =
            self.expectation(description: "testMultiProductQueryWithUserId")
        
        let multiProduct: BVMultiProduct = BVMultiProduct(productIds: ["product4", "product2", "product3"], locale: "en_US", userId: "test109")
        
        guard let multiProductSubmission = BVMultiProductQuery(multiProduct) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        multiProductSubmission.configure(BVMultiProductQueryTest.config)
        
        multiProductSubmission
            .handler { result in
                if case .failure(_) = result {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                if case let .success(_, response) = result {
                    XCTAssertTrue( response.productFormData!.count == 3)
                    expectation.fulfill()
                    return
                }
                
                expectation.fulfill()
        }
        
        multiProductSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testMultiProductQueryMissingUserIdError() {
        let expectation =
            self.expectation(description: "testMultiProductQueryMissingUserIdError")
        
        let multiProduct: BVMultiProduct = BVMultiProduct(productIds: ["product4", "product2", "product3"], locale: "en_US")
        
        guard let multiProductSubmission = BVMultiProductQuery(multiProduct) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        multiProductSubmission.configure(BVMultiProductQueryTest.config)
        
        multiProductSubmission
            .handler { result in
                if case let .failure(errors) = result, let error = errors.first {
                    XCTAssertEqual(
                      String(describing: error), "UserId is missing/invalid")
                    expectation.fulfill()
                    return
                }
                guard case .success(_, _) = result else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                expectation.fulfill()
        }
        multiProductSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testMultiProductQueryMissingProductsError() {
        let expectation =
            self.expectation(description: "testMultiProductQueryMissingProductsError")
        
        let multiProduct: BVMultiProduct = BVMultiProduct(productIds: [], locale: "en_US", userId: "test109")
        
        guard let multiProductSubmission = BVMultiProductQuery(multiProduct) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        multiProductSubmission.configure(BVMultiProductQueryTest.config)
        
        multiProductSubmission
            .handler { result in
                if case let .failure(errors) = result, let error = errors.first {
                    XCTAssertEqual(
                      String(describing: error), "Need at least one Product Id")
                    expectation.fulfill()
                    return
                }
                guard case .success(_, _) = result else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                expectation.fulfill()
        }
        multiProductSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testMultiProductQueryMissingLocaleError() {
        let expectation =
            self.expectation(description: "testMultiProductQueryMissingLocaleError")
        
        let multiProduct: BVMultiProduct = BVMultiProduct(productIds: ["product4", "product2", "product3"], locale: "", userId: "test109")
        
        guard let multiProductSubmission = BVMultiProductQuery(multiProduct) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        multiProductSubmission.configure(BVMultiProductQueryTest.config)
        
        multiProductSubmission
            .handler { result in
                if case let .failure(errors) = result, let error = errors.first {
                    XCTAssertEqual(
                      String(describing: error), "Locale is missing")
                    expectation.fulfill()
                    return
                }
                guard case .success(_, _) = result else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                expectation.fulfill()
        }
        multiProductSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
  
  func testHostedAuthMultiProduct() {
      let expectation =
          self.expectation(description: "testHostedAuthMultiProduct")
      
      var multiProduct: BVMultiProduct = BVMultiProduct(productIds: ["product4", "product2", "product3"], locale: "en_US")
      multiProduct.hostedAuth = true
      
      guard let multiProductSubmission = BVMultiProductQuery(multiProduct) else {
          XCTFail()
          expectation.fulfill()
          return
      }
      multiProductSubmission.configure(BVMultiProductQueryTest.config)
      
      multiProductSubmission
          .handler { result in
            if case .failure(_) = result {
                  XCTFail()
                  expectation.fulfill()
                  return
              }
              
              if case let .success(_ , response) = result {
                  XCTAssertTrue( response.productFormData!.count == 3)
                  XCTAssertNotNil(response.userId)
                  expectation.fulfill()
                  return
              }
              
              expectation.fulfill()
      }
      
      multiProductSubmission.async()
      
      self.waitForExpectations(timeout: 20) { (error) in
          XCTAssertNil(
              error, "Something went horribly wrong, request took too long.")
      }
  }
}
