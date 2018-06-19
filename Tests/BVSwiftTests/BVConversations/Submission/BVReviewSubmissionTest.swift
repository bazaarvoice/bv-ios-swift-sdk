//
//
//  BVReviewSubmissionTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSwift

class BVReviewSubmissionTest: XCTestCase {
  
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
  
  func testSubmitReviewWithPhoto() {
    
    let expectation =
      self.expectation(description: "testSubmitReviewWithPhoto")
    
    guard let reviewSubmission = fillOutReview(.submit) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    reviewSubmission
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
    
    reviewSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPreviewReviewWithPhoto() {
    
    let expectation =
      self.expectation(description: "testPreviewReviewWithPhoto")
    
    guard let reviewSubmission = fillOutReview(.preview) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    reviewSubmission
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
          XCTAssertEqual(formFields.count, 50)
        } else {
          XCTAssertNil(meta.formFields)
        }
        
        expectation.fulfill()
    }
    
    reviewSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testPreviewReviewWithVideo() {
    
    let expectation =
      self.expectation(description: "testPreviewReviewWithVideo")
    
    guard let reviewSubmission = fillOutReview(.preview) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    guard let videoURL: URL =
      URL(string: "https://www.youtube.com/watch?v=oHg5SJYRHA0") else {
        XCTFail()
        expectation.fulfill()
        return
    }
    
    let videoCaption: String = "Very videogenic"
    
    reviewSubmission
      .add(.videos([BVVideo(videoURL, caption: videoCaption)]))
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
          XCTAssertEqual(formFields.count, 50)
        } else {
          XCTAssertNil(meta.formFields)
        }
        
        expectation.fulfill()
    }
    
    reviewSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSubmitReviewFailure() {
    let expectation = self.expectation(description: "testSubmitReviewFailure")
    
    let review: BVReview = BVReview(productId: "1000001",
                                    reviewText: "",
                                    reviewTitle: "",
                                    
                                    reviewRating: 123)
    
    guard let reviewSubmission = BVReviewSubmission(review) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    reviewSubmission
      .configure(BVReviewSubmissionTest.config)
      .add(.submit)
      .add(.nickname("cgil"))
      .add(.identifier("craiggiddl"))
      .handler { (result: BVConversationsSubmissionResponse<BVReview>) in
        
        guard let errors = result.errors else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        errors.forEach { print("Expected Failure Item: \($0)") }
        XCTAssertEqual(errors.count, 5)
        expectation.fulfill()
    }
    
    reviewSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSubmitReviewFailureFormCodeParsing() {
    let expectation =
      self.expectation(description: "testSubmitReviewFailureFormCodeParsing")
    
    let review: BVReview = BVReview(productId: "1000001",
                                    reviewText: "",
                                    reviewTitle: "",
                                    reviewRating: 123)
    
    guard let reviewSubmission = BVReviewSubmission(review) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    reviewSubmission
      .configure(BVReviewSubmissionTest.config)
      .add(.submit)
      .add(.nickname("cgil"))
      .add(.identifier("craiggiddl"))
      .handler { (result: BVConversationsSubmissionResponse<BVReview>) in
        
        guard let errors = result.errors else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        var formRequiredCount = 0
        var formDuplicateCount = 0
        var formTooHighCount = 0
        
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
          case .tooHigh:
            formTooHighCount += 1
          default:
            break
          }
        }
        
        XCTAssertEqual(formRequiredCount, 3)
        XCTAssertEqual(formDuplicateCount, 1)
        XCTAssertEqual(formTooHighCount, 1)
        
        expectation.fulfill()
    }
    
    reviewSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSubmitReviewFailureCodeParsing() {
    let expectation =
      self.expectation(description: "testSubmitReviewFailureCodeParsing")
    
    let review: BVReview = BVReview(productId: "",
                                    reviewText: "",
                                    reviewTitle: "",
                                    reviewRating: 123
    )
    
    guard let reviewSubmission = BVReviewSubmission(review) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    reviewSubmission
      .configure(BVReviewSubmissionTest.config)
      .add(.submit)
      .add(.nickname("cgil"))
      .add(.identifier("craiggiddl"))
      .handler { (result: BVConversationsSubmissionResponse<BVReview>) in
        
        guard let errors = result.errors else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        var badRequestCount = 0
        
        errors.forEach { (error: Error) in
          guard let bverror: BVError = error as? BVError,
            let conversationsError =
            BVConversationsError(bverror.code, message: bverror.message) else {
              return
          }
          
          switch conversationsError {
          case .badRequest:
            badRequestCount += 1
          default:
            break
          }
        }
        
        XCTAssertEqual(badRequestCount, 1)
        
        expectation.fulfill()
    }
    
    reviewSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func fillOutReview(
    _ action : BVConversationsSubmissionAction) -> BVReviewSubmission? {
    
    let reviewText = "more than 50 more than 50 " +
    "more than 50 more than 50 more than 50"
    
    let review: BVReview = BVReview(productId: "test1",
                                    reviewText: reviewText,
                                    reviewTitle: "review title",
                                    reviewRating: 4)
    
    guard let reviewSubmission = BVReviewSubmission(review),
      let png = BVPhotoSubmissionTest.createPNG() else {
        return nil
    }
    
    let randomId = String(arc4random())
    let photo: BVPhoto = BVPhoto(png, "Very photogenic")
    
    return reviewSubmission
      .configure(BVReviewSubmissionTest.config)
      .add(action)
      .add(.campaignId("BV_REVIEW_DISPLAY"))
      .add(.locale("en_US"))
      .add(.sendEmailWhenCommented(true))
      .add(.sendEmailWhenPublished(true))
      .add(.nickname("UserNickname\(randomId)"))
      .add(.email("developer@bazaarvoice.com"))
      .add(.identifier("UserId\(randomId)"))
      .add(.score(5))
      .add(.comment("Never!"))
      .add(.agree(true))
      .add(.contextData(name: "Age", value: "18to24"))
      .add(.contextData(name: "Gender", value: "Male"))
      .add(.rating(name: "Quality", value: 1))
      .add(.rating(name: "Value", value: 3))
      .add(.rating(name: "HowDoes", value: 4))
      .add(.rating(name: "Fit", value: 3))
      .add(["_foo" : "bar"])
      .add(.photos([photo]))
  }
}
