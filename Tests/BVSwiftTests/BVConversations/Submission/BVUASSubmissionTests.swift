//
//
//  BVUASSubmissionTests.swift
//  BVSwift
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

import XCTest
@testable import BVSwift

class BVUASSubmissionTests: XCTestCase {

    private enum TestStyle {
        case fast
        case slow
    }
    
    private var testCoverage: TestStyle {
        return .fast
    }
    
    private static var config: BVConversationsConfiguration = { () -> BVConversationsConfiguration in
        
        let analyticsConfig: BVAnalyticsConfiguration =
          .dryRun(
            configType: .staging(clientId: "apitestcustomer"))
        
        return BVConversationsConfiguration.all(
          clientKey: "2cpdrhohmgmwfz8vqyo48f52g",
          configType: .staging(clientId: "apitestcustomer"),
          analyticsConfig: analyticsConfig)
    }()
    
    private var bvAuthToken:String {
      get {
        // Paste bv_authtoken below:
        return "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
      }
    }
    
    private var privateSession: URLSession = {
        return URLSession(configuration: .default)
    }()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        BVPixel.skipAllPixelEvents = true
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        BVPixel.skipAllPixelEvents = false
    }
    
    func testSwapAuthorTokenForUserAuthenticationString() {
        
        let expectation = self.expectation(description: "testSwapAuthorTokenForUserAuthenticationString")
        
        // VALIDATE: Please read and/or check this before submitting a SDK release.
        /**
         
         This concerns regression testing against the authenticateuser.json endpoint:
         
         In order to properly validate this test:
         1.) A test review needs to be generated using this conversationsapihostedauth user while also configuring for hosted authentication, i.e., https://developer.bazaarvoice.com/conversations-api/tutorials/submission/authentication/bv-mastered, with valid api parameters, e.g., "hostedauthentication_authenticationemail" and "hostedauthentication_callbackurl". One tip would be to pass a uniquely generated email address with the @mailtest.nexus.bazaarvoice.com prefix domain. Then you can acquire the body of the hosted authentication verification email here: https://s3.console.aws.amazon.com/s3/buckets/notifications-data/openmx/?region=us-east-1
         2.) Find the uniquely generated bitly within the body of the email and copy+paste into your favorite HTTP speaking tool and strip the redirect bv_authtoken parameter out.
         3.) Add that bv_authtoken string to the bvAuthToken computed property of this test.
         4.) Swap the testCoverage computed property to .slow
         5.) Run test(s) and hopefully all succeed.
         
         */
        switch testCoverage {
            
        case .slow:
            
            guard let uasSubmission: BVUASSubmission = BVUASSubmission(bvAuthToken: bvAuthToken) else {
                XCTFail()
                expectation.fulfill()
                return
            }
            
            uasSubmission.handler { (result: BVConversationsSubmissionResponse<BVUAS>) in
                
                if case let .failure(errors) = result {
                  errors.forEach { print("Expected Failure Item: \($0)") }
                  XCTFail()
                  expectation.fulfill()
                  return
                }
                
                guard case let .success(_, uas) = result else {
                  XCTFail()
                  expectation.fulfill()
                  return
                }
                
                expectation.fulfill()
            }
            .configure(BVUASSubmissionTests.config)
            uasSubmission.async()
            
            
        case .fast:
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
