//
//
//  BVAnswerSubmissionTests.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVAnswerSubmissionTests: XCTestCase {
  
  private static var config: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "apitestcustomer"))
    
    return BVConversationsConfiguration.all(
      clientKey: "2cpdrhohmgmwfz8vqyo48f52g",
      configType: .staging(clientId: "apitestcustomer"),
      analyticsConfig: analyticsConfig)
  }()
  
  private static var privateSession:URLSession = {
    return URLSession(configuration: .default)
  }()
  
  override func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  func testSubmitAnswerWithPhoto() {
    let expectation =
      self.expectation(description: "testSubmitAnswerWithPhoto")
    
    guard let answerSubmission = fillOutAnswer(.submit) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    answerSubmission
      .handler { result in
        if case let .failure(errors) = result {
          errors.forEach { print($0) }
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(meta, _) = result else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        if let formFields = meta.formFields {
          XCTAssertEqual(formFields.count, 0)
        } else {
          XCTAssertNil(meta.formFields)
        }
        
        expectation.fulfill()
    }
    
    answerSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPreviewAnswerWithPhoto() {
    let expectation =
      self.expectation(description: "testPreviewAnswerWithPhoto")
    
    guard let answerSubmission = fillOutAnswer(.preview) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    answerSubmission
      .handler { result in
        if case let .failure(errors) = result {
          errors.forEach { print($0) }
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(meta, _) = result else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        if let formFields = meta.formFields {
          XCTAssertEqual(formFields.count, 22)
        } else {
          XCTAssertNil(meta.formFields)
        }
        
        expectation.fulfill()
    }
    
    answerSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSubmitAnswerFailure() {
    let expectation = self.expectation(description: "testSubmitAnswerFailure")
    
    let answer: BVAnswer = BVAnswer(questionId: "6104", answerText: "")
    
    guard let answerSubmission = BVAnswerSubmission(answer) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    answerSubmission
      .configure(BVAnswerSubmissionTests.config)
      .add(.preview)
      .add(.identifier("craiggil"))
      .handler { (result: BVConversationsSubmissionResponse<BVAnswer>) in
        
        guard let errors = result.errors else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        var formRequiredCount = 0
        
        XCTAssertEqual(errors.count, 1)
        
        errors.forEach { (error: Error) in
          guard let bverror: BVError = error as? BVError,
            let conversationsError =
            BVConversationsError(bverror.code, message: bverror.message) else {
              return
          }
          
          switch conversationsError {
          case .required:
            formRequiredCount += 1
          default:
            break
          }
        }
        
        XCTAssertEqual(formRequiredCount, 1)
        expectation.fulfill()
    }
    
    answerSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func fillOutAnswer(
    _ action : BVConversationsSubmissionAction) -> BVAnswerSubmission? {
    
    let answerText: String = "Answer text Answer text Answer text Answer " +
    "text Answer text Answer text Answer text Answer text"
    
    let answer: BVAnswer = BVAnswer(questionId: "6104", answerText: answerText)
    
    guard let answerSubmission = BVAnswerSubmission(answer),
      let png = BVPhotoSubmissionTest.createPNG() else {
        return nil
    }
    
    let randomId = String(arc4random())
    let photo: BVPhoto = BVPhoto(png, "Very photogenic")
    
    return answerSubmission
      .configure(BVAnswerSubmissionTests.config)
      .add(action)
      .add(.campaignId("BV_REVIEW_DISPLAY"))
      .add(.locale("en_US"))
      .add(.sendEmailWhenPublished(true))
      .add(.nickname("UserNickname\(randomId)"))
      .add(.email("developer@bazaarvoice.com"))
      .add(.identifier("UserId\(randomId)"))
      .add(.agree(true))
      .add(.photos([photo]))
  }
}
