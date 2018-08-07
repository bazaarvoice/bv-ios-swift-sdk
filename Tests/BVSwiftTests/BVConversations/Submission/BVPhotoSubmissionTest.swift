//
//
//  BVPhotoSubmissionTest.swift
//  BVSwiftTests
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSwift

class BVPhotoSubmissionTest: XCTestCase {
  
  private class func loadJSONData() -> Data? {
    guard let resourceURL =
      Bundle(
        for: BVPhotoSubmissionTest.self)
        .url(
          forResource: "testJPEGPhotoResourceDecode",
          withExtension: ".json") else {
            return nil
    }
    return try? Data(contentsOf: resourceURL, options: [])
  }
  
  internal class func createPNG() -> UIImage? {
    return UIImage(
      named: "ph.png",
      in: Bundle(for: BVPhotoSubmissionTest.self),
      compatibleWith: nil)
  }
  
  internal class func createJPG() -> UIImage? {
    return UIImage(
      named: "skelly_android.jpg",
      in: Bundle(for: BVPhotoSubmissionTest.self),
      compatibleWith: nil)
  }
  
  private static var config: BVConversationsConfiguration =
  { () -> BVConversationsConfiguration in
    
    let analyticsConfig: BVAnalyticsConfiguration =
      .dryRun(
        configType: .staging(clientId: "apitestcustomer"))
    
    return BVConversationsConfiguration.all(
      clientKey: "kuy3zj9pr3n7i0wxajrzj04xo",
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
  
  func testPhotoResourceDecodingPath() {
    
    guard let jsonData = BVPhotoSubmissionTest.loadJSONData() else {
      XCTFail()
      return
    }
    
    do {
      let response = try JSONDecoder()
        .decode(
          BVConversationsSubmissionResponseInternal<BVPhoto>.self,
          from: jsonData)
      
      guard let authorSubmissionToken = response.authorSubmissionToken,
        let errors = response.errors,
        let formFieldErrors = response.formFieldErrors,
        let formFields = response.formFields,
        let locale = response.locale,
        let result = response.result,
        let submissionId = response.submissionId,
        let typicalHoursToPost = response.typicalHoursToPost else {
          XCTFail()
          return
      }
      
      XCTAssertTrue(response.hasErrors)
      XCTAssertEqual(errors.count, 1)
      XCTAssertEqual(formFieldErrors.count, 2)
      XCTAssertEqual(formFields.count, 1)
      XCTAssertEqual(authorSubmissionToken, "tokentokentoken")
      XCTAssertEqual(locale, "en_US")
      XCTAssertEqual(submissionId, "submissionidsubmissionidsubmissionid")
      XCTAssertEqual(typicalHoursToPost, 24)
      
      guard let caption = result.caption,
        let photoId = result.photoId,
        let photoSizes = result.photoSizes else {
          XCTFail()
          return
      }
      
      XCTAssertEqual(caption, "Such a beautiful picture")
      XCTAssertEqual(photoId, "38771tu37go1g7s11u0u8xwvt")
      XCTAssertEqual(photoSizes.count, 2)
      
      guard let formFieldError = formFieldErrors.first,
        let formFieldErrorName = formFieldError.name
        else {
          XCTFail()
          return
      }
      
      XCTAssertEqual(formFieldErrorName, "RandomError1")
      XCTAssertEqual(formFieldError.code, "SOME_WEIRD_CODE")
      XCTAssertEqual(formFieldError.message, "This is a test.")
      
      guard let formField = formFields.first,
        let formFieldOption = formField.options?.first,
        let formFieldIdentifier = formField.identifier,
        let formFieldDefault = formField.isDefault,
        let formFieldLabel = formField.label,
        let formFieldMaxLength = formField.maxLength,
        let formFieldMinLength = formField.minLength,
        let formFieldRequired = formField.required,
        let formFieldValue = formField.value
        else {
          XCTFail()
          return
      }
      
      XCTAssertEqual(formField.formInputType, .file)
      XCTAssertEqual(formFieldIdentifier, "photo")
      XCTAssertTrue(formFieldDefault)
      XCTAssertEqual(formFieldLabel, "Test Label")
      XCTAssertEqual(formFieldMaxLength, 500)
      XCTAssertEqual(formFieldMinLength, 25)
      XCTAssertTrue(formFieldRequired)
      XCTAssertEqual(formFieldValue, "Test Value")
      
      guard let formFieldOptionLabel = formFieldOption.label,
        let formFieldOptionSelected = formFieldOption.selected,
        let formFieldOptionValue = formFieldOption.value else {
          XCTFail()
          return
      }
      
      XCTAssertEqual(formFieldOptionLabel, "Test Options Label")
      XCTAssertTrue(formFieldOptionSelected)
      XCTAssertEqual(formFieldOptionValue, "Test Options Value")
      
      guard let error = errors.first else {
        XCTFail()
        return
      }
      
      XCTAssertEqual(error.code, "ERROR_UNKNOWN")
      XCTAssertEqual(error.message, "Some nice conversations error message")
      
    } catch {
      print(error)
      XCTFail()
      return
    }
  }
  
  func testUploadJPG() {
    
    let expectation =
      self.expectation(description: "testUploadJPG")
    
    guard let image = BVPhotoSubmissionTest.createJPG() else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    let jpg: BVPhoto =
      BVPhoto(caption: "Hello?",
              contentType: .review,
              image: image)
    
    let photoSubmission: BVPhotoSubmission =
      BVPhotoSubmission(jpg)
        .configure(BVPhotoSubmissionTest.config)
        .handler
        { (result: BVConversationsSubmissionResponse<BVPhoto>) in
          
          guard case .success = result else {
            XCTFail()
            expectation.fulfill()
            return
          }
          
          expectation.fulfill()
    }
    
    photoSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
  
  func testUploadPNG() {
    
    let expectation =
      self.expectation(description: "testUploadJPG")
    
    guard let image = BVPhotoSubmissionTest.createPNG() else {
      XCTFail()
      expectation.fulfill()
      return
    }
    
    let jpg: BVPhoto =
      BVPhoto(caption: "Hello?",
              contentType: .review,
              image: image)
    
    let photoSubmission: BVPhotoSubmission =
      BVPhotoSubmission(jpg)
        .configure(BVPhotoSubmissionTest.config)
        .handler
        { (result: BVConversationsSubmissionResponse<BVPhoto>) in
          
          guard case .success = result else {
            XCTFail()
            expectation.fulfill()
            return
          }
          
          expectation.fulfill()
    }
    
    photoSubmission.async()
    
    self.waitForExpectations(timeout: 20) { (error) in
      XCTAssertNil(
        error, "Something went horribly wrong, request took too long.")
    }
  }
}
