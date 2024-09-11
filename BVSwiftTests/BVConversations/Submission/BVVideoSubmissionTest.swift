//
//
//  BVVideoSubmissionTest.swift
//  BVSwift
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
//

import XCTest
@testable import BVSwift

final class BVVideoSubmissionTest: XCTestCase {
    
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
    
    internal class func getVideoPath() -> String? {
        let bundle = Bundle(for: BVVideoSubmissionTest.self)
        guard let path = bundle.path(forResource: "testVideo", ofType: "mp4")
        else {
            debugPrint("testVideo.mp4 not found")
            return nil
        }
        return path
    }
    
    override func setUpWithError() throws {
        BVPixel.skipAllPixelEvents = true
        BVManager.sharedManager.logLevel = .debug
    }
    
    override func tearDownWithError() throws {
        BVPixel.skipAllPixelEvents = false
        BVManager.sharedManager.logLevel = .error
    }
    
    func testUploadVideoFailure() throws {
        let bundle = Bundle(for: BVVideoSubmissionTest.self)
        guard let path = bundle.path(forResource: "invalidVideoName", ofType: "mp4")
        else {
            debugPrint("video not found")
            return
        }
        debugPrint(path)
        XCTFail()
    }
    
    @available(iOS 16.0, *)
    func testUploadVideo() throws {
        
        let expectation =
        self.expectation(description: "testUploadVideo")
        
        guard let path = BVVideoSubmissionTest.getVideoPath() else {
            XCTFail()
            expectation.fulfill()
            return
        }
        
        let video: BVVideo = BVVideo(URL(filePath: path), caption: "Test Video", uploadVideo: true)
        
        guard let videoSubmission: BVVideoSubmission = BVVideoSubmission(video: video) else {
            XCTFail()
            expectation.fulfill()
            return
        }
        videoSubmission
            .configure(BVVideoSubmissionTest.config)
            .handler { (response: BVConversationsSubmissionResponse<BVVideo>) in
                
                if case let .failure(errors) = response {
                    print(errors)
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                guard case let .success(meta, result) = response,
                      let formFields = meta.formFields else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                
                XCTAssertEqual(formFields.count, 1)
                XCTAssertEqual(formFields.first?.identifier, "video")
                XCTAssertNotNil(result.videoUrl)
                
                expectation.fulfill()
            }
        videoSubmission.async()
        
        self.waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(
                error, "Something went horribly wrong, request took too long.")
        }
    }
}
