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
  
  private static var dateOfConsumerExperienceConfig: BVConversationsConfiguration =
    { () -> BVConversationsConfiguration in
      
      let analyticsConfig: BVAnalyticsConfiguration =
        .dryRun(
          configType: .staging(clientId: "Testcustomer-56"))
      
      return BVConversationsConfiguration.all(
        clientKey: "caYgyVsPvUkcK2a4aBCu0CK64S3vx6ERor9FpgAM32Uew",
        configType: .staging(clientId: "Testcustomer-56"),
        analyticsConfig: analyticsConfig)
    }()
    
    private static var dateOfConsumerExperienceFutureDateFormErrorConfig: BVConversationsConfiguration =
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
    
    (reviewSubmission <+> .videos([BVVideo(videoURL, caption: videoCaption)]))
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
    
  func testSubmitReviewFetchFormFields() {
    
    let expectation = self.expectation(description: "testSubmitReviewFetchFormFields")

    guard let reviewSubmission = BVReviewSubmission(productId: "1000001") else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    let randomId = String(arc4random())
    
    (reviewSubmission
    <+> .form
    <+> .identifier("UserId\(randomId)"))
    .configure(BVReviewSubmissionTest.config)
    .handler { (result: BVConversationsSubmissionResponse<BVReview>) in
        
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
        
        XCTAssertNotNil(meta.formFields)
        
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
    
    (reviewSubmission
      <+> .submit
      <+> .nickname("cgil")
      <+> .identifier("craiggiddll"))
      .configure(BVReviewSubmissionTest.config)
      .handler { (result: BVConversationsSubmissionResponse<BVReview>) in
        
        guard let errors = result.errors else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        errors.forEach { print("Expected Failure Item: \($0)") }
        XCTAssertEqual(errors.count, 4)
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
    
    (reviewSubmission
      <+> .submit
      <+> .nickname("cgil")
      <+> .identifier("craiggiddll"))
      .configure(BVReviewSubmissionTest.config)
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
        XCTAssertEqual(formDuplicateCount, 0)
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
    
    (reviewSubmission
      <+> .submit
      <+> .nickname("cgil")
      <+> .identifier("craiggiddl"))
      .configure(BVReviewSubmissionTest.config)
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
  
  func testSubmitReviewDateOfUserExperienceFetchFormFields() {
    
    let expectation = self.expectation(description: "testSubmitReviewDateOfUserExperienceFetchFormFields")
    
    guard let reviewSubmission = BVReviewSubmission(productId: "test1") else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    (reviewSubmission
      <+> .form)
      .configure(BVReviewSubmissionTest.dateOfConsumerExperienceConfig)
      .handler { (result: BVConversationsSubmissionResponse<BVReview>) in
        
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
        
        let formFields = meta.formFields
        XCTAssertNotNil(formFields)
        XCTAssertNotNil(formFields?.first(where: { $0.identifier == "additionalfield_DateOfUserExperience"}))
        expectation.fulfill()
      }
    
    reviewSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSubmitReviewDateOfUserExperience() {
    
    let expectation = self.expectation(description: "testSubmitReviewDateOfUserExperience")
    
    let review: BVReview = BVReview(productId: "test1",
                                    reviewText: "Testing date of consumer.Testing date of consumer. More then 50",
                                    reviewTitle: "Testing date of consumer",
                                    reviewRating: 4)
    
    guard let reviewSubmission = BVReviewSubmission(review) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    (reviewSubmission
      <+> .submit
      <+> .additional(name: "DateOfUserExperience", value: "2021-04-03"))
      .configure(BVReviewSubmissionTest.dateOfConsumerExperienceConfig)
      .handler { (result: BVConversationsSubmissionResponse<BVReview>) in
        
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
  
  func testSubmitReviewDateOfUserExperienceErrorInvalidDateFormat() {
    
    let expectation = self.expectation(description: "testSubmitReviewDateOfUserExperienceErrorInvalidDateFormat")
    
    let review: BVReview = BVReview(productId: "test1",
                                    reviewText: "Testing date of consumer.Testing date of consumer. More then 50",
                                    reviewTitle: "Testing date of consumer",
                                    reviewRating: 4)
    
    guard let reviewSubmission = BVReviewSubmission(review) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    (reviewSubmission
      <+> .submit
      <+> .additional(name: "DateOfUserExperience", value: "03-04-2021"))
      .configure(BVReviewSubmissionTest.dateOfConsumerExperienceConfig)
      .handler { (result: BVConversationsSubmissionResponse<BVReview>) in
        
        guard let errors = result.errors else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        var patternMismatch = 0
       
        errors.forEach { (error: Error) in
          guard let bverror: BVError = error as? BVError,
            let conversationsError =
            BVConversationsError(bverror.code, message: bverror.message) else {
              return
          }
          
        switch conversationsError {
          case .patternMismatch:
            patternMismatch += 1
          default:
            break
          }
        }
        
        XCTAssertEqual(patternMismatch, 1)
        expectation.fulfill()
      }
    
    reviewSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSubmitReviewDateOfUserExperienceErrorFutureDate() {
    
    let expectation = self.expectation(description: "testSubmitReviewDateOfUserExperienceErrorFutureDate")
    
    let review: BVReview = BVReview(productId: "test1",
                                    reviewText: "Testing date of consumer.Testing date of consumer. More then 50",
                                    reviewTitle: "Testing date of consumer",
                                    reviewRating: 4)
    
    guard let reviewSubmission = BVReviewSubmission(review) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    (reviewSubmission
      <+> .submit
      <+> .additional(name: "DateOfUserExperience", value: "2022-04-08"))
      .configure(BVReviewSubmissionTest.dateOfConsumerExperienceFutureDateFormErrorConfig)
      .handler { (result: BVConversationsSubmissionResponse<BVReview>) in
        
        guard let errors = result.errors else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        var futureDate = 0

        errors.forEach { (error: Error) in
          guard let bverror: BVError = error as? BVError,
            let conversationsError =
            BVConversationsError(bverror.code, message: bverror.message) else {
              return
          }

        switch conversationsError {
          case .futureDate:
            futureDate += 1
          default:
            break
          }
        }

        XCTAssertEqual(futureDate, 1)
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
    
    let usLocale: Locale = Locale(identifier: "en_US")
    
    return (reviewSubmission
      <+> action
      <+> .campaignId("BV_REVIEW_DISPLAY")
      <+> .locale(usLocale)
      <+> .sendEmailWhenCommented(true)
      <+> .sendEmailWhenPublished(true)
      <+> .nickname("UserNickname\(randomId)")
      <+> .email("developer@bazaarvoice.com")
      <+> .identifier("UserId\(randomId)")
      <+> .score(5)
      <+> .comment("Never!")
      <+> .agree(true)
      <+> .contextData(name: "Age", value: "18to24")
      <+> .contextData(name: "Gender", value: "Male")
      <+> .rating(name: "Quality", value: 1)
      <+> .rating(name: "Value", value: 3)
      <+> .rating(name: "HowDoes", value: 4)
      <+> .rating(name: "Fit", value: 3)
      <+> .photos([photo])
      <+> ["_foo": "bar"])
      .configure(BVReviewSubmissionTest.config)
  }
}
