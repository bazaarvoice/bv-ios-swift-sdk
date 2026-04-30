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
        
        return BVConversationsConfiguration.videoSubmission(
            clientKey: BVTestKeys.conversationsKey,
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
    
    // MARK: - Request Construction Tests
    
    private static let kAuthKeyParam = BVConversationsConstants.BVVideo.Keys.passKey
    private static let kApiVersionParam = BVConversationsConstants.BVVideo.Keys.apiVersion
    
    @available(iOS 16.0, *)
    func testVideoUploadRequestHasAuthKeyInQueryParams() throws {
        guard let path = BVVideoSubmissionTest.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideo(URL(filePath: path), caption: "Test Video", uploadVideo: true)
        
        guard let videoSubmission = BVVideoSubmission(video: video) else {
            XCTFail("Could not create BVVideoSubmission")
            return
        }
        
        videoSubmission.configure(BVVideoSubmissionTest.config)
        
        guard let request = videoSubmission.request,
              let url = request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            XCTFail("Could not get URL or query items from request")
            return
        }
        
        let authKey = queryItems.first(where: { $0.name == BVVideoSubmissionTest.kAuthKeyParam })?.value
        XCTAssertNotNil(authKey, "auth key should be present as a URL query parameter")
        XCTAssertEqual(authKey, BVTestKeys.conversationsKey,
                       "auth key should match the configured client key")
    }
    
    @available(iOS 16.0, *)
    func testVideoUploadRequestHasApiVersionInQueryParams() throws {
        guard let path = BVVideoSubmissionTest.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideo(URL(filePath: path), caption: "Test Video", uploadVideo: true)
        
        guard let videoSubmission = BVVideoSubmission(video: video) else {
            XCTFail("Could not create BVVideoSubmission")
            return
        }
        
        videoSubmission.configure(BVVideoSubmissionTest.config)
        
        guard let request = videoSubmission.request,
              let url = request.url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            XCTFail("Could not get URL or query items from request")
            return
        }
        
        let apiversion = queryItems.first(where: { $0.name == BVVideoSubmissionTest.kApiVersionParam })?.value
        XCTAssertEqual(apiversion, "5.4",
                       "apiversion query param should be 5.4")
    }
    
    @available(iOS 16.0, *)
    func testVideoUploadRequestHasCorrectEndpoint() throws {
        guard let path = BVVideoSubmissionTest.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideo(URL(filePath: path), caption: "Test Video", uploadVideo: true)
        
        guard let videoSubmission = BVVideoSubmission(video: video) else {
            XCTFail("Could not create BVVideoSubmission")
            return
        }
        
        videoSubmission.configure(BVVideoSubmissionTest.config)
        
        guard let request = videoSubmission.request,
              let url = request.url else {
            XCTFail("Could not get URL from request")
            return
        }
        
        XCTAssertTrue(url.absoluteString.contains("uploadvideo.json"),
                      "URL should contain uploadvideo.json endpoint")
    }
    
    @available(iOS 16.0, *)
    func testVideoUploadRequestIsPostMethod() throws {
        guard let path = BVVideoSubmissionTest.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideo(URL(filePath: path), caption: "Test Video", uploadVideo: true)
        
        guard let videoSubmission = BVVideoSubmission(video: video) else {
            XCTFail("Could not create BVVideoSubmission")
            return
        }
        
        videoSubmission.configure(BVVideoSubmissionTest.config)
        
        guard let request = videoSubmission.request else {
            XCTFail("Could not get request")
            return
        }
        
        XCTAssertEqual(request.httpMethod, "POST",
                       "Video upload should use POST method")
    }
    
    @available(iOS 16.0, *)
    func testVideoUploadRequestHasMultipartContentType() throws {
        guard let path = BVVideoSubmissionTest.getVideoPath() else {
            XCTFail("Could not get video path")
            return
        }
        
        let video = BVVideo(URL(filePath: path), caption: "Test Video", uploadVideo: true)
        
        guard let videoSubmission = BVVideoSubmission(video: video) else {
            XCTFail("Could not create BVVideoSubmission")
            return
        }
        
        videoSubmission.configure(BVVideoSubmissionTest.config)
        
        guard let request = videoSubmission.request,
              let contentType = request.value(forHTTPHeaderField: "Content-Type") else {
            XCTFail("Could not get Content-Type header from request")
            return
        }
        
        XCTAssertTrue(contentType.contains("multipart/form-data"),
                      "Content-Type should be multipart/form-data")
    }
}
