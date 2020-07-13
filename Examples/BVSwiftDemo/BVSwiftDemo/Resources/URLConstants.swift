//
//  Constants.swift
//  BVSwiftDemo
//
//  Created by Abhinav Mandloi on 06/07/2020.
//  Copyright © 2020 Bazaarvoice. All rights reserved.
//

import UIKit

class URLConstants {
    
    static let curationsPhotoPostUrlMatch = "bazaarvoice.com/curations/content/get"
    static let curationsUrlMatch = "https://api.bazaarvoice.com/curations/c3/content/"
    static let recommendationsUrlMatch = "bazaarvoice.com/recommendations"
    static let profileUrlMatch = "bazaarvoice.com/users"
    static let analyticsMatch = "bazaarvoice.com/event"
    static let conversationsMatchReview = "bazaarvoice.com/data/reviews"
    static let conversationsQuestionsMatch = "bazaarvoice.com/data/question"
    static let conversationsProductMatch = "bazaarvoice.com/data/products"
    static let conversationsAuthorsMatch = "bazaarvoice.com/data/authors"
    static let conversationsReviewHighlightsMatch = "bazaarvoice.com/highlights"
    static let submitReviewMatch = "bazaarvoice.com/data/submitreview"
    static let submitReviewPhotoMatch = "bazaarvoice.com/data/uploadphoto"
    static let submitQuestionMatch = "bazaarvoice.com/data/submitquestion"
    static let submitAnswerMatch = "bazaarvoice.com/data/submitanswer"
    static let pinRequestMatch = "bazaarvoice.com/pin/toreview"
    
}

class AppConstants {
    static let appName = "bazaarvoice:"
}

class Headers {
    static let header = ["Content-Type": "application/json"]
    static let header_utf8 = ["Content-Type": "application/json;charset=utf-8"]
}

class AdKey {
    static let adUnitId = "/5705/bv-incubator/IncubatorEnduranceCycles"
}
