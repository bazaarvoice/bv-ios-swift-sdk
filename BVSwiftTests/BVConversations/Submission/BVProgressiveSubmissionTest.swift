//
//
//  BVProgressiveSubmissionTest.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSwift

class BVProgressiveSubmissionTest: XCTestCase {
    
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
    
    var submissionFields = BVProgressiveReviewFields()
    
    func testProgressiveSubmissionWithToken() {
        let expectation =
            self.expectation(description: "testProgressiveSubmissionWithToken")
        
        let progressiveReview: BVProgressiveReview = self.buildRequest()
        
        guard let progressiveReviewSubmission = BVProgressiveReviewSubmission(progressiveReview) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        progressiveReviewSubmission.configure(BVProgressiveSubmissionTest.config)
        let internalURLSession: URLSession =
        BVNetworkingManager.sharedManager.networkingSession
        
        BVManager.sharedManager.urlSession = internalURLSession
        progressiveReviewSubmission
            .handler { result in
                if case .failure(_) = result {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                if case let .success(_ , response) = result {
                    XCTAssertTrue( response.submissionSessionToken != nil)
                    XCTAssertTrue( response.submissionId != nil)
                    XCTAssertTrue( response.isFormComplete == true)
                    XCTAssertTrue( response.review?.rating == self.submissionFields.rating)
                    XCTAssertTrue( response.review?.title == self.submissionFields.title)
                    XCTAssertTrue( response.review?.reviewtext == self.submissionFields.reviewtext)
                    expectation.fulfill()
                    return
                }
                
                expectation.fulfill()
        }
        
        progressiveReviewSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testProgressiveSubmissionWithFormFields() {
        let expectation =
            self.expectation(description: "testProgressiveSubmissionWithFormFields")
        
        var progressiveReview: BVProgressiveReview = self.buildRequest()
        progressiveReview.includeFields = true
        
        guard let progressiveReviewSubmission = BVProgressiveReviewSubmission(progressiveReview) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        progressiveReviewSubmission.configure(BVProgressiveSubmissionTest.config)
        let internalURLSession: URLSession =
        BVNetworkingManager.sharedManager.networkingSession
        
        BVManager.sharedManager.urlSession = internalURLSession
        progressiveReviewSubmission
            .handler { result in
                if case .failure(_) = result {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                if case let .success(_ , response) = result {
                    XCTAssertTrue( response.submissionSessionToken != nil)
                    XCTAssertTrue( response.submissionId != nil)
                    XCTAssertTrue( response.fieldsOrder != nil)
                    XCTAssertTrue( response.fields != nil)
                    XCTAssertTrue( response.isFormComplete == true)
                    XCTAssertTrue( response.review?.rating == self.submissionFields.rating)
                    XCTAssertTrue( response.review?.title == self.submissionFields.title)
                    XCTAssertTrue( response.review?.reviewtext == self.submissionFields.reviewtext)
                    expectation.fulfill()
                    return
                }
                
                expectation.fulfill()
        }
        
        progressiveReviewSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testProgressiveSubmissionWithPreview() {
        let expectation =
            self.expectation(description: "testProgressiveSubmissionWithPreview")
        
        var progressiveReview: BVProgressiveReview = self.buildRequest()
        progressiveReview.isPreview = true
        
        guard let progressiveReviewSubmission = BVProgressiveReviewSubmission(progressiveReview) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        progressiveReviewSubmission.configure(BVProgressiveSubmissionTest.config)
        let internalURLSession: URLSession =
        BVNetworkingManager.sharedManager.networkingSession
        
        BVManager.sharedManager.urlSession = internalURLSession
        progressiveReviewSubmission
            .handler { result in
                if case .failure(_) = result {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                if case let .success(_ , response) = result {
                    XCTAssertTrue( response.submissionSessionToken != nil)
                    XCTAssertTrue( response.submissionId == nil)
                    XCTAssertTrue( response.isFormComplete == true)
                    XCTAssertTrue( response.review?.rating == self.submissionFields.rating)
                    XCTAssertTrue( response.review?.title == self.submissionFields.title)
                    XCTAssertTrue( response.review?.reviewtext == self.submissionFields.reviewtext)
                    expectation.fulfill()
                    return
                }
                
                expectation.fulfill()
        }
        
        progressiveReviewSubmission.async()
        
        self.waitForExpectations(timeout: 20) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
    
    func testProgressiveSubmissionMissingEmailError() {
         let expectation =
             self.expectation(description: "testProgressiveSubmissionMissingEmailError")
         
         var progressiveReview: BVProgressiveReview = self.buildRequest()
         progressiveReview.userToken = nil
         progressiveReview.userId = "tets109"
         
         guard let progressiveReviewSubmission = BVProgressiveReviewSubmission(progressiveReview) else {
             XCTFail()
             expectation.fulfill()
             return
         }
         progressiveReviewSubmission.configure(BVProgressiveSubmissionTest.config)
         let internalURLSession: URLSession =
         BVNetworkingManager.sharedManager.networkingSession
         
         BVManager.sharedManager.urlSession = internalURLSession
         progressiveReviewSubmission
             .handler { result in
                 if case let .failure(errors) = result, let error = errors.first {
                     XCTAssertEqual(
                       String(describing: error), "Email address is missing/invalid")
                     expectation.fulfill()
                     return
                 }
                 
                if case .success(_ , _) = result {
                     XCTFail()
                     expectation.fulfill()
                     return
                 }
                 
                 expectation.fulfill()
         }
         
         progressiveReviewSubmission.async()
         
         self.waitForExpectations(timeout: 20) { (error) in
             XCTAssertNil(
                 error, "Something went horribly wrong, request took too long.")
         }
     }
    
    func testProgressiveSubmissionMissingUserIdError() {
         let expectation =
             self.expectation(description: "testProgressiveSubmissionMissingUserIdError")
         
         var progressiveReview: BVProgressiveReview = self.buildRequest()
         progressiveReview.userToken = nil
         
         guard let progressiveReviewSubmission = BVProgressiveReviewSubmission(progressiveReview) else {
             XCTFail()
             expectation.fulfill()
             return
         }
         progressiveReviewSubmission.configure(BVProgressiveSubmissionTest.config)
         let internalURLSession: URLSession =
         BVNetworkingManager.sharedManager.networkingSession
         
         BVManager.sharedManager.urlSession = internalURLSession
         progressiveReviewSubmission
             .handler { result in
                 if case let .failure(errors) = result, let error = errors.first {
                     XCTAssertEqual(
                       String(describing: error), "UserId is missing/invalid")
                     expectation.fulfill()
                     return
                 }
                 
                if case .success(_ , _) = result {
                     XCTFail()
                     expectation.fulfill()
                     return
                 }
                 
                 expectation.fulfill()
         }
         
         progressiveReviewSubmission.async()
         
         self.waitForExpectations(timeout: 20) { (error) in
             XCTAssertNil(
                 error, "Something went horribly wrong, request took too long.")
         }
     }
    
    func testProgressiveSubmissionMissingMissingProductIdError() {
         let expectation =
             self.expectation(description: "testProgressiveSubmissionMissingUserIdError")
         
         var progressiveReview: BVProgressiveReview = self.buildRequest()
        progressiveReview.productId = ""
         
         guard let progressiveReviewSubmission = BVProgressiveReviewSubmission(progressiveReview) else {
             XCTFail()
             expectation.fulfill()
             return
         }
         progressiveReviewSubmission.configure(BVProgressiveSubmissionTest.config)
         let internalURLSession: URLSession =
         BVNetworkingManager.sharedManager.networkingSession
         
         BVManager.sharedManager.urlSession = internalURLSession
         progressiveReviewSubmission
             .handler { result in
                 if case let .failure(errors) = result, let error = errors.first {
                     XCTAssertEqual(
                       String(describing: error), "ProductId is missing")
                     expectation.fulfill()
                     return
                 }
                 
                if case .success(_ , _) = result {
                     XCTFail()
                     expectation.fulfill()
                     return
                 }
                 
                 expectation.fulfill()
         }
         
         progressiveReviewSubmission.async()
         
         self.waitForExpectations(timeout: 20) { (error) in
             XCTAssertNil(
                 error, "Something went horribly wrong, request took too long.")
         }
     }
    
    func testProgressiveSubmissionInvalidFormFieldError() {
           let expectation =
               self.expectation(description: "testProgressiveSubmissionInvalidFormFieldError")
           
           var progressiveReview: BVProgressiveReview = self.buildRequest()
           progressiveReview.submissionFields?.reviewtext = "The"
           
           guard let progressiveReviewSubmission = BVProgressiveReviewSubmission(progressiveReview) else {
               XCTFail()
               expectation.fulfill()
               return
           }
           progressiveReviewSubmission.configure(BVProgressiveSubmissionTest.config)
           let internalURLSession: URLSession =
           BVNetworkingManager.sharedManager.networkingSession
           
           BVManager.sharedManager.urlSession = internalURLSession
           progressiveReviewSubmission
               .handler { result in
                   if case let .failure(errors) = result, let error = errors.first {
                       XCTFail()
                       expectation.fulfill()
                       return
                   }
                   
                  if case let .success(_ , response) = result {
                      XCTAssertTrue( response.submissionSessionToken != nil)
                      XCTAssertTrue( response.isFormComplete == true)
                      XCTAssertTrue(response.formFieldErrors!.first?.code == "ERROR_FORM_TOO_SHORT")
                      XCTAssertTrue(response.formFieldErrors!.first?.message == "too short")
                      XCTAssertTrue(response.formFieldErrors!.first?.field == "reviewtext")
                      expectation.fulfill()
                      return
                  }
                   
                   expectation.fulfill()
           }
           
           progressiveReviewSubmission.async()
           
           self.waitForExpectations(timeout: 20) { (error) in
               XCTAssertNil(
                   error, "Something went horribly wrong, request took too long.")
           }
       }
    
    override class func setUp() {
        super.setUp()
        
        BVPixel.skipAllPixelEvents = true
    }
    
    func buildRequest() -> BVProgressiveReview {

        self.submissionFields = BVProgressiveReviewFields()
        submissionFields.rating = 4
        submissionFields.title =  "my favorite product ever!"
        submissionFields.reviewtext = "This Product was somewhat disapointing. I thouught it would be cool to have flowers around the house, but turns out its underwhelming."
        submissionFields.agreedToTerms = true
        submissionFields.sendEmailAlert = true
        submissionFields.isRecommended = true
        
        var submission = BVProgressiveReview(productId:"product10", submissionFields: submissionFields)
        submission.submissionSessionToken = "plmxQ1Jut55FDVIK4uC5CJffmL20qOorqf0J87lcklmt8GZ7tbNDDyDx/UZeV+Dv7CgRurvxkrn0uAiNjdQpq9Z2ABxVvNq/kHnElA3GTs0="
        submission.locale = "en_US"
        submission.userToken = "6851e5f974485291cd2c32bfbc4d00774e6d298910c3b0c674e553a4cc48562d6d61786167653d33353626484f535445443d564552494649454426646174653d323031393037323526656d61696c616464726573733d42564061696c2e636f6d267573657269643d74657374313039"
        return submission
    }

    
    override class func tearDown() {
        super.tearDown()
        
        BVPixel.skipAllPixelEvents = false
        
    }
    
    
}
