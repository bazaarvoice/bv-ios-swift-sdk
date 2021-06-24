//
//
//  BVQuestionSubmissionTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVQuestionSubmissionTest: XCTestCase {
  
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
  
  override class func setUp() {
    super.setUp()
    
    BVPixel.skipAllPixelEvents = true
  }
  
  override class func tearDown() {
    super.tearDown()
    
    BVPixel.skipAllPixelEvents = false
  }
  
  func testSubmitQuestionWithPhoto() {
    let expectation =
      self.expectation(description: "testSubmitQuestionWithPhoto")
    
    guard let questionSubmission = fillOutQuestion(.submit) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    questionSubmission
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
    
    questionSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPreviewQuestionWithPhoto() {
    let expectation =
      self.expectation(description: "testPreviewQuestionWithPhoto")
    
    guard let questionSubmission = fillOutQuestion(.preview) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    questionSubmission
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
          XCTAssertEqual(formFields.count, 33)
        } else {
          XCTAssertNil(meta.formFields)
        }
        
        expectation.fulfill()
    }
    
    questionSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSubmitQuestionFailure() {
    let expectation =
      self.expectation(description: "testSubmitQuestionFailure")
    
    let question: BVQuestion =
      BVQuestion(
        productId: "1000001",
        questionDetails: "",
        questionSummary: "",
        isUserAnonymous: false)
    
    guard let questionSubmission = BVQuestionSubmission(question) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    (questionSubmission
      <+> .preview
      <+> .identifier("craiggiddl")
      <+> .nickname("cgil"))
      .configure(BVQuestionSubmissionTest.config)
      .handler { (result: BVConversationsSubmissionResponse<BVQuestion>) in
        
        guard let errors = result.errors else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        var formRequiredCount = 0
        var formDuplicateCount = 0
        
        errors.forEach { (error: Error) in
          guard let bverror: BVError = error as? BVError,
            let conversationsError =
            BVConversationsError(bverror.code, message: bverror.message) else {
              return
          }
          
          switch conversationsError {
          case .required:
            formRequiredCount += 1
          case .duplicate:
            formDuplicateCount += 1
          default:
            break
          }
        }
        
        XCTAssertEqual(formRequiredCount, 1)
        XCTAssertEqual(formDuplicateCount, 0)
        expectation.fulfill()
    }
    
    questionSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func fillOutQuestion(
    _ action : BVConversationsSubmissionAction) -> BVQuestionSubmission? {
    
    let questionDetails: String =
      "Question body Question body Question body Question body Question " +
    "body Question body Question body"
    
    let question: BVQuestion =
      BVQuestion(
        productId: "1000001",
        questionDetails: questionDetails,
        questionSummary: "Question title question title?",
        isUserAnonymous: false)
    
    guard let questionSubmission = BVQuestionSubmission(question),
      let png = BVPhotoSubmissionTest.createPNG() else {
        return nil
    }
    
    let randomId = String(arc4random())
    let photo: BVPhoto = BVPhoto(png, "Very photogenic")
    
    let usLocale: Locale = Locale(identifier: "en_US")
    
    return (questionSubmission
      <+> action
      <+> .campaignId("BV_REVIEW_DISPLAY")
      <+> .locale(usLocale)
      <+> .sendEmailWhenCommented(true)
      <+> .sendEmailWhenPublished(true)
      <+> .nickname("UserNickname\(randomId)")
      <+> .email("developer@bazaarvoice.com")
      <+> .identifier("UserId\(randomId)")
      <+> .agree(true)
      <+> .photos([photo]))
      .configure(BVQuestionSubmissionTest.config)
  }
}
