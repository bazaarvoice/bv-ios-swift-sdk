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
    
    let curationsUrlMatch = "bazaarvoice.com/curations/content/get"
    let curationsPhotoPostUrlMatch = "https://api.bazaarvoice.com/curations/content/add/"
    let recommendationsUrlMatch = "bazaarvoice.com/recommendations"
    let profileUrlMatch = "bazaarvoice.com/users"
    let analyticsMatch = "bazaarvoice.com/event"
    let conversationsMatchReview = "bazaarvoice.com/data/reviews"
    let conversationsQuestionsMatch = "bazaarvoice.com/data/question"
    let conversationsProductMatch = "bazaarvoice.com/data/products"
    let conversationsAuthorsMatch = "bazaarvoice.com/data/authors"
    let conversationsReviewHighlightsMatch = "bazaarvoice.com/highlights"
    let submitReviewMatch = "bazaarvoice.com/data/submitreview"
    let submitReviewPhotoMatch = "bazaarvoice.com/data/uploadphoto"
    let submitQuestionMatch = "bazaarvoice.com/data/submitquestion"
    let submitAnswerMatch = "bazaarvoice.com/data/submitanswer"
    let pinRequestMatch = "bazaarvoice.com/pin/toreview"
    var pinReponse: Data?
    
    let headers = ["Content-Type": "application/json"]
    
    static let sharedInstance = MockDataManager()
    
    init() {
        self.setupMocking()
    }
    
    func shouldMockResponseForRequest(_ request: URLRequest) -> Bool {
        
        guard let url = request.url?.absoluteString else {
            return false
        }
        
        return self.shouldMockData() && (self.isAnalyticsRequest(url) || self.isSdkRequest(url));
        
    }
    
    func isAnalyticsRequest(_ url: String) -> Bool {
        return url.contains(analyticsMatch)
    }
    
    func isSdkRequest(_ url: String) -> Bool {
        
        let containsCurations = url.contains(curationsUrlMatch)
        let containsCurationsPhotoPost = url.contains(curationsPhotoPostUrlMatch)
        let containsProfile = url.contains(profileUrlMatch)
        let containsRecommendations = url.contains(recommendationsUrlMatch)
        let containsConversationsReviews = url.contains(conversationsMatchReview)
        let containsConversationsReviewHighlights = url.contains(conversationsReviewHighlightsMatch)
        let containsConversationsQuestions = url.contains(conversationsQuestionsMatch)
        let containsConversationsProducts = url.contains(conversationsProductMatch)
        let containsConversationsAuthors = url.contains(conversationsAuthorsMatch)
        let containsSubmitReviews = url.contains(submitReviewMatch)
        let containsSubmitPhotoReviews = url.contains(submitReviewPhotoMatch)
        let containsSubmitQuestion = url.contains(submitQuestionMatch)
        let containsSubmitAnswers = url.contains(submitAnswerMatch)
        let containsPINRequest = url.contains(pinRequestMatch)
        
        return containsCurations || containsCurationsPhotoPost || containsRecommendations || containsProfile || containsConversationsReviews || containsConversationsQuestions || containsConversationsProducts || containsConversationsAuthors || containsSubmitReviews || containsSubmitPhotoReviews || containsSubmitQuestion || containsSubmitAnswers || containsPINRequest || containsConversationsReviewHighlights
        
    }
    
    func shouldMockData() -> Bool {
        return true
    }
    
    func responseForSdkRequest(_ url: String) -> HTTPStubsResponse {
        
        //        return HTTPStubsResponse(
        //            jsonObject: generateRecommendationsResponseDictionary(),
        //            statusCode: 200,
        //            headers: ["Content-Type": "application/json"]
        //        )
        
        if url.contains(curationsUrlMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("curationsEnduranceCycles.json", type(of: self))!,
                statusCode: 200,
                headers: headers
            )
            
        }
        
        if url.contains(curationsPhotoPostUrlMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("post_successfulCreation.json", type(of: self))!,
                statusCode: 200,
                headers: headers
            )
            
        }
        
        
        if url.contains(recommendationsUrlMatch) {
            
            return HTTPStubsResponse(
                jsonObject: generateRecommendationsResponseDictionary(),
                statusCode: 200,
                headers: headers
            )
            
        }
        
        if url.contains(profileUrlMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("userProfile1.json", type(of: self))!,
                statusCode: 200,
                headers: headers
            )
            
        }
        
        if url.contains(conversationsMatchReview) {
            
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
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(conversationsQuestionsMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("conversationsQuestionsIncludeAnswers.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(conversationsReviewHighlightsMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("reviewHighlights.json", type(of: self))!,
                statusCode: 200,
                headers: headers
            )
        }
        
        if url.contains(conversationsProductMatch) {
            
            // In the demp app, when requesting product status we just use the Filter=Id:eq:<id> param
            // When we request a store list, we use the Offset parameter.
            // So we'll use that info
            if url.contains("Offset=0"){
                
                return HTTPStubsResponse(
                    fileAtPath: OHPathForFile("storeBulkFeedWithStatistics.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type": "application/json;charset=utf-8"]
                )
                
            } else {
                
                return HTTPStubsResponse(
                    fileAtPath: OHPathForFile("conversationsProductsIncludeStats.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type": "application/json;charset=utf-8"]
                )
                
            }
            
        }
        
        if url.contains(conversationsAuthorsMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("conversationsAuthorWithIncludes.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(submitReviewMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("submitReview.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(submitReviewPhotoMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("submitPhotoWithReview.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(submitQuestionMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("submitQuestion.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        if url.contains(submitAnswerMatch) {
            
            return HTTPStubsResponse(
                fileAtPath: OHPathForFile("submitAnswer.json", type(of: self))!,
                statusCode: 200,
                headers: ["Content-Type": "application/json;charset=utf-8"]
            )
            
        }
        
        //        if url.contains(convoStoresConfigMatch) {
        //
        //            return HTTPStubsResponse(
        //                fileAtPath: OHPathForFile("testNotificationConfig.json", type(of: self))!,
        //                statusCode: 200,
        //                headers: ["Content-Type": "application/json;charset=utf-8"]
        //            )
        //
        //        }
        
        //        if url.contains(pinConfigMatch) {
        //
        //            return HTTPStubsResponse(
        //                fileAtPath: OHPathForFile("testNotificationProductConfig.json", type(of: self))!,
        //                statusCode: 200,
        //                headers: ["Content-Type": "application/json;charset=utf-8"]
        //            )
        //        }
        
        if url.contains(pinRequestMatch) {
            return HTTPStubsResponse(data: pinReponse ?? "[]".data(using: .utf8)!,
                                     statusCode: 200,
                                     headers: ["Content-Type": "application/json;charset=utf-8"])
        }
        
        return HTTPStubsResponse()
    }
    
    func resposneForRequest(_ request: URLRequest) -> HTTPStubsResponse {
        
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
    func generateRecommendationsResponseDictionary() -> [String: AnyObject] {
        
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
