//
//
//  BVFeedbackSubmissionTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import Foundation

import XCTest
@testable import BVSwift

class BVFeedbackSubmissionTest: XCTestCase {
  
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
    
private enum SubmissionPreference {
        case requireEncryptedUserIDs
        case plainTextAndEncryptedUserIDs
        
        var passKey: String {
            switch self {
                
            case .requireEncryptedUserIDs:
                return "caxi5FUl5PNoMOzk2EQmcc6lmYGpHp5tK2CHpcKUWxVXk" // passkey with require encrypted user ids set to true
                
            case .plainTextAndEncryptedUserIDs:
                return "ca4Fx0KXNpwZQTkNiyfRsJ5P1RO0oGiTuo8bSmcBVBm6E" // passkey with require encrypted user ids set to false
            }
        }
    }
  
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
  
  func testSubmitFeedbackHelpfulness() {
    
    let expectation =
      self.expectation(description: "testSubmitFeedbackHelpfulness")
    
    let feedback =
      BVFeedback.helpfulness(
        vote: .positive,
        authorId: "",
        contentId: "83725",
        contentType: .review)
    
    guard let feedbackSubmission = BVFeedbackSubmission(feedback) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    let randomId = String(arc4random())
    let userId: String = "userId\(randomId)"
    
    (feedbackSubmission <+> .identifier(userId))
      .configure(BVFeedbackSubmissionTest.config)
      .handler { (response: BVConversationsSubmissionResponse<BVFeedback>) in
        
        if let _ = response.errors {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, result) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        switch result {
        case let .helpfulness(vote, authorId, _, _):
          XCTAssertEqual(userId, authorId)
          XCTAssertEqual(vote, BVFeedback.Vote.positive)
          break
        default:
          XCTFail()
          expectation.fulfill()
          return
        }
        
        expectation.fulfill()
    }
    
    feedbackSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSubmitFeedbackFlag() {
    
    let expectation = self.expectation(description: "testSubmitFeedbackFlag")
    
    let reasonText: String = "Optional reason text in this field."
    
    let feedback =
      BVFeedback.inappropriate(
        reason: reasonText,
        authorId: "",
        contentId: "83725",
        contentType: .review)
    
    guard let feedbackSubmission = BVFeedbackSubmission(feedback) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    let randomId = String(arc4random())
    let userId: String = "userId\(randomId)"
    
    (feedbackSubmission <+> .identifier(userId))
      .configure(BVFeedbackSubmissionTest.config)
      .handler { (response: BVConversationsSubmissionResponse<BVFeedback>) in
        
        if let _ = response.errors {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        guard case let .success(_, result) = response else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        switch result {
        case let .inappropriate(reason, authorId, _, _):
          XCTAssertEqual(userId, authorId)
          XCTAssertEqual(reason, reasonText)
          break
        default:
          XCTFail()
          expectation.fulfill()
          return
        }
        
        expectation.fulfill()
    }
    
    feedbackSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testSubmitFeedbackFailure() {
    
    let expectation =
      self.expectation(description: "testSubmissionFeedbackFailure")
    
    let feedback =
      BVFeedback.inappropriate(
        reason: "",
        authorId: "",
        contentId: "badidshouldmakeerror",
        contentType: .review)
    
    guard let feedbackSubmission = BVFeedbackSubmission(feedback) else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    let randomId = String(arc4random())
    
    (feedbackSubmission <+> .identifier("userId\(randomId)"))
      .configure(BVFeedbackSubmissionTest.config)
      .handler { (response: BVConversationsSubmissionResponse<BVFeedback>) in
        
        guard let errors = response.errors else {
          XCTFail()
          expectation.fulfill()
          return
        }
        
        var invalidParameters = 0
        
        errors.forEach { (error: Error) in
          guard let bverror: BVError = error as? BVError,
            let conversationsError =
            BVConversationsError(bverror.code, message: bverror.message) else {
              return
          }
          
          switch conversationsError {
          case .invalidParameters:
            invalidParameters += 1
          default:
            break
          }
        }
        
        XCTAssertEqual(invalidParameters, 1)
        expectation.fulfill()
    }
    
    feedbackSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
    
    func testSubmitFeedbackWithUserId() {
        
        BVFeedbackSubmissionTest.updateConfiguration(submissionPreference: .plainTextAndEncryptedUserIDs)
        
        let expectation = self.expectation(description: "testSubmitFeedbackWithUserId")
        
        let feedback =
            BVFeedback.helpfulness(vote: .positive,
                                   authorId: "",
                                   contentId: "83725",
                                   contentType: .review)
        
        guard let feedbackSubmission = BVFeedbackSubmission(feedback) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        let randomId = String(arc4random())
        let userId: String = "userId\(randomId)"
        
        (feedbackSubmission <+> .identifier(userId))
            .configure(BVFeedbackSubmissionTest.config)
            .handler { (response: BVConversationsSubmissionResponse<BVFeedback>) in
                
                if let _ = response.errors {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                guard case let .success(_, result) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                switch result {
                case let .helpfulness(vote, authorId, _, _):
                    XCTAssertEqual(userId, authorId)
                    XCTAssertEqual(vote, BVFeedback.Vote.positive)
                    break
                    
                default:
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                expectation.fulfill()
        }
        
        
        feedbackSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testSubmitFeedbackWithUAS() {
        
        BVFeedbackSubmissionTest.updateConfiguration(submissionPreference: .plainTextAndEncryptedUserIDs)
        
        let expectation = self.expectation(description: "testSubmitFeedbackWithUAS")
        
        let feedback =
            BVFeedback.helpfulness(vote: .positive,
                                   authorId: "",
                                   contentId: "83725",
                                   contentType: .review)
        
        guard let feedbackSubmission = BVFeedbackSubmission(feedback) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        (feedbackSubmission <+> .uas("dea9114258e49d5d95f4db5d4465991f7573657269643d7573657249643335333237393139333126646174653d3230323030353039")
            )
            .configure(BVFeedbackSubmissionTest.config)
            .handler { (response: BVConversationsSubmissionResponse<BVFeedback>) in
                
                if let _ = response.errors {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                guard case let .success(_, result) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                switch result {
                case let .helpfulness(vote, _, _, _):
                    XCTAssertEqual(vote, BVFeedback.Vote.positive)
                    break
                    
                default:
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                expectation.fulfill()
        }
        
        
        feedbackSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testSubmitFeedbackWithUserIdForRequireEncryptedUserIds() {
        
        BVFeedbackSubmissionTest.updateConfiguration(submissionPreference: .requireEncryptedUserIDs)
        
        let expectation = self.expectation(description: "testSubmitFeedbackWithUserIdForRequireEncryptedUserIds")
        
        let feedback =
            BVFeedback.helpfulness(vote: .positive,
                                   authorId: "",
                                   contentId: "83725",
                                   contentType: .review)
        
        guard let feedbackSubmission = BVFeedbackSubmission(feedback) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        let randomId = String(arc4random())
        let userId: String = "userId\(randomId)"
        
        (feedbackSubmission <+> .identifier(userId))
            .configure(BVFeedbackSubmissionTest.config)
            .handler { (response: BVConversationsSubmissionResponse<BVFeedback>) in
                
                guard let errors = response.errors else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                var invalidParameters = 0
                
                errors.forEach { (error: Error) in
                    guard let bverror: BVError = error as? BVError,
                        let conversationsError =
                        BVConversationsError(bverror.code, message: bverror.message) else {
                            return
                    }
                    
                    switch conversationsError {
                    case .invalidParameters:
                        invalidParameters += 1
                    default:
                        break
                    }
                }
                
                XCTAssertEqual(invalidParameters, 1)
                expectation.fulfill()
        }
        
        feedbackSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testSubmitFeedbackWithUASForRequireEncryptedUserIds() {
        
        BVFeedbackSubmissionTest.updateConfiguration(submissionPreference: .requireEncryptedUserIDs)
        
        let expectation = self.expectation(description: "testSubmitFeedbackWithUASForRequireEncryptedUserIds")
        
        let feedback =
            BVFeedback.helpfulness(vote: .positive,
                                   authorId: "",
                                   contentId: "83725",
                                   contentType: .review)
        
        guard let feedbackSubmission = BVFeedbackSubmission(feedback) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        (feedbackSubmission <+> .uas("dea9114258e49d5d95f4db5d4465991f7573657269643d7573657249643335333237393139333126646174653d3230323030353039")
            )
            .configure(BVFeedbackSubmissionTest.config)
            .handler { (response: BVConversationsSubmissionResponse<BVFeedback>) in
                
                if let _ = response.errors {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                guard case let .success(_, result) = response else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                switch result {
                case let .helpfulness(vote, _, _, _):
                    XCTAssertEqual(vote, BVFeedback.Vote.positive)
                    break
                    
                default:
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                expectation.fulfill()
        }
        
        feedbackSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(error, "Something went horribly wrong, request took too long.")
        }
    }
    
    private static func updateConfiguration(submissionPreference: SubmissionPreference) {
        config =
            { () -> BVConversationsConfiguration in
                
                let analyticsConfig: BVAnalyticsConfiguration =
                    .dryRun(
                        configType: .staging(clientId: "apitestcustomer"))
                
                return BVConversationsConfiguration.all(
                    clientKey: submissionPreference.passKey,
                    configType: .staging(clientId: "apitestcustomer"),
                    analyticsConfig: analyticsConfig)
        }()
    }
    
}
