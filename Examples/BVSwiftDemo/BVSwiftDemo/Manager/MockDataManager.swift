//
//  MockDataManager.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 02/07/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit
import OHHTTPStubs
import SwiftyJSON

class MockDataManager {
    
    var pinReponse: Data?
    static let sharedInstance = MockDataManager()
    
    init() {
        self.setupMocking()
    }
    
    private func shouldMockResponseForRequest(_ request: URLRequest) -> Bool {
        
        guard let url = request.url?.absoluteString else {
            return false
        }
        
        return (self.isAnalyticsRequest(url) || self.isSdkRequest(url))
        
    }
    
    private func isAnalyticsRequest(_ url: String) -> Bool {
        return url.contains(URLConstants.analyticsMatch)
    }
    
    private func isSdkRequest(_ url: String) -> Bool {
        
        let containsCurations = url.contains(URLConstants.curationsUrlMatch)
        let containsCurationsPhotoPost = url.contains(URLConstants.curationsPhotoPostUrlMatch)
        let containsProfile = url.contains(URLConstants.profileUrlMatch)
        let containsRecommendations = url.contains(URLConstants.recommendationsUrlMatch)
        let containsConversationsReviews = url.contains(URLConstants.conversationsMatchReview)
        let containsConversationsReviewHighlights = url.contains(URLConstants.conversationsReviewHighlightsMatch)
        let containsConversationsQuestions = url.contains(URLConstants.conversationsQuestionsMatch)
        let containsConversationsProducts = url.contains(URLConstants.conversationsProductMatch)
        let containsConversationsAuthors = url.contains(URLConstants.conversationsAuthorsMatch)
        let containsConversationsReviewSummary = url.contains(URLConstants.conversationsReviewSummary)
        let containsSubmitReviews = url.contains(URLConstants.submitReviewMatch)
        let containsSubmitPhotoReviews = url.contains(URLConstants.submitReviewPhotoMatch)
        let containsSubmitQuestion = url.contains(URLConstants.submitQuestionMatch)
        let containsSubmitAnswers = url.contains(URLConstants.submitAnswerMatch)
        let containsPINRequest = url.contains(URLConstants.pinRequestMatch)
        
        return containsCurations || containsCurationsPhotoPost || containsRecommendations || containsProfile || containsConversationsReviews || containsConversationsQuestions || containsConversationsProducts || containsConversationsReviewSummary || containsConversationsAuthors || containsSubmitReviews || containsSubmitPhotoReviews || containsSubmitQuestion || containsSubmitAnswers || containsPINRequest || containsConversationsReviewHighlights
        
    }
    
    private func responseForSdkRequest(_ url: String) -> HTTPStubsResponse {
        
        if url.contains(URLConstants.curationsUrlMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("curationsEnduranceCycles.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header
            )
        }
        
        if url.contains(URLConstants.curationsPhotoPostUrlMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("post_successfulCreation.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header
            )
        }
        
        if url.contains(URLConstants.recommendationsUrlMatch) {
            
            return HTTPStubsResponse(
                jsonObject: generateRecommendationsResponseDictionary(),
                statusCode: 200,
                headers: Headers.header
            )
        }
        
        if url.contains(URLConstants.profileUrlMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("userProfile1.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header
            )
        }
        
        if url.contains(URLConstants.conversationsReviewSummary) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("conversationsReviewSummary.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header
            )
        }
        
        if url.contains(URLConstants.conversationsMatchReview) {
            
            // Conversations requests will vary depending on parameters
            // Hence check for specific parameters to set mock results.
            
            var conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles.json" // default, sorted by most recent
            
            if url.contains("Sort=Rating:desc"){
                conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles_SortHighestRated.json"
            } else if url.contains("Sort=Rating:asc"){
                conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles_SortLowestRated.json"
            } else if url.contains("Sort=Helpfulness:desc"){
                conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles_SortMostHelpful.json"
            } else if url.contains("UserLocation:eq"){
                conversationsReviewsResultMockFile = "conversationsReviewsEnduranceCycles_FilterLocation.json"
            }
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile(conversationsReviewsResultMockFile, type(of: self))!,
                statusCode: 200,
                headers: Headers.header_utf8
            )
        }
        
        if url.contains(URLConstants.conversationsQuestionsMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("conversationsQuestionsIncludeAnswers.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header_utf8
            )
        }
        
        if url.contains(URLConstants.conversationsReviewHighlightsMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("reviewHighlights.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header
            )
        }
        
        if url.contains(URLConstants.conversationsProductMatch) {
            
            // In the demp app, when requesting product status we just use the Filter=Id:eq:<id> param
            // When we request a store list, we use the Offset parameter.
            // So we'll use that info
            if url.contains("Offset=0"){
                
                return HTTPStubsResponse(
                    fileAtPath: OHPathForFile("storeBulkFeedWithStatistics.json", type(of: self))!,
                    statusCode: 200,
                    headers: Headers.header_utf8
                )
                
            } else {
                
                return HTTPStubsResponse(
                    fileAtPath: OHPathForFile("conversationsProductsIncludeStats.json", type(of: self))!,
                    statusCode: 200,
                    headers: Headers.header_utf8
                )
            }
        }
        
        if url.contains(URLConstants.conversationsAuthorsMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("conversationsAuthorWithIncludes.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header_utf8
            )
        }
        
        if url.contains(URLConstants.submitReviewMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("submitReview.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header_utf8
            )
        }
        
        if url.contains(URLConstants.submitReviewPhotoMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("submitPhotoWithReview.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header_utf8
            )
        }
        
        if url.contains(URLConstants.submitQuestionMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("submitQuestion.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header_utf8
            )
        }
        
        if url.contains(URLConstants.submitAnswerMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("submitAnswer.json", type(of: self))!,
                statusCode: 200,
                headers: Headers.header_utf8
            )
        }
        
        if url.contains(URLConstants.pinRequestMatch) {
            return HTTPStubsResponse(data: pinReponse ?? "[]".data(using: .utf8)!,
                                     statusCode: 200,
                                     headers: Headers.header_utf8)
        }
        
        return HTTPStubsResponse()
    }
    
    private func resposneForRequest(_ request: URLRequest) -> HTTPStubsResponse {
        
        print("Mocking request: \(request.url!.absoluteString)")
        
        guard let url = request.url?.absoluteString else {
            return HTTPStubsResponse()
        }
        
        return self.responseForSdkRequest(url)
        
    }
    
    func setupMocking() {
        
        HTTPStubs.stubRequests(passingTest: { (request) -> Bool in
            
            return self.shouldMockResponseForRequest(request)
            
        }) { (request) -> HTTPStubsResponse in
            
            return self.resposneForRequest(request)
            
        }
    }
    
    /// randomize the recommendations in JSON file for variation between loads.
    private func generateRecommendationsResponseDictionary() -> [String: AnyObject] {
        
        guard let path = Bundle.main.path(forResource: "recommendationsResult", ofType: "json") else {
            print("Invalid filename/path.")
            return [:]
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
            var json = try JSON(data: data)
            
            let recommendations:[String] = json["profile"]["recommendations"].arrayValue.map { $0.string!}
            // randomize order
            let shuffledRecommendations = recommendations.sorted() {_, _ in arc4random() % 2 == 0}
            json["profile"]["recommendations"] = JSON(shuffledRecommendations)
            
            return json.dictionaryObject! as [String : AnyObject]
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return [:]
    }
    
}
